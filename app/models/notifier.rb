class Notifier < ActionMailer::Base

  def activation_instructions(user)
    @user = user
    mail(to: user.email, from: 'no-reply@kaffkass.com',
         subject: "Activation Instructions")
  end

  def welcome(user)
    @user = user
    mail(to: user.email, from: 'no-reply@kaffkass.com',
         subject: "Welcome to KaffKass")
  end

  def bill(bill,user)
    @user = user
    @bill = bill
    mail(to: user.email, from: 'no-reply@kaffkass.com',
         subject: "Bill for #{bill.date}")
  end



end
