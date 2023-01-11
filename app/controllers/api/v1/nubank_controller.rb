class Api::V1::NubankController < ApplicationController
  def auth
    user_id = params[:userId]
    token = params[:sessionId]

    return render json: { error: 'Invalid token' }, status: :unauthorized unless validateUserToken(user_id, token)
    
    password = params[:password]
    user = NubankSdk::User.new(cpf: params[:cpf])

    begin
      return render json: { message: 'Already authenticated' }, status: :ok if get_nubank_token(user_id, params[:cpf])

      user.auth.authenticate_with_certificate(password)
      save_nubank_tokens(user_id, user, params[:cpf])
      return render json: { message: 'Authenticated' }, status: :ok

    # rescue => exception
    #   begin
    #     account_email = user.auth.request_email_code(password)
    #     return render json: { message: "send the code sent to #{account_email} to /nubank/:cpf/auth/email" }, status: :partial_content
    #     # todo salvar as keys aqui para o proximo 'auth/email'
    #   rescue => exception
    #     return render json: { error: 'Invalid password' }, status: :unauthorized
    #   end
    end
  end

  def account_balance
    user_id = params[:userId]
    token = params[:sessionId]

    return render json: { error: 'Invalid token' }, status: :unauthorized unless validateUserToken(user_id, token)
    
    password = params[:password]
    user = NubankSdk::User.new(cpf: params[:cpf])

    begin
      auto_auth_dot_dot_dot(user, password)
      return render json: { balance: user.account.balance }, status: :ok
    end
  end

  def account_feed
    user_id = params[:userId]
    token = params[:sessionId]

    return render json: { error: 'Invalid token' }, status: :unauthorized unless validateUserToken(user_id, token)
    
    password = params[:password]
    user = NubankSdk::User.new(cpf: params[:cpf])

    begin
      auto_auth_dot_dot_dot(user, password)
      return render(json: process_feed(user), status: :ok)
    end
  end

  private

  def validateUserToken(user_id, token)
    redis = Redis.new
    redis_key = "user:#{user_id}:#{token}"

    redis.get redis_key
  end

  def save_nubank_tokens(user_id, user, cpf)
    access_token = user.auth.access_token
    refresh_before = user.auth.refresh_before

    redis = Redis.new

    redis_key = "user:#{user_id}:nubank:#{cpf}:access_token"
    redis.set redis_key, access_token
    # redis.expire redis_key, refresh_before.to_i
  end

  def get_nubank_token(user_id, cpf)
    redis = Redis.new
    redis_key = "user:#{user_id}:nubank:#{cpf}:access_token"

    redis.get redis_key
  end

  def auto_auth_dot_dot_dot(user,password)
    begin
      user.auth.authenticate_with_certificate(password)
    rescue => exception
      return render json: { error: 'Invalid password' }, status: :unauthorized
    end
  end

  def process_feed(user)
    user_account_feed = user.account.feed
    future_transactions = user_account_feed.select do |transaction|
      transaction[:__typename] == 'ScheduledBarcodePaymentRequestEvent' ||
      (transaction[:__typename] == 'GenericFeedEvent' && (transaction[:title] == 'Pagamento agendado' || transaction[:title] == 'Transferência agendada'))
    end
    future_transactions.map! { |transaction| transaction.merge amount: transaction[:detail].split(/[^\d]/).join.to_f / 100 }
    total_future_transactions = future_transactions.sum { |transaction| transaction[:amount] }
    {
      future_transactions: future_transactions,
      total_future_transactions: total_future_transactions,
      user_account_feed: user_account_feed
    }
  end
end