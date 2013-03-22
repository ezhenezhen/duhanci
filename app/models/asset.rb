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

class Asset < ActiveRecord::Base
  belongs_to :product
  has_attached_file :asset,
                    :styles => {:small => "62x62>", :medium => "97x97>", :thumb => "250x250>"},
                    :url  => "/attachments/:product_id/:basename_:style.:extension",
                    :path => ":rails_root/public/attachments/:product_id/:basename_:style.:extension"

  Paperclip.interpolates ('product_id') do |a, s|
    a.instance.product_id
  end

  attr_accessible :asset, :product_id, :name
end
