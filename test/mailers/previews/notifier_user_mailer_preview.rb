# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notifier_user_mailer
class NotifierUserMailerPreview < ActionMailer::Preview
  def welcome_email
    NotifierUserMailer.with(user:).welcome_email
  end

  def new_account
    NotifierUserMailer.with(user:).new_account('token')
  end

  def reset_password
    NotifierUserMailer.with(user:).reset_password(user.id, 'token')
  end

  private

  def user
    @user ||= User.first || User.build(email: 'email@seventysete.com', password: '123456')
  end
end
