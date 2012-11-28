# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Automatisches einspielen von Testdaten per rake db:seed

# User
user_admin = User.create(firstname: "Admin", lastname: "Adminstrator", email: "admin@admin.com", password: "cisco", password_confirmation: "cisco", admin: "true", active:"true")
user_user = User.create(firstname: "User", lastname: "Username", email: "user@user.com", password: "cisco", password_confirmation: "cisco", active:"true")

# Kaffeerunden
kf1 = CoffeeBox.create(location: "Zr. 205", time: "2012-01-01 09:00:00", description: "Gemütliche Kaffeerunde!")
kf1.admin=user_admin
kf1.save
kf1.price_of_coffees << PriceOfCoffee.create(price: 0.50)
kf2 = CoffeeBox.create(location: "Zr. 110", time: "2012-01-01 13:00:00", description: "Mittagsrunde")
kf2.admin=user_user
kf2.save
kf2.price_of_coffees << PriceOfCoffee.create(price: 0.55)


