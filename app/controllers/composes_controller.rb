class ComposesController < ApplicationController
    def new
    end

    def create
        begin
            ComposeMailer.compose(email: params[:email]).deliver_now
            redirect_to root_path, :flash => { :notice => 'Имейлът е изпратен успешно.' }
        rescue => e
            redirect_to root_path, :flash => { :alert => 'Имейлът за изпращане не е конфигуриран правилно! Моля, оправете настройките и презаредете сървъра.' }
        end
    end
end