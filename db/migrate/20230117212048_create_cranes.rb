class CreateCranes < ActiveRecord::Migration[7.0]
  def change
    create_table :cranes do |t|
      t.string :status
      t.date :registration_date
      t.string :serial_number

      t.timestamps
    end
  end
end
