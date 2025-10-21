class CreateAuthors < ActiveRecord::Migration[7.2]
  def change
    create_table :authors do |t|
      t.string :name
      t.integer :kind
      t.date :birth_date
      t.string :city
      t.timestamps
    end
  end
end
