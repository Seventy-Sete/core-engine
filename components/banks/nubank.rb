require 'nubank_sdk'

module Banks
  class Nubank
    def initialize(user_id, user_bank_id = nil)
      @user = User.find(user_id)

      if user_bank_id
        @user_bank = @user.user_banks.find(user_bank_id)
      end
    end

    def new_auth_to(bcn)
      user_bank = @user.user_banks.create(bank_name: :nubank, bcn: bcn)

      {
        user_bank_id: user_bank.id,
        follow_up: :request_email_code
      }
    end

    def request_email_code(password)
      sent_email = user.auth.request_email_code(password)
      encrypted_code = user.auth.encrypted_code
      p_key = user.auth.p_key.to_pem

      save_codes(encrypted_code, p_key)

      {
        follow_up: :exchange_certificates,
        check_user_email: sent_email
      }
    end

    def exchange_certificates(email_code, password)
      recovered_codes = recovery_codes

      user.auth.encrypted_code = recovered_codes[:encrypted_code]
      user.auth.p_key = OpenSSL::PKey::RSA.new(recovered_codes[:p_key])

      user.auth.exchange_certificates(email_code, password)
      new_token(password)

      {
        follow_up: :account_details,
        action: :certification_success
      }
    end

    def new_token(password)
      user.auth.authenticate_with_certificate password

      token = user.auth.access_token
      refresh_token = user.auth.refresh_token
      refresh_before = user.auth.refresh_before

      save_bank_tokens(token, refresh_token, refresh_before)
    end

    def account_balance
      user.account.balance
    end

    def credit_balances
      user.credit.balances
    end

    def account_feed
      format_transactions user.account.feed
    end

    private

    def format_transactions(transactions)
      transactions.map do |transaction|
        {
          title: transaction[:title],
          amount: extract_amount(transaction[:detail]),
          due_date: transaction[:postDate],
          tags: [],
          transaction_id: transaction[:id],
          purpose: purpose(transaction)
        }
      end
    end

    def extract_amount(detail)
      match = detail.match(/R\$\s*(\d+(?:\.\d+)?)/)
      return match[1].to_f if match
    end

    def purpose(transaction)
      case transaction[:__typename]
      when "ScheduledBarcodePaymentRequestEvent"
        "scheduled"
      when "GenericFeedEvent"
        case transaction[:title]
        when "Transferência agendada", "Transferência enviada"
          "transfer"
        when "Transferência recebida"
          "deposit"
        when "Venda de Criptomoeda"
          "withdrawal"
        else
          "other"
        end
      end
    end
    
    def user
      @user || NubankSdk::User.new(cpf: @user_bank.bcn)
    end

    def save_codes(encrypted_code, p_key)
      data = {
        encrypted_code: encrypted_code,
        p_key: p_key
      }

      redis = Redis.new
      redis_key = Storage::Keys.user_bank_data(@user_bank.id)

      redis.hmset(redis_key, data)
    end

    def recovery_codes
      redis = Redis.new
      redis_key = Storage::Keys.user_bank_data(@user_bank.id)

      data = redis.hgetall(redis_key)
      redis.expire(redis_key, 7.hours.to_i)
      {
        encrypted_code: data['encrypted_code'],
        p_key: OpenSSL::PKey::RSA.new(data['p_key'])
      }
    end

    def save_bank_tokens(token, refresh_token, refresh_before)
      puts "*******************************************"
      puts refresh_before
      # todo add 'expires_at' to tokens

      data = {
        token: token,
        refresh_token: refresh_token,
      }

      redis = Redis.new
      redis_key = Storage::Keys.user_bank_tokens(@user_bank.id)

      redis.hmset(redis_key, data)
      redis.expireat(redis_key, refresh_before)
    end

    def recovery_bank_tokens
      redis = Redis.new
      redis_key = Storage::Keys.user_bank_tokens(@user_bank.id)

      data = redis.hgetall(redis_key)
      {
        token: data['token'],
        refresh_token: data['refresh_token']
      }
    end
  end
end
