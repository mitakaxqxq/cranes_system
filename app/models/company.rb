class Company < ApplicationRecord
    has_secure_password
    serialize :contractors, Array
    
    validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: 'Имейлът е неправилен, въведете отново!' }
    after_initialize do |company|
        company.contractors ||= []
    end
end
