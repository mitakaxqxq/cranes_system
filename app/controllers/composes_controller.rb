class ComposesController < ApplicationController
	def new
	end

	def create
		ComposeMailer.compose(email: params[:email]).deliver_now
		redirect_to root_path, :flash => { :notice => 'Имейлът е изпратен успешно.' }
	end
end