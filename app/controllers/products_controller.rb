# encoding: utf-8
require 'will_paginate/array'
require 'nokogiri'
require 'open-uri'

class ProductsController < ApplicationController
  before_filter :add_products_to_cookies, :only => "show"

  layout "product"
  # GET /products
  # GET /products.json
  def add_products_to_cookies
    if cookies[:product].blank?
      cookies[:product] = [params[:id]]
    else
      @recently = cookies[:product].split('&').last(8)
      unless @recently.include?(params[:id])
        cookies[:product] = [cookies[:product]] << params[:id]
      end
    end

  end

  def index
    @all_products = Product.find(:all, :conditions => {:parent_id => nil})
    @products = @all_products.paginate(:page => params[:page], :per_page => 40)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    if @product.parent_id == nil

      @brand = @product.brands
      @same = Product.find(:all, :conditions => {:brands => @brand, :parent_id => nil}).sample(4)
      @children = Product.find(:all, :conditions => {:parent_id => @product.id})
      
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @product }
      end
    else
      @product = Product.find(@product.parent_id)
      redirect_to @product
    end

  end

  # GET /products/new
  # GET /products/new.json
  def new

    @product = Product.new
    @product.assets.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def parse_all_brands
    urllist =
    [ "http://makeup.com.ua/categorys/3218/#param_2243[22469]=22469",
      "http://makeup.com.ua/categorys/3218/#param_2243[22477]=22477",
      "http://makeup.com.ua/categorys/3218/#param_2243[22529]=22529",
      "http://makeup.com.ua/categorys/3218/#param_2243[22621]=22621",
      "http://makeup.com.ua/categorys/3218/#param_2243[22669]=22669",
      "http://makeup.com.ua/categorys/3218/#param_2243[22693]=22693",
      "http://makeup.com.ua/categorys/3218/#param_2243[22747]=22747",
      "http://makeup.com.ua/categorys/3218/#param_2243[22801]=22801",
      "http://makeup.com.ua/categorys/3218/#param_2243[22829]=22829",
      "http://makeup.com.ua/categorys/3218/#param_2243[22893]=22893",
      "http://makeup.com.ua/categorys/3218/#param_2243[22933]=22933",
      "http://makeup.com.ua/categorys/3218/#param_2243[22455]=22455",
      "http://makeup.com.ua/categorys/3218/#param_2243[22961]=22961",
      "http://makeup.com.ua/categorys/3218/#param_2243[23087]=23087",
      "http://makeup.com.ua/categorys/3218/#param_2243[23141]=23141",
      "http://makeup.com.ua/categorys/3218/#param_2243[23169]=23169",
      "http://makeup.com.ua/categorys/3218/#param_2243[23211]=23211",
      "http://makeup.com.ua/categorys/3218/#param_2243[23237]=23237",
      "http://makeup.com.ua/categorys/3218/#param_2243[23253]=23253",
      "http://makeup.com.ua/categorys/3218/#param_2243[23269]=23269",
      "http://makeup.com.ua/categorys/3218/#param_2243[23289]=23289",
      "http://makeup.com.ua/categorys/3218/#param_2243[23301]=23301",
      "http://makeup.com.ua/categorys/3218/#param_2243[23385]=23385",
      "http://makeup.com.ua/categorys/3218/#param_2243[23411]=23411",
      "http://makeup.com.ua/categorys/3218/#param_2243[23469]=23469",
      "http://makeup.com.ua/categorys/3218/#param_2243[23545]=23545",
      "http://makeup.com.ua/categorys/3218/#param_2243[23577]=23577",
      "http://makeup.com.ua/categorys/3218/#param_2243[23647]=23647",
      "http://makeup.com.ua/categorys/3218/#param_2243[23671]=23671",
      "http://makeup.com.ua/categorys/3218/#param_2243[23765]=23765",
      "http://makeup.com.ua/categorys/3218/#param_2243[23791]=23791",
      "http://makeup.com.ua/categorys/3218/#param_2243[23865]=23865",
      "http://makeup.com.ua/categorys/3218/#param_2243[23919]=23919",
      "http://makeup.com.ua/categorys/3218/#param_2243[23957]=23957",
      "http://makeup.com.ua/categorys/3218/#param_2243[24055]=24055",
      "http://makeup.com.ua/categorys/3218/#param_2243[24089]=24089",
      "http://makeup.com.ua/categorys/3218/#param_2243[24141]=24141",
      "http://makeup.com.ua/categorys/3218/#param_2243[24179]=24179",
      "http://makeup.com.ua/categorys/3218/#param_2243[24201]=24201",
      "http://makeup.com.ua/categorys/3218/#param_2243[24201]=24201&offset=36",
      "http://makeup.com.ua/categorys/3218/#param_2243[24373]=24373",
      "http://makeup.com.ua/categorys/3218/#param_2243[24423]=24423",
      "http://makeup.com.ua/categorys/3218/#param_2243[24451]=24451",
      "http://makeup.com.ua/categorys/3218/#param_2243[24455]=24455",
      "http://makeup.com.ua/categorys/3218/#param_2243[24477]=24477",
      "http://makeup.com.ua/categorys/3218/#param_2243[24489]=24489",
      "http://makeup.com.ua/categorys/3218/#param_2243[24497]=24497",
      "http://makeup.com.ua/categorys/3218/#param_2243[24553]=24553",
      "http://makeup.com.ua/categorys/3218/#param_2243[24789]=24789",
      "http://makeup.com.ua/categorys/3218/#param_2243[31907]=31907",
      "http://makeup.com.ua/categorys/3218/#param_2243[24589]=24589",
      "http://makeup.com.ua/categorys/3218/#param_2243[24663]=24663",
      "http://makeup.com.ua/categorys/3218/#param_2243[42923]=42923",
      "http://makeup.com.ua/categorys/3218/#param_2243[30649]=30649",
      "http://makeup.com.ua/categorys/3218/#param_2243[24735]=24735",
      "http://makeup.com.ua/categorys/3218/#param_2243[24815]=24815",
      "http://makeup.com.ua/categorys/3218/#param_2243[24951]=24951",
      "http://makeup.com.ua/categorys/3218/#param_2243[25045]=25045",
      "http://makeup.com.ua/categorys/3218/#param_2243[25057]=25057",
      "http://makeup.com.ua/categorys/3218/#param_2243[25073]=25073",
      "http://makeup.com.ua/categorys/3218/#param_2243[25153]=25153",
      "http://makeup.com.ua/categorys/3218/#param_2243[25165]=25165",
      "http://makeup.com.ua/categorys/3218/#param_2243[25209]=25209",
      "http://makeup.com.ua/categorys/3218/#param_2243[25229]=25229",
      "http://makeup.com.ua/categorys/3218/#param_2243[25253]=25253",
      "http://makeup.com.ua/categorys/3218/#param_2243[25381]=25381",
      "http://makeup.com.ua/categorys/3218/#param_2243[25409]=25409",
      "http://makeup.com.ua/categorys/3218/#param_2243[25453]=25453",
      "http://makeup.com.ua/categorys/3218/#param_2243[24119]=24119",
      "http://makeup.com.ua/categorys/3218/#param_2243[25215]=25215",
      "http://makeup.com.ua/categorys/3218/#param_2243[25691]=25691",
      "http://makeup.com.ua/categorys/3218/#param_2243[25709]=25709",
      "http://makeup.com.ua/categorys/3218/#param_2243[25801]=25801",
      "http://makeup.com.ua/categorys/3218/#param_2243[25801]=25801&offset=36",
      "http://makeup.com.ua/categorys/3218/#param_2243[32235]=32235",
      "http://makeup.com.ua/categorys/3218/#param_2243[32235]=32235",
      "http://makeup.com.ua/categorys/3218/#param_2243[25967]=25967",
      "http://makeup.com.ua/categorys/3218/#param_2243[25987]=25987",
      "http://makeup.com.ua/categorys/3218/#param_2243[26015]=26015",
      "http://makeup.com.ua/categorys/3218/#param_2243[26367]=26367",
      "http://makeup.com.ua/categorys/3218/#param_2243[26097]=26097",
      "http://makeup.com.ua/categorys/3218/#param_2243[26155]=26155",
      "http://makeup.com.ua/categorys/3218/#param_2243[26165]=26165",
      "http://makeup.com.ua/categorys/3218/#param_2243[26203]=26203",
      "http://makeup.com.ua/categorys/3218/#param_2243[26233]=26233",
      "http://makeup.com.ua/categorys/3218/#param_2243[26259]=26259",
      "http://makeup.com.ua/categorys/3218/#param_2243[26309]=26309",
      "http://makeup.com.ua/categorys/3218/#param_2243[26331]=26331",
      "http://makeup.com.ua/categorys/3218/#param_2243[26335]=26335",
      "http://makeup.com.ua/categorys/3218/#param_2243[26349]=26349",
      "http://makeup.com.ua/categorys/3218/#param_2243[24729]=24729",
      "http://makeup.com.ua/categorys/3218/#param_2243[26489]=26489",
      "http://makeup.com.ua/categorys/3218/#param_2243[26515]=26515",
      "http://makeup.com.ua/categorys/3218/#param_2243[26539]=26539",
      "http://makeup.com.ua/categorys/3218/#param_2243[26581]=26581",
      "http://makeup.com.ua/categorys/3218/#param_2243[26663]=26663",
      "http://makeup.com.ua/categorys/3218/#param_2243[26209]=26209",
      "http://makeup.com.ua/categorys/3218/#param_2243[26873]=26873",
      "http://makeup.com.ua/categorys/3218/#param_2243[26987]=26987",
      "http://makeup.com.ua/categorys/3218/#param_2243[27031]=27031",
      "http://makeup.com.ua/categorys/3218/#param_2243[44547]=44547",
      "http://makeup.com.ua/categorys/3218/#param_2243[27101]=27101",
      "http://makeup.com.ua/categorys/3218/#param_2243[27139]=27139",
      "http://makeup.com.ua/categorys/3218/#param_2243[27223]=27223",
      "http://makeup.com.ua/categorys/3218/#param_2243[27237]=27237",
      "http://makeup.com.ua/categorys/3218/#param_2243[27301]=27301",
      "http://makeup.com.ua/categorys/3218/#param_2243[27387]=27387",
      "http://makeup.com.ua/categorys/3218/#param_2243[27417]=27417",
      "http://makeup.com.ua/categorys/3218/#param_2243[27417]=27417&offset=36",
      "http://makeup.com.ua/categorys/3218/#param_2243[27417]=27417&offset=72",
      "http://makeup.com.ua/categorys/3218/#param_2243[27007]=27007",
      "http://makeup.com.ua/categorys/3218/#param_2243[25397]=25397",
      "http://makeup.com.ua/categorys/3218/#param_2243[27591]=27591",
      "http://makeup.com.ua/categorys/3218/#param_2243[27597]=27597",
      "http://makeup.com.ua/categorys/3218/#param_2243[27809]=27809",
      "http://makeup.com.ua/categorys/3218/#param_2243[42775]=42775",
      "http://makeup.com.ua/categorys/3218/#param_2243[42801]=42801",
      "http://makeup.com.ua/categorys/3218/#param_2243[27715]=27715",
      "http://makeup.com.ua/categorys/3218/#param_2243[43047]=43047",
      "http://makeup.com.ua/categorys/3218/#param_2243[27777]=27777",
      "http://makeup.com.ua/categorys/3218/#param_2243[27967]=27967",
      "http://makeup.com.ua/categorys/3218/#param_2243[27793]=27793",
      "http://makeup.com.ua/categorys/3218/#param_2243[27797]=27797",
      "http://makeup.com.ua/categorys/3218/#param_2243[27821]=27821",
      "http://makeup.com.ua/categorys/3218/#param_2243[44571]=44571",
      "http://makeup.com.ua/categorys/3218/#param_2243[27871]=27871",
      "http://makeup.com.ua/categorys/3218/#param_2243[27893]=27893",
      "http://makeup.com.ua/categorys/3218/#param_2243[27941]=27941",
      "http://makeup.com.ua/categorys/3218/#param_2243[27955]=27955",
      "http://makeup.com.ua/categorys/3218/#param_2243[28051]=28051",
      "http://makeup.com.ua/categorys/3218/#param_2243[28067]=28067",
      "http://makeup.com.ua/categorys/3218/#param_2243[28131]=28131",
      "http://makeup.com.ua/categorys/3218/#param_2243[28219]=28219",
      "http://makeup.com.ua/categorys/3218/#param_2243[28229]=28229",
      "http://makeup.com.ua/categorys/3218/#param_2243[28281]=28281",
      "http://makeup.com.ua/categorys/3218/#param_2243[24147]=24147",
      "http://makeup.com.ua/categorys/3218/#param_2243[28303]=28303",
      "http://makeup.com.ua/categorys/3218/#param_2243[28327]=28327",
      "http://makeup.com.ua/categorys/3218/#param_2243[28373]=28373",
      "http://makeup.com.ua/categorys/3218/#param_2243[28387]=28387",
      "http://makeup.com.ua/categorys/3218/#param_2243[28481]=28481",
      "http://makeup.com.ua/categorys/3218/#param_2243[28629]=28629",
      "http://makeup.com.ua/categorys/3218/#param_2243[28497]=28497",
      "http://makeup.com.ua/categorys/3218/#param_2243[28509]=28509",
      "http://makeup.com.ua/categorys/3218/#param_2243[28521]=28521",
      "http://makeup.com.ua/categorys/3218/#param_2243[28547]=28547",
      "http://makeup.com.ua/categorys/3218/#param_2243[30673]=30673",
      "http://makeup.com.ua/categorys/3218/#param_2243[28847]=28847",
      "http://makeup.com.ua/categorys/3218/#param_2243[28669]=28669",
      "http://makeup.com.ua/categorys/3218/#param_2243[28779]=28779",
      "http://makeup.com.ua/categorys/3218/#param_2243[23877]=23877",
      "http://makeup.com.ua/categorys/3/#param_2243[22469]=22469",
      "http://makeup.com.ua/categorys/3/#param_2243[22477]=22477",
      "http://makeup.com.ua/categorys/3/#param_2243[22529]=22529",
      "http://makeup.com.ua/categorys/3/#param_2243[22603]=22603",
      "http://makeup.com.ua/categorys/3/#param_2243[22621]=22621",
      "http://makeup.com.ua/categorys/3/#param_2243[22653]=22653",
      "http://makeup.com.ua/categorys/3/#param_2243[22661]=22661",
      "http://makeup.com.ua/categorys/3/#param_2243[22693]=22693",
      "http://makeup.com.ua/categorys/3/#param_2243[22747]=22747",
      "http://makeup.com.ua/categorys/3/#param_2243[22773]=22773",
      "http://makeup.com.ua/categorys/3/#param_2243[22801]=22801",
      "http://makeup.com.ua/categorys/3/#param_2243[22829]=22829",
      "http://makeup.com.ua/categorys/3/#param_2243[22893]=22893",
      "http://makeup.com.ua/categorys/3/#param_2243[22455]=22455",
      "http://makeup.com.ua/categorys/3/#param_2243[22961]=22961",
      "http://makeup.com.ua/categorys/3/#param_2243[23087]=23087",
      "http://makeup.com.ua/categorys/3/#param_2243[23133]=23133",
      "http://makeup.com.ua/categorys/3/#param_2243[23141]=23141",
      "http://makeup.com.ua/categorys/3/#param_2243[43129]=43129",
      "http://makeup.com.ua/categorys/3/#param_2243[23155]=23155",
      "http://makeup.com.ua/categorys/3/#param_2243[23169]=23169",
      "http://makeup.com.ua/categorys/3/#param_2243[23211]=23211",
      "http://makeup.com.ua/categorys/3/#param_2243[23237]=23237",
      "http://makeup.com.ua/categorys/3/#param_2243[23249]=23249",
      "http://makeup.com.ua/categorys/3/#param_2243[23257]=23257",
      "http://makeup.com.ua/categorys/3/#param_2243[23289]=23289",
      "http://makeup.com.ua/categorys/3/#param_2243[23301]=23301",
      "http://makeup.com.ua/categorys/3/#param_2243[23327]=23327",
      "http://makeup.com.ua/categorys/3/#param_2243[23363]=23363",
      "http://makeup.com.ua/categorys/3/#param_2243[23385]=23385",
      "http://makeup.com.ua/categorys/3/#param_2243[23395]=23395",
      "http://makeup.com.ua/categorys/3/#param_2243[23411]=23411",
      "http://makeup.com.ua/categorys/3/#param_2243[23469]=23469",
      "http://makeup.com.ua/categorys/3/#param_2243[23545]=23545",
      "http://makeup.com.ua/categorys/3/#param_2243[23577]=23577",
      "http://makeup.com.ua/categorys/3/#param_2243[23647]=23647",
      "http://makeup.com.ua/categorys/3/#param_2243[23671]=23671",
      "http://makeup.com.ua/categorys/3/#param_2243[23777]=23777",
      "http://makeup.com.ua/categorys/3/#param_2243[23791]=23791",
      "http://makeup.com.ua/categorys/3/#param_2243[23865]=23865",
      "http://makeup.com.ua/categorys/3/#param_2243[23919]=23919",
      "http://makeup.com.ua/categorys/3/#param_2243[23957]=23957",
      "http://makeup.com.ua/categorys/3/#param_2243[24045]=24045",
      "http://makeup.com.ua/categorys/3/#param_2243[24055]=24055",
      "http://makeup.com.ua/categorys/3/#param_2243[24089]=24089",
      "http://makeup.com.ua/categorys/3/#param_2243[24111]=24111",
      "http://makeup.com.ua/categorys/3/#param_2243[24141]=24141",
      "http://makeup.com.ua/categorys/3/#param_2243[24179]=24179",
      "http://makeup.com.ua/categorys/3/#param_2243[24201]=24201",
      "http://makeup.com.ua/categorys/3/#param_2243[24397]=24397",
      "http://makeup.com.ua/categorys/3/#param_2243[24423]=24423",
      "http://makeup.com.ua/categorys/3/#param_2243[24447]=24447",
      "http://makeup.com.ua/categorys/3/#param_2243[24455]=24455",
      "http://makeup.com.ua/categorys/3/#param_2243[43237]=43237",
      "http://makeup.com.ua/categorys/3/#param_2243[24477]=24477",
      "http://makeup.com.ua/categorys/3/#param_2243[24497]=24497",
      "http://makeup.com.ua/categorys/3/#param_2243[24553]=24553",
      "http://makeup.com.ua/categorys/3/#param_2243[24789]=24789",
      "http://makeup.com.ua/categorys/3/#param_2243[24581]=24581",
      "http://makeup.com.ua/categorys/3/#param_2243[24589]=24589",
      "http://makeup.com.ua/categorys/3/#param_2243[24663]=24663",
      "http://makeup.com.ua/categorys/3/#param_2243[42923]=42923",
      "http://makeup.com.ua/categorys/3/#param_2243[30649]=30649",
      "http://makeup.com.ua/categorys/3/#param_2243[24735]=24735",
      "http://makeup.com.ua/categorys/3/#param_2243[24815]=24815",
      "http://makeup.com.ua/categorys/3/#param_2243[24925]=24925",
      "http://makeup.com.ua/categorys/3/#param_2243[24865]=24865",
      "http://makeup.com.ua/categorys/3/#param_2243[24875]=24875",
      "http://makeup.com.ua/categorys/3/#param_2243[24937]=24937",
      "http://makeup.com.ua/categorys/3/#param_2243[24943]=24943",
      "http://makeup.com.ua/categorys/3/#param_2243[24969]=24969",
      "http://makeup.com.ua/categorys/3/#param_2243[25045]=25045",
      "http://makeup.com.ua/categorys/3/#param_2243[25057]=25057",
      "http://makeup.com.ua/categorys/3/#param_2243[25073]=25073",
      "http://makeup.com.ua/categorys/3/#param_2243[25153]=25153",
      "http://makeup.com.ua/categorys/3/#param_2243[25165]=25165",
      "http://makeup.com.ua/categorys/3/#param_2243[25197]=25197",
      "http://makeup.com.ua/categorys/3/#param_2243[25209]=25209",
      "http://makeup.com.ua/categorys/3/#param_2243[25229]=25229",
      "http://makeup.com.ua/categorys/3/#param_2243[25253]=25253",
      "http://makeup.com.ua/categorys/3/#param_2243[25345]=25345",
      "http://makeup.com.ua/categorys/3/#param_2243[25381]=25381",
      "http://makeup.com.ua/categorys/3/#param_2243[25409]=25409",
      "http://makeup.com.ua/categorys/3/#param_2243[25453]=25453",
      "http://makeup.com.ua/categorys/3/#param_2243[25453]=25453&offset=36",
      "http://makeup.com.ua/categorys/3/#param_2243[24119]=24119",
      "http://makeup.com.ua/categorys/3/#param_2243[24119]=24119&offset=36",
      "http://makeup.com.ua/categorys/3/#param_2243[25215]=25215",
      "http://makeup.com.ua/categorys/3/#param_2243[25215]=25215&offset=36",
      "http://makeup.com.ua/categorys/3/#param_2243[25691]=25691",
      "http://makeup.com.ua/categorys/3/#param_2243[25709]=25709",
      "http://makeup.com.ua/categorys/3/#param_2243[26047]=26047",
      "http://makeup.com.ua/categorys/3/#param_2243[25801]=25801",
      "http://makeup.com.ua/categorys/3/#param_2243[32235]=32235",
      "http://makeup.com.ua/categorys/3/#param_2243[25967]=25967",
      "http://makeup.com.ua/categorys/3/#param_2243[25987]=25987",
      "http://makeup.com.ua/categorys/3/#param_2243[26007]=26007",
      "http://makeup.com.ua/categorys/3/#param_2243[26015]=26015",
      "http://makeup.com.ua/categorys/3/#param_2243[26081]=26081",
      "http://makeup.com.ua/categorys/3/#param_2243[26097]=26097",
      "http://makeup.com.ua/categorys/3/#param_2243[26143]=26143",
      "http://makeup.com.ua/categorys/3/#param_2243[26155]=26155",
      "http://makeup.com.ua/categorys/3/#param_2243[26181]=26181",
      "http://makeup.com.ua/categorys/3/#param_2243[26199]=26199",
      "http://makeup.com.ua/categorys/3/#param_2243[26203]=26203",
      "http://makeup.com.ua/categorys/3/#param_2243[26233]=26233",
      "http://makeup.com.ua/categorys/3/#param_2243[26263]=26263",
      "http://makeup.com.ua/categorys/3/#param_2243[26309]=26309",
      "http://makeup.com.ua/categorys/3/#param_2243[26317]=26317",
      "http://makeup.com.ua/categorys/3/#param_2243[26325]=26325",
      "http://makeup.com.ua/categorys/3/#param_2243[26335]=26335",
      "http://makeup.com.ua/categorys/3/#param_2243[24729]=24729",
      "http://makeup.com.ua/categorys/3/#param_2243[26489]=26489",
      "http://makeup.com.ua/categorys/3/#param_2243[26891]=26891",
      "http://makeup.com.ua/categorys/3/#param_2243[26515]=26515",
      "http://makeup.com.ua/categorys/3/#param_2243[26539]=26539",
      "http://makeup.com.ua/categorys/3/#param_2243[26571]=26571",
      "http://makeup.com.ua/categorys/3/#param_2243[26581]=26581",
      "http://makeup.com.ua/categorys/3/#param_2243[44645]=44645",
      "http://makeup.com.ua/categorys/3/#param_2243[26663]=26663",
      "http://makeup.com.ua/categorys/3/#param_2243[26209]=26209",
      "http://makeup.com.ua/categorys/3/#param_2243[26873]=26873",
      "http://makeup.com.ua/categorys/3/#param_2243[26987]=26987",
      "http://makeup.com.ua/categorys/3/#param_2243[27031]=27031",
      "http://makeup.com.ua/categorys/3/#param_2243[27039]=27039",
      "http://makeup.com.ua/categorys/3/#param_2243[27059]=27059",
      "http://makeup.com.ua/categorys/3/#param_2243[27065]=27065",
      "http://makeup.com.ua/categorys/3/#param_2243[42647]=42647",
      "http://makeup.com.ua/categorys/3/#param_2243[44547]=44547",
      "http://makeup.com.ua/categorys/3/#param_2243[27101]=27101",
      "http://makeup.com.ua/categorys/3/#param_2243[27139]=27139",
      "http://makeup.com.ua/categorys/3/#param_2243[27175]=27175",
      "http://makeup.com.ua/categorys/3/#param_2243[27223]=27223",
      "http://makeup.com.ua/categorys/3/#param_2243[27237]=27237",
      "http://makeup.com.ua/categorys/3/#param_2243[27569]=27569",
      "http://makeup.com.ua/categorys/3/#param_2243[27281]=27281",
      "http://makeup.com.ua/categorys/3/#param_2243[27301]=27301",
      "http://makeup.com.ua/categorys/3/#param_2243[27357]=27357",
      "http://makeup.com.ua/categorys/3/#param_2243[27377]=27377",
      "http://makeup.com.ua/categorys/3/#param_2243[27387]=27387",
      "http://makeup.com.ua/categorys/3/#param_2243[27417]=27417",
      "http://makeup.com.ua/categorys/3/#param_2243[27451]=27451",
      "http://makeup.com.ua/categorys/3/#param_2243[27007]=27007",
      "http://makeup.com.ua/categorys/3/#param_2243[27545]=27545",
      "http://makeup.com.ua/categorys/3/#param_2243[25397]=25397",
      "http://makeup.com.ua/categorys/3/#param_2243[27591]=27591",
      "http://makeup.com.ua/categorys/3/#param_2243[27607]=27607",
      "http://makeup.com.ua/categorys/3/#param_2243[42775]=42775",
      "http://makeup.com.ua/categorys/3/#param_2243[42801]=42801",
      "http://makeup.com.ua/categorys/3/#param_2243[27899]=27899",
      "http://makeup.com.ua/categorys/3/#param_2243[41923]=41923",
      "http://makeup.com.ua/categorys/3/#param_2243[27715]=27715",
      "http://makeup.com.ua/categorys/3/#param_2243[27769]=27769",
      "http://makeup.com.ua/categorys/3/#param_2243[27777]=27777",
      "http://makeup.com.ua/categorys/3/#param_2243[27967]=27967",
      "http://makeup.com.ua/categorys/3/#param_2243[27785]=27785",
      "http://makeup.com.ua/categorys/3/#param_2243[27789]=27789",
      "http://makeup.com.ua/categorys/3/#param_2243[27793]=27793",
      "http://makeup.com.ua/categorys/3/#param_2243[27797]=27797",
      "http://makeup.com.ua/categorys/3/#param_2243[28011]=28011",
      "http://makeup.com.ua/categorys/3/#param_2243[27821]=27821",
      "http://makeup.com.ua/categorys/3/#param_2243[44571]=44571",
      "http://makeup.com.ua/categorys/3/#param_2243[27871]=27871",
      "http://makeup.com.ua/categorys/3/#param_2243[27893]=27893",
      "http://makeup.com.ua/categorys/3/#param_2243[27933]=27933",
      "http://makeup.com.ua/categorys/3/#param_2243[28155]=28155",
      "http://makeup.com.ua/categorys/3/#param_2243[27955]=27955",
      "http://makeup.com.ua/categorys/3/#param_2243[27993]=27993",
      "http://makeup.com.ua/categorys/3/#param_2243[28051]=28051",
      "http://makeup.com.ua/categorys/3/#param_2243[28067]=28067",
      "http://makeup.com.ua/categorys/3/#param_2243[28131]=28131",
      "http://makeup.com.ua/categorys/3/#param_2243[28205]=28205",
      "http://makeup.com.ua/categorys/3/#param_2243[28219]=28219",
      "http://makeup.com.ua/categorys/3/#param_2243[28229]=28229",
      "http://makeup.com.ua/categorys/3/#param_2243[28281]=28281",
      "http://makeup.com.ua/categorys/3/#param_2243[24147]=24147",
      "http://makeup.com.ua/categorys/3/#param_2243[28303]=28303",
      "http://makeup.com.ua/categorys/3/#param_2243[38981]=38981",
      "http://makeup.com.ua/categorys/3/#param_2243[28351]=28351",
      "http://makeup.com.ua/categorys/3/#param_2243[28517]=28517",
      "http://makeup.com.ua/categorys/3/#param_2243[45871]=45871",
      "http://makeup.com.ua/categorys/3/#param_2243[28373]=28373",
      "http://makeup.com.ua/categorys/3/#param_2243[28387]=28387",
      "http://makeup.com.ua/categorys/3/#param_2243[28481]=28481",
      "http://makeup.com.ua/categorys/3/#param_2243[28629]=28629",
      "http://makeup.com.ua/categorys/3/#param_2243[28497]=28497",
      "http://makeup.com.ua/categorys/3/#param_2243[28521]=28521",
      "http://makeup.com.ua/categorys/3/#param_2243[28547]=28547",
      "http://makeup.com.ua/categorys/3/#param_2243[26043]=26043",
      "http://makeup.com.ua/categorys/3/#param_2243[30673]=30673",
      "http://makeup.com.ua/categorys/3/#param_2243[28645]=28645",
      "http://makeup.com.ua/categorys/3/#param_2243[28669]=28669",
      "http://makeup.com.ua/categorys/3/#param_2243[28669]=28669&offset=36",
      "http://makeup.com.ua/categorys/3/#param_2243[28779]=28779",
      "http://makeup.com.ua/categorys/3/#param_2243[30681]=30681",
      "http://makeup.com.ua/categorys/3/#param_2243[28811]=28811",
      "http://makeup.com.ua/categorys/3/#param_2243[28909]=28909",
      "http://makeup.com.ua/categorys/3/#param_2243[23877]=23877", ]

    i=urllist.length-1

    while i > 0
      url = urllist[i]
      browser = Watir::Browser.new
      browser.goto(url)

      data = Nokogiri::HTML.parse(browser.html)

      products = data.at_css('.products')
      duhanci = products.css('.li')
      duhanci.each do |duh|
        duh.css('h3').each do |h3|
          Nameslinksofproduct.create(:name => h3.text, :link => 'http://makeup.com.ua' + h3.css('a')[0]["href"] )
        end
      end
      browser.window.close
      i-=1
    end
  end

  def parse_products_information

    links = Nameslinksofproduct.all

    i=0
    while i < links.size

      link = links[i].link
      data = Nokogiri::HTML(open(link))
      name = data.at_css('h1').text.split(' - ')[0]
      type = data.at_css('h1').text.split(' - ')[1]
      full_description = data.at_css('.full .text').text
      description = full_description.split("\n")[2].strip.split('Дата')[0]
      brands = data.css('.path :nth-child(5) a').text
      short_name = data.css('.path :nth-child(7) a').text

      begin
        unless data.css('b')[1].nil?
          year = data.at_css('b').next.text.strip
          country = data.css('b')[1].next.text.strip
          sex =  data.css('b')[2].next.text.strip
          family = data.css('b')[3].next.text.strip
          upnotes = data.css('b')[4].next.text.strip
          unless data.css('b')[5].nil?
            heart = data.css('b')[5].next.text.strip
          end
          unless data.css('b')[6].nil?
            base = data.css('b')[6].next.text.strip
          end
        else
          year = data.at_css('.text strong').next.text.strip
          country = data.css('.text strong')[1].next.text.strip
          sex =  data.css('.text strong')[2].next.text.strip
          family = data.css('.text strong')[3].next.text.strip
          upnotes = data.css('.text strong')[4].next.text.strip
          unless data.css('.text strong')[5].nil?
            heart = data.css('.text strong')[5].next.text.strip
            unless data.css('.text strong')[6].nil?
              base = data.css('.text strong')[6].next.text.strip
            end
          end
        end
      rescue
      end

      if (data.css('.availability').text.strip === "Есть в наличии")
      available = true
      else
      available = false
      end

      javascript = data.at('.opselect-list-content')

      unless javascript.nil?
        j=0
        parent = nil
        while j < javascript.css('.opselect-li').size
          unless javascript.css('.opselect-li')[j].nil?
            size = javascript.css('.opselect-li')[j].text.strip
            price = javascript.css('.opselect-li')[j][@id = "onmouseover"].split('(')[1].split(', ')[2].delete('^0-9')

            if parent.nil?
              product = Product.create(:name => name, :product_type => type, :price => price, :description => description, :available => available, :size => size, :year => year, :country => country, :sex => sex, :family => family, :upnotes => upnotes, :heart => heart, :base => base, :short_name => short_name, :brands => brands)
            parent = product.id
            else
              product = Product.create(:name => name, :product_type => type, :price => price, :description => description, :available => available, :size => size, :year => year, :country => country, :sex => sex, :family => family, :upnotes => upnotes, :heart => heart, :base => base, :parent_id => parent, :short_name => short_name, :brands => brands)
            end

            k=0
            images = data.at('.jflow-list')
            unless images.nil?
              while k < images.css('.jflow-li').size
                image = images.css('.jflow-li')[k].children[1].attribute('href').value

                product.picture_from_url('http://makeup.com.ua' + image)
                k+=1
              end
            else
              image = data.at('.img').children[1].attribute('href').value
              product.picture_from_url('http://makeup.com.ua' + image)
            end
          end
          j+=1
        end
      end
      i+=1
    end

  end
end

