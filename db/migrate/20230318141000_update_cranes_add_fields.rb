class UpdateCranesAddFields < ActiveRecord::Migration[7.0]
  def change
    add_column :cranes, :load_capacity, :float
    add_column :cranes, :year_of_manufacture, :integer
    add_column :cranes, :application_number, :integer
    add_column :cranes, :application_date, :date
    add_column :cranes, :last_check_date, :date
    add_column :cranes, :next_check_date, :date
    add_column :cranes, :suspension_date, :date
    add_column :cranes, :scrap_date, :date
    add_column :cranes, :crane_type, :string
    add_column :cranes, :user, :string
    add_column :cranes, :user_address, :string
    add_column :cranes, :manufacturer, :string
    add_column :cranes, :location, :string
    add_column :cranes, :registration_number, :string
    add_column :cranes, :notes, :text
  end
end
