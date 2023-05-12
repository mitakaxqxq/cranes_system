class CreateLoggings < ActiveRecord::Migration[7.0]
  def change
    create_table :loggings do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.string :action
      t.text :message
      t.string :url
      t.string :browser
      t.datetime :executed_at, null: false
    end
  end
end
