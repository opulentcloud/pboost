class ReportsController < ApplicationController
	before_filter :require_user
	before_filter :get_gis_region, :only => [:show, :printable_list, :csv_list]

	def index
		@report = render_walk_sheet_list_as :html		
	end

	def show
		respond_to do |format|
			format.csv { csv_list }
			format.pdf { printable_list }
			format.html { 
				@report = render_walk_sheet_list_as :html	
			}
		end
	end

	def printable_list
		pdf = render_walk_sheet_list_as :pdf
		send_data pdf, :type => 'application/pdf',
									:filename => 'walksheet.pdf'
	end

	def csv_list
		csv = render_walk_sheet_list_as :csv
		send_data csv, :type => 'text/csv',
			:filename => 'walksheet.csv'
	end

protected
	def render_walk_sheet_list_as(format)
		WalkSheetReport.render(format, :gis_region => @gis_region.id)
	end

	def get_gis_region
		begin
    @gis_region = current_political_campaign.gis_regions.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested GIS Region was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end
