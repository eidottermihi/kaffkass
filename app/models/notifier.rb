# encoding: utf-8
class Notifier < ActionMailer::Base

  def activation_instructions(user)
    @user = user
    mail = @user.email
    mail(to: mail, from: 'no-reply@kaffkass.com',
         subject: "KaffKass Accountaktivierung")
  end

  def welcome(user)
    @user = user
    mail = @user.email
    mail(to: mail, from: 'no-reply@kaffkass.com',
         subject: "Willkommen bei KaffKass!")
  end

  def bill(bill, user)
    @user = user
    mail = @user.email
    @bill = bill
    mail(to: mail, from: 'no-reply@kaffkass.com',
         subject: "KaffKass - Rechnung für #{bill.date}")
  end

end
