# email: string
# password_virtual: string
# But we work with:
# password_confirmation: string virtual
# password: string virtual

class User < ApplicationRecord
	has_secure_password

	validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: 'Имейлът е неправилен, въведете отново!' }
	validates :company_number, presence: true
end
