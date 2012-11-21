class Notifier < ActionMailer::Base

  def activation_instructions(user)
    @user = user
    @url  = "http://example.com/login"
    mail(to: user.email, from: 'no-reply@kaffkass.com',
         subject: "Activation Instructions",
         body:   activate_path(user.persistence_token))
  end

  def welcome(user)
    @user = user
    @url  = "http://example.com/login"
    mail(to: "itgkarl@googlemail.com", from: 'no-reply@kaffkass.com',
         return_path: 'system@example.com', subject: "Welcome to My Awesome Site")
  end

end