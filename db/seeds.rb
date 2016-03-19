# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

User.create!(username: "Example",
  email: "example@piplet.io",
  password: "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now,
  creation_ip_address: '127.6.4.98',
  activation_ip_address: '127.6.4.98')

49.times do |n|
    name = "fastandfurious#{n+1}"
    email = "example-#{n+1}@piplet.io"
    password = "foobar"
    
    User.create!(username: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now,
    creation_ip_address: '127.6.4.98',
    activation_ip_address: '127.6.4.98')
end