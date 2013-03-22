# -*- encoding : utf-8 -*-
class FilesController < ApplicationController
  def new
    @product = Product.new
    asset = @product.assets.build
    render :partial => "files/form",
           :locals => {:number => params[:number].to_i,
                       :asset => asset}
  end

  def show
    asset = Asset.find(params[:id])
    send_file asset.asset.path, :filename => asset.asset_file_name,
            :content_type => asset.asset_content_type
  end
end
