# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  product_type :string(255)
#  price        :integer
#  description  :text
#  available    :boolean          default(TRUE)
#  size         :integer
#  year         :integer
#  country      :string(255)
#  sex          :string(255)
#  family       :string(255)
#  upnotes      :string(255)
#  heart        :string(255)
#  base         :string(255)
#  parent_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  brands       :string(255)
#  short_name   :string(255)
#

# -*- encoding : utf-8 -*-
require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
