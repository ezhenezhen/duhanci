# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: assets
#
#  id                 :integer          not null, primary key
#  asset_file_name    :string(255)
#  asset_file_size    :integer
#  asset_content_type :string(255)
#  asset_updated_at   :datetime
#  product_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
