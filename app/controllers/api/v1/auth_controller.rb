class Api::V1::AuthController < ApplicationController
  def join_with_email
    email = params[:email]

    render json: Clients::Auth.join_with_email(email)
  end

  def login_with_email
    email = params[:email]
    password = request.headers['password']

    render json: Clients::Auth.login_with_email(email, password)
  end

  def login_with_token
    token = params[:token]
    user_id = params[:user_id]

    render json: Clients::Auth.login_with_token(token, user_id)
  end

  def create_account
    token = params[:token]
    email = params[:email]
    password = request.headers['password']

    render json: Clients::Auth.create_account(token, email, password)
  end

  def reset_password
    token = params[:token]
    user_id = params[:user_id]
    password = request.headers['password']

    render json: Clients::Auth.reset_password(token, user_id, password)
  end
end
