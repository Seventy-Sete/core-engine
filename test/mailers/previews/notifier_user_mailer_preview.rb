# Preview all emails at http://localhost:3000/rails/mailers/notifier_user_mailer
class NotifierUserMailerPreview < ActionMailer::Preview
  def new_account
    NotifierUserMailer.with(email: "email@seventysete.com").new_account("token")
  end

  def reset_password
    NotifierUserMailer.with(email: "email@seventysete.com").reset_password("user_id", "token")
  end
end
