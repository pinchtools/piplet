# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

unless User.exists?
    User.create!(username: "Example",
      email: "example@piplet.io",
      password: "foobarfoobar",
      password_confirmation: "foobarfoobar",
      admin: true,
      activated: true,
      activated_at: Time.zone.now,
      creation_ip_address: '127.6.4.98',
      activation_ip_address: '127.6.4.98')


    49.times do |n|
        name = "example-#{n+1}"
        email = "example-#{n+1}@piplet.io"
        password = "foobarfoobar"

        User.create!(username: name,
        email: email,
        password: password,
        password_confirmation: password,
        activated: true,
        activated_at: Time.zone.now,
        creation_ip_address: '127.6.4.98',
        activation_ip_address: '127.6.4.98')
    end

    p "Users created"
else
  p "Users table already populated"
end

unless Site.exists?
  Site.create!( name: "Default" )

  p "Default site created"
else
  p "Default site already exists"
end