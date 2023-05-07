class UpdateCranesAddContractorNumber < ActiveRecord::Migration[7.0]
  def change
    add_column :cranes, :contractor_number, :integer
  end
end