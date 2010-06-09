class GisRegionsController < ApplicationController
  def index
    @gis_regions = GisRegion.all
  end
  
  def show
#debugger
    @gis_region = GisRegion.find(params[:id])
    logger.info(@gis_region.to_vertices_array)
  end
  
  def new
    @gis_region = GisRegion.new
  end
  
  def create
    @gis_region = GisRegion.new(params[:gis_region])
    if @gis_region.save
      flash[:notice] = "Successfully created gis region."
      redirect_to @gis_region
    else
      render :action => 'new'
    end
  end
  
  def edit
    @gis_region = GisRegion.find(params[:id])
  end
  
  def update
    @gis_region = GisRegion.find(params[:id])
    if @gis_region.update_attributes(params[:gis_region])
      flash[:notice] = "Successfully updated gis region."
      redirect_to @gis_region
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @gis_region = GisRegion.find(params[:id])
    @gis_region.destroy
    flash[:notice] = "Successfully destroyed gis region."
    redirect_to gis_regions_url
  end
end
