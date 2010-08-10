class ProductsController < ApplicationController
	before_filter :require_user
	filter_access_to :all
	before_filter :get_product, :only => [:show, :edit, :update, :destroy]

	layout 'admin'

  def index
    @products = Product.all
  end
  
  def show
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = "Successfully created product."
      redirect_to @product
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @product.update_attributes(params[:product])
      flash[:notice] = "Successfully updated product."
      redirect_to @product
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @product.destroy
    flash[:notice] = "Successfully destroyed product."
    redirect_to products_url
  end

private

	def get_product
		begin
	    @product = Product.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			flash[:error] = 'Product not found.'
			redirect_to products_url
		end	
	end
  
end
