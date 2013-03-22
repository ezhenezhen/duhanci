class AddAliasToProducts < ActiveRecord::Migration
  def change
    add_column :products, :short_name, :string
  end
end
