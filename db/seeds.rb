require 'faker'

User.create(
  email: 'core-engine@seventysete.com',
  password: 'from_seed'
)

(7-1).times do
  User.create(
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
end

7.times do
  UserBank.create(
    user_id: User.all.sample.id,
    bank_name: Faker::Bank.name,
    bcn: Faker::IDNumber.brazilian_citizen_number,
    access_key: SecureRandom.uuid,
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