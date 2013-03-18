# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: nameslinksofproducts
#
#  id   :integer          not null, primary key
#  name :string(255)
#  link :string(255)
#

class Nameslinksofproduct < ActiveRecord::Base
  attr_accessible :name, :link
  validates :name, :uniqueness => true
end
