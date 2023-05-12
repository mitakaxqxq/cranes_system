class Logging < ApplicationRecord
    belongs_to :user, optional: true, class_name: "User"
    belongs_to :company, optional: true, class_name: "Company"
end
