class Company < ApplicationRecord
    has_secure_password
    has_one :smtp_settings, dependent: :destroy, class_name: "SmtpSetting"
    has_many :company_contractors
    has_many :contractors, through: :company_contractors, source: :user
    
    validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: 'Имейлът е неправилен, въведете отново!' }
    validates :uic, presence: true, numericality: { only_integer: true, message: 'Трябва да въведете число!' }, length: { is: 9, message: 'Трябва да въведете точно 9 цифри!' }
end
