class CreateSmtpSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :smtp_settings do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.string :address
      t.integer :port
      t.string :user_name
      t.string :password
      t.string :authentication
      t.boolean :enable_starttls_auto
      t.string :openssl_verify_mode
      t.timestamps
    end
  end
end
