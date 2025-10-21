class CreateMaterials < ActiveRecord::Migration[7.2]
  def change
    create_table :materials do |t|
      t.string :title
      t.text :description
      t.integer :status
      t.string :isbn
      t.integer :pages
      t.string :doi
      t.integer :duration
      t.references :author, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
