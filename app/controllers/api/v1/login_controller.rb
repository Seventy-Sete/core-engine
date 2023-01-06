class Api::V1::LoginController < ApplicationController
  def join
    email = params[:email]
    has_user = !!User.find_by(email: email)

    User.create email: email unless has_user
    render json: User.find_by(email: email)
  end

  def auth
    user_id = params[:user_id]
    user = User.find user_id
    
    token = generate_bear_token
    save_session user_id, token

    render json: { token: token }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  private

  def generate_bear_token
    SecureRandom.hex(32)
  end

  def token_expiration
    2.hours
  end

  def save_session(user_id, token)
    redis = Redis.new
    redis_key = "user:#{user_id}:#{token}"
    redis_expiration = token_expiration.to_i

    redis.set redis_key, true
    redis.expire redis_key, redis_expiration
  end
end