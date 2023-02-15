# frozen_string_literal: true

require 'faker'

dev_email = 'core-engine@seventysete.com'
unless User.find_by(email: dev_email)
  User.create(
    email: dev_email,
    password: 'from_seed'
  )
end

unless User.count > 1
  (7 - 1).times do
    User.create(
      email: Faker::Internet.email,
      password: Faker::Internet.password
    )
  end
end

7.times do
  UserBank.create(
    user_id: User.all.sample.id,
    bank_name: Faker::Bank.name,
    bcn: Faker::IDNumber.brazilian_citizen_number,
    access_key: SecureRandom.uuid,
    bank: :default,
    status: :active
  )
end

7.times do
  BankTransaction.create(
    title: Faker::Lorem.sentence,
    user_bank_id: UserBank.all.sample.id,
    transaction_id: SecureRandom.uuid,
    amount: Faker::Number.decimal(l_digits: (1..7).to_a.sample),
    purpose: BankTransaction.purposes.keys.sample,
    due_date: Faker::Time.between_dates(from: 7.days.ago, to: 7.days.from_now, period: :all),
    tags: Faker::Lorem.words(number: (0..7).to_a.sample)
  )
end

7.times do
  BankDetail.create(
    user_bank_id: UserBank.all.sample.id,
    balance: Faker::Number.decimal(l_digits: (1..7).to_a.sample),
    reference: Faker::Time.between_dates(from: 7.days.ago, to: 7.days.from_now, period: :all).strftime('%Y%m').to_i,
    incoming: Faker::Number.decimal(l_digits: (1..7).to_a.sample),
    outgoing: Faker::Number.decimal(l_digits: (1..7).to_a.sample)
  )
end
