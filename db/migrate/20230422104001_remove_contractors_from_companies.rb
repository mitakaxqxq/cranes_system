class RemoveContractorsFromCompanies < ActiveRecord::Migration[7.0]
  def change
    remove_column :companies, :contractors, :text
  end
end
