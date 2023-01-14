class NotifierUserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: "Welcome to #{Rails.configuration.application_name}")
  end

  def new_account(token)
    @user = params[:user]
    @token = token
    @link = "#{Rails.configuration.action_mailer.default_url_options[:host]}/create-account/#{token}?email=#{@user.email}"
    mail(to: @user.email, subject: "#{Rails.configuration.application_name} - New Account")
  end

  def reset_password(token)
    @user = params[:user]
    @token = token
    @link = "#{Rails.configuration.action_mailer.default_url_options[:host]}/reset-password/#{token}/#{@user.id}"
    mail(to: @user.email, subject: "#{Rails.configuration.application_name} - Reset Password")
  end
end
