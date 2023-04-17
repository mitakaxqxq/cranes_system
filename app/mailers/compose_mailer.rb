class ComposeMailer < ApplicationMailer

  def compose_user(email:, message:)
    if Current.user[:email] != smtp_settings[:user_name]
      raise StandardError
    end
    mail from: smtp_settings[:user_name], to: email, subject:'Предстояща проверка' do |format|
      format.text { render plain: message }
    end
  end

  def compose_company(email:, subject:, message:)
    if Current.user[:email] != smtp_settings[:user_name]
      raise StandardError
    end
    mail from: smtp_settings[:user_name], to: email, subject: subject do |format|
      format.text { render plain: message }
    end
  end
end
