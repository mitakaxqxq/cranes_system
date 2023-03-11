class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :email, null: false
      t.string :name
      t.string :password_digest
      t.integer :uic
      t.string :address
      t.text :contractors
      t.timestamps
    end
  end
end
