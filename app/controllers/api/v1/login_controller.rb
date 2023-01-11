class Api::V1::LoginController < ApplicationController
  def join_with_email
    email = params[:email]
    data = Auth.join_with_email(email)

    render json: data
  end

  def login_with_email
    email = params[:email]
    password = request.headers['password']
    data = Auth.login_with_email(email, password)

    render json: data
  end

  def login_with_token
    token = params[:token]
    user_id = params[:user_id]
    data = Auth.login_with_token(token, user_id)

    render json: data
  end

  def create_account
    token = params[:token]
    email = params[:email]
    password = request.headers['password']

    data = Auth.create_account(token, email, password)
    render json: data
  end

  def reset_password
    token = params[:token]
    password = request.headers['password']
    user_id = params[:user_id]

    data = Auth.reset_password(token, user_id, password)
    render json: data
  end
end