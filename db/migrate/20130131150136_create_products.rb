# -*- encoding : utf-8 -*-
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :type
      t.integer :price
      t.text :description
      t.boolean :available, :default => :true
      t.integer :size
      t.integer :year
      t.string :country
      t.string :sex
      t.string :family
      t.string :upnotes
      t.string :heart
      t.string :base
      t.integer :parent_id

      t.timestamps
    end
  end
end
