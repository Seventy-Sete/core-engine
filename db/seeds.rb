require 'faker'

User.delete_all

7.times do
  User.create(
    id: Faker::Internet.uuid,
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    nickname: Faker::Name.name,
  )
end
