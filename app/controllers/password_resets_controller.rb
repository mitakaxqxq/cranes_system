class PasswordResetsController < ApplicationController
	def new
	end

	def create
		@user = User.find_by(email: params[:email])

		if @user.present?
			PasswordMailer.with(user: @user).reset.deliver_now
		end
		redirect_to root_path, :flash => { :notice => 'Изпратен е линк за зануляване на паролата до посочения имейл адрес.' }
	end

	def edit
		@user = User.find_signed!(params[:token], purpose: 'password_reset')
	rescue ActiveSupport::MessageVerifier::InvalidSignature
		redirect_to password_reset_path, :flash => { :alert => 'Имейл токенът е изтекъл! Моля, направете нова заявка.' }
	end

	def update
		@user = User.find_signed!(params[:token], purpose: 'password_reset')
		if @user.update(password_params)
			redirect_to sign_in_path, :flash => { :notice => 'Паролата Ви беше занулена успешно. Моля, влезте в системата.' }
		else
			render :edit
		end
	end

	private

	def password_params
   		params.require(:user).permit(:password, :password_confirmation)
   	end
end