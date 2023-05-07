class ComposesController < ApplicationController
    def new_user_email
        cranes_for_check
        message_from_user
        log_user_action(Current.user, "compose email opened", "User #{Current.user[:name]} opened page for composing email")
    end

    def create_user_email
        message_from_user
        begin
            ComposeMailer.compose_user(email: params[:email], message: @message).deliver_now
            log_user_action(Current.user, "email successfully sent", "User #{Current.user[:name]} successfully sent an email")
            redirect_to root_path, :flash => { :notice => 'Имейлът е изпратен успешно.' }
        rescue => e
            puts e
            log_user_action(Current.user, "email failed to send", "User #{Current.user[:name]} could not sent an email due to an error")
            redirect_to root_path, :flash => { :alert => 'SMTP конфигурациите са грешни! Моля, актуализирайте ги и опитайте отново' }
        end
    end

    def new_company_email
        log_company_action(Current.user, "compose email opened", "Company #{Current.user[:name]} opened page for composing email")
    end

    def create_company_email
        begin
            ComposeMailer.compose_company(
                email: params[:email],
                subject: params[:subject],
                message: params[:message]
            ).deliver_now
            log_company_action(Current.user, "email successfully sent", "Company #{Current.user[:name]} successfully sent an email")
            redirect_to root_path, :flash => { :notice => 'Имейлът е изпратен успешно.' }
        rescue => e
            puts e
            log_company_action(Current.user, "email failed to send", "Company #{Current.user[:name]} could not sent an email due to an error")
            redirect_to root_path, :flash => { :alert => 'SMTP конфигурациите са грешни! Моля, актуализирайте ги и опитайте отново' }
        end
    end

    private

    def cranes_for_check
        current_date = Date.today
        @cranes_for_check = Crane.where(
            "contractor_number = :number 
            AND date(:date) >= date(next_check_date, '-56 days') 
            AND date(:date) <= date(next_check_date)", 
            number: Current.user[:company_number], date: current_date.to_s)
        @cranes_for_check.sort_by { |crane| crane.next_check_date.month }
    end

    def message_from_user
        cranes_for_check
        cranes_grouped_by_month = @cranes_for_check.group_by { |crane| crane.next_check_date.month }
        @message = "Здравейте,\nОт фирма #{Current.user[:name]} Ви напомняме, че ще бъдат извършени периодичните технически прегледи на повдигателни съоръжения както следва:\n"
        cranes_grouped_by_month.each do |month, cranes|
          month_name =  I18n.t("months")[month-1]
          @message << "За месец #{month_name}:\n"
          cranes.each do |crane|
            @message << "•#{crane.registration_number} с дата на следваща проверка #{crane.next_check_date}\n"
          end
        end
    end
end