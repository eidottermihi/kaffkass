# encoding: utf-8

# Automatisches einspielen von Testdaten per rake db:seed
# Bei Rake db:setup werden Seeds ebenfalls eingespielt

# User
user_admin = User.create(firstname: "Darth", lastname: "Vader", email: "admin@kaffkass.com", password: "cisco1", password_confirmation: "cisco1", admin: "true", active:"true")
user_luke = User.create(firstname: "Luke", lastname: "Skywalker", email: "luke@kaffkass.com", password: "cisco1", password_confirmation: "cisco1", active:"true")
user_han = User.create(firstname: "Han", lastname: "Solo", email: "han@kaffkass.com", password: "cisco1", password_confirmation: "cisco1", active:"true")
user_obi = User.create(firstname: "Obi-Wan", lastname: "Kenobi", email: "obi-wan@kaffkass.com", password: "cisco1", password_confirmation: "cisco1", active:"true")

# Kaffeerunden
kf1 = CoffeeBox.create(location: "Zr. 205", time: "2012-01-01 09:00:00", description: "Gemütliche Kaffeerunde!", saldo: 5.00, cash_position: 0)
kf1.admin=user_admin
kf1.price_of_coffees << PriceOfCoffee.create(price: 0.50, date: Date.today())
kf1.save

kf2 = CoffeeBox.create(location: "Zr. 110", time: "2012-01-01 13:00:00", description: "Mittagsrunde", saldo: 0, cash_position: 3.12)
kf2.admin=user_luke
kf2.price_of_coffees << PriceOfCoffee.create(price: 0.55, date: Date.today())
kf2.save

# Teilnahmen Darth
Participation.create(coffee_box: kf1, user: user_admin, is_active: true)
ModelOfConsumption.create(coffee_box: kf1, user: user_admin, mo: 2, tue: 4, wed: 1, th: 2 , fr: 2, sa: 0, su: 0)
Consumption.create_month(Date.today(), user_admin, kf1)

# Teilnahmen Luke
Participation.create(coffee_box: kf1, user: user_luke, is_active: true)
ModelOfConsumption.create(coffee_box: kf1, user: user_luke, mo: 1, tue: 1, wed: 0, th: 0 , fr: 2, sa: 1, su: 0)
Consumption.create_month(Date.today(), user_luke, kf1)

# Teilnahmen Han
Participation.create(coffee_box: kf1, user: user_han, is_active: true)
ModelOfConsumption.create(coffee_box: kf1, user: user_han, mo: 2, tue: 1, wed: 1, th: 1 , fr: 2, sa: 0, su: 0)
Consumption.create_month(Date.today(), user_han, kf1)

# Teilnahmen Obi-Wan
Participation.create(coffee_box: kf1, user: user_obi, is_active: true)
ModelOfConsumption.create(coffee_box: kf1, user: user_obi, mo: 2, tue: 0, wed: 1, th: 1 , fr: 1, sa: 0, su: 0)
Consumption.create_month(Date.today(), user_obi, kf1)

# Expense eintragen
Expense.create(coffee_box: kf1, user: user_admin, flag_abgerechnet: false, item: "Kaffeepulver", value: "19.90", date: Date.today())
Expense.create(coffee_box: kf1, user: user_obi, flag_abgerechnet: false, item: "Filterpapier", value: "3.30", date: Date.today())
Expense.create(coffee_box: kf1, user: user_han, flag_abgerechnet: false, item: "Kaffeemilch", value: "7.29", date: Date.today())

# Ersten Monat abschließen
Bill.new.create_bill_for_month(Date.today(), user_admin, kf1)
Bill.new.create_bill_for_month(Date.today(), user_luke, kf1)
Bill.new.create_bill_for_month(Date.today(), user_han, kf1)
Bill.new.create_bill_for_month(Date.today(), user_obi, kf1)
# Neuen Preis erzeugen
PriceOfCoffee.new.create_price_for_next_month(Date.today(), kf1)




