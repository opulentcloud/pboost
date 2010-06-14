class WalkSheetsController < ApplicationController

	def index
		@walk_sheet = render_walk_sheet_list_as :html		
	end

	def show
		respond_to do |format|
			format.csv { csv_list }
			format.pdf { printable_list }
			format.html { 
				@walk_sheet = render_walk_sheet_list_as :html	
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
		WalkSheetReport.render(format, :gis_region => params[:id])
	end

end
