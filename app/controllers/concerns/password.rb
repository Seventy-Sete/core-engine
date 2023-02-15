# frozen_string_literal: true

module Password
  extend ActiveSupport::Concern

  def strong_password?(password)
    # Use a regex to check for a strong password
    # 1. At least 8 characters
    # 2. At least 1 uppercase letter
    # 3. At least 1 lowercase letter
    # 4. At least 1 digit
    # 5. At least 1 special character
    # 6. No whitespace
    # 7. No repeating characters
    # 8. No repeating sequences
    # 9. No repeating sequences of reversed characters
    # 10. No dictionary words
    # 11. No dictionary words reversed
    # 12. No dictionary words with a number appended
    # 13. No dictionary words with a number prepended
    # 14. No dictionary words with a special character appended
    # 15. No dictionary words with a special character prepended
    # 16. No dictionary words with a number and special character appended
    # 17. No dictionary words with a number and special character prepended
    # 18. No dictionary words with a number and special character in the middle
    # TODO: create this regex plz

    password =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{8,}$/
  end
end
