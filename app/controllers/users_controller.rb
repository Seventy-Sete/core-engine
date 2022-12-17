class UsersController < ApplicationController
  def index
    render json: { message: 'Hello from UsersController' }
  end

  def show
    @user = User.find(params[:id])

    render json: @user
  end
end
