class UsersController < ApplicationController
  def index
    render json: { message: 'Hello from UsersController' }
  end

  def show
    @user = User.find(params[:uuid])

    render json: @user
  end
end
