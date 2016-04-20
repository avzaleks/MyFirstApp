class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user=user
    @greeting = "Hi #{@user.name}"
    mail to: @user.email
  end

  def admin_email(user)
  #  @admin=User.find_by_admin(:true)
    @user_name = user.name
    mail to: 'aleksandr.zaichko@gmail.com'
  end


end
