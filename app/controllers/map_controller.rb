class MapController < ApplicationController
	#this automatically populates session[:geo_location]
	#with a GeoLoc object based on visitors ip address
	geocode_ip_address
	before_filter :check_geo_location
	before_filter :require_user, :on => [:add_polygon, :add_vertices]

  def index
		@session_key = UUIDTools::UUID.timestamp_create
  end  

	def add_polygon
	debugger
		logger.debug(params)
		if request.post?
			p params[:name]
			p params[:vertices]
			
			poly = Polygon.from_coordinates([session[:vertices]])

			#save model here
			@gis_region = GisRegion.new(:name => params[:name],
				:geom => poly, :political_campaign_id => current_user.political_campaigns.first.id)
			
			if @gis_region.save
				#send javascript back to update the map
				run_javascript do |script|
					map = script.map
					#map.clear_overlays
					#new_polygon = Google::Polygon.new(:vertices => session[:vertices], :fill_colour => 'yellow', :border_colour => 'green')
					#map.add_overlay(new_polygon)
					map.update_info_window :html => "GIS Region #{params[:name]} saved!"
				end
			else
					map.update_info_window :html => "Ooops, we were not able to save your GIS Region!  Please click on it to try again."
			end
		end
	end

	def add_vertices
		logger.debug(params)
		if request.post?
			session[:vertices] = GisRegion.coordinates_from_text(params[:vertices])
		end

	end

	def add_marker
		if request.post?
			p params[:name]
			p params[:location]
			
			#save model here
			
			#send javascript back to update the map
			run_javascript do |script|
				map = script.map
				map.add_marker :location => params[:location]
				map.update_info_window :html => 'You have added a new marker!'
			end
		end
	end
  
private
 
 	#if we could not find a good location, just set our default.
	def check_geo_location
  	session[:geo_location] ||= GeoKit::GeoLoc.new(:lat => 39.3597710000, :lng => -76.6716720000, :city => 'Baltimore')
	end

  
end
