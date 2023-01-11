class NotifierUserMailer < ApplicationMailer
  def new_account(token)
    @email = params[:email]
    @token = token
    @host = "http://localhost:3000/"
    @path = "api/v1/auth/create-account/"
    @support_email = "core-engine@seventysete.com"
    @app_name = "Seventy Sete"

    mail(
      to: @email,
      subject: 'Create your account!',
    )
  end

  def reset_password(user_id, token)
    @email = params[:email]
    @token = token
    @user_id = user_id
    @host = "http://localhost:3000/"
    @path = "api/v1/auth/reset-password/"
    @support_email = "core-engine@seventysete.com"
    @app_name = "Seventy Sete"

    mail(
      to: @email,
      subject: 'Reset your password!',
    )
  end
end
