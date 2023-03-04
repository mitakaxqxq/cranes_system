class RemoveUserIdFromCrane < ActiveRecord::Migration[7.0]
  def change
    remove_column :cranes, :user_id, :integer, null: false
  end
end
