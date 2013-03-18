# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  type        :string(255)
#  price       :integer
#  description :text
#  available   :boolean          default(TRUE)
#  size        :integer
#  year        :integer
#  country     :string(255)
#  sex         :string(255)
#  family      :string(255)
#  upnotes     :string(255)
#  heart       :string(255)
#  base        :string(255)
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "open-uri"

class Product < ActiveRecord::Base
  attr_accessible :assets_attributes, :asset, :name, :product_type, :price, :description, :available, :size, :year, :country, :sex, :family, :upnotes, :heart, :base, :parent_id
  has_many :assets, :dependent => :destroy
  accepts_nested_attributes_for :assets, :allow_destroy => :true
  #validates_uniqueness_of :name, :scope => [:price, :size, :description ]

  def picture_from_url(url)
    self.assets.build( :asset => URI.parse(url), :product_id => self.id ).save
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end