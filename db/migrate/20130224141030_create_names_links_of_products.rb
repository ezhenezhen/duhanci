# -*- encoding : utf-8 -*-
class CreateNamesLinksOfProducts < ActiveRecord::Migration
  def change
    create_table :nameslinksofproducts do |t|
      t.string :name
      t.string :link
    end
  end
end
