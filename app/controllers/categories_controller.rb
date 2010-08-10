class CategoriesController < ApplicationController
	before_filter :require_user
	filter_access_to :all
	before_filter :get_category, :only => [:show, :edit, :update, :destroy]

	layout 'admin'
	
  def index
    @categories = Category.all
  end
  
  def show
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully created category."
      redirect_to @category
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @category.update_attributes(params[:category])
      flash[:notice] = "Successfully updated category."
      redirect_to @category
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @category.destroy
    flash[:notice] = "Successfully destroyed category."
    redirect_to categories_url
  end

private

	def get_category
		begin
	    @category = Category.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			flash[:error] = 'Category not found.'
			redirect_to categories_url
		end	
	end
end
