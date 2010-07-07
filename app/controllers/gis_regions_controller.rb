class GisRegionsController < ApplicationController
	before_filter :require_user
	before_filter :get_gis_region, :only => [:show, :edit, :update, :destroy]
	filter_access_to :all
	#this automatically populates session[:geo_location]
	#with a GeoLoc object based on visitors ip address
#	geocode_ip_address
#	before_filter :check_geo_location

  def index
  	pg = params[:page] ||= 1
    @gis_regions = current_political_campaign.gis_regions.paginate :page => pg, :per_page => 10

    respond_to do |format|
      format.html { render :index }
      format.xml  { render :xml => @gis_regions }
    end
  end
  
  def show
    logger.info(@gis_region.to_vertices_array)
  end
  
  def new
		if current_political_campaign.populated == false
			flash[:error] = 'You can not add GIS Regions until we have finished populating your Political Campaign Constituents'
			redirect_to gis_regions_path
			return
		end
		#@sess_id = UUIDTools::UUID.timestamp_create
    @gis_region = current_political_campaign.gis_regions.build
  end
  
  def count_in_poly
			poly = Polygon.from_coordinates([GisRegion.coordinates_from_text(params[:vertices])])

			@gis_region = GisRegion.new(:name => ('temp_' + UUIDTools::UUID.timestamp_create),
				:geom => poly, :political_campaign_id => current_political_campaign.id)
  		
  end
  
  def create
  	if request.post?
			
			polys = []
			l_count = -1
			while true do
				l_count += 1
				if params[('vertices_'+l_count.to_s).to_sym].nil?
					break
				end
				
				polys.push(Polygon.from_coordinates([GisRegion.coordinates_from_text(params[('vertices_'+l_count.to_s).to_sym])]))

			end
			
			poly = Polygon.from_coordinates([GisRegion.coordinates_from_text(params[:vertices_0])])
		
			mpoly = MultiPolygon.from_polygons(polys)
		
			#save model here
			@gis_region = GisRegion.new(:name => params[:name],
				:geom => poly, :geom2 => mpoly, :political_campaign_id => current_political_campaign.id)
			
			if @gis_region.save
				#send javascript back to update the map
				run_javascript do |script|
					map = script.map
					map.update_info_window :html => "GIS Region #{params[:name]} has been saved!"
				end
			else
				run_javascript do |script|
					map = script.map
					map.update_info_window :html => "Ooops, we were not able to save your GIS Region!  Please click on it to try again."
				end
			end
		end
  end

	def add_vertices
		if request.post?
			session[:sess_id] = GisRegion.coordinates_from_text(params[:vertices])
		end
  end
  
  def edit
  end
  
  def update
    if @gis_region.update_attributes(params[:gis_region])
      flash[:notice] = "Successfully updated GIS Region."
      redirect_to @gis_region
    else
      render :action => 'edit'
    end
  end
  
  def destroy
		@name = @gis_region.name
    @gis_region.destroy
    flash[:notice] = "Successfully deleted GIS Region: #{@name}."
    redirect_to gis_regions_url
  end
  
private

	#get the gis_region for the current user
	def get_gis_region
		begin
    @gis_region = current_political_campaign.gis_regions.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested GIS Region was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

 	#if we could not find a good location, just set our default.
	def check_geo_location
  	session[:geo_location] ||= GeoKit::GeoLoc.new(:lat => 39.3597710000, :lng => -76.6716720000, :city => 'Baltimore')
	end
	
end
