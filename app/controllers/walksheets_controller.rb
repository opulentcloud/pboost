class WalksheetsController < ApplicationController
	before_filter :require_user
	before_filter :get_walksheet, :only => [:show, :edit, :update, :destroy]
	filter_access_to :all

  def index
    @walksheets = current_political_campaign.walksheets.all
  end
  
  def show
  end
  
  def new
    @walksheet = Walksheet.new
  end
  
  def create
    @walksheet = Walksheet.new(params[:walksheet])
    if @walksheet.save
      flash[:notice] = "Successfully created walksheet."
      redirect_to @walksheet
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @walksheet.update_attributes(params[:walksheet])
      flash[:notice] = "Successfully updated walksheet."
      redirect_to @walksheet
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @walksheet.destroy
    flash[:notice] = "Successfully destroyed walksheet."
    redirect_to walksheets_url
  end
  
private

	#get the walksheet for the current user
	def get_walksheet
		begin
    @walksheet = current_political_campaign.walksheets.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Walk Sheet was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end