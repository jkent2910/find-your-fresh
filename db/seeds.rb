# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_farms
  50.times do |n|
    email = Faker::Internet.email
    password = "password"
    password_confirmation = "password"
    user_type = 1

    user = User.create!(email: email, password: password, password_confirmation: password_confirmation, user_type: user_type)
    create_farm_profile(user.id)
    p "creating farm #{user.email}"
  end
end

def create_farm_profile(user_id)
  farm = Farm.create!(user_id: user_id, website_url: Faker::Internet.url, name: Faker::Company.name,
                          year_founded: [1900..2017].sample, contact_phone: Faker::PhoneNumber.phone_number,
                          street_address: Faker::Address.street_address, city: Faker::Address.city, contact_email: Faker::Internet.email,
                          state: Faker::Address.state, zipcode: Faker::Address.zip, description: Faker::Lorem.paragraph(2))

  p "creating farm #{farm.name}"
end

create_farms