class UpdateCompaniesChangeNameNullability < ActiveRecord::Migration[7.0]
  def change
    change_column_null :companies, :name, false
    change_column_null :companies, :uic, false
    change_column_null :companies, :address, false
  end
end
