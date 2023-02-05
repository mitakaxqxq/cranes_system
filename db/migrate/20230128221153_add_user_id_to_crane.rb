class AddUserIdToCrane < ActiveRecord::Migration[7.0]
  def change
    add_column :cranes, :user_id, :integer, null: false
  end
end
