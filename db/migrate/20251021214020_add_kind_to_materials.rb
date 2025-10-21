class AddKindToMaterials < ActiveRecord::Migration[7.2]
  def change
    add_column :materials, :kind, :integer
  end
end
