class ReportsController < ApplicationController
	before_filter :require_user
	before_filter :get_walksheet, :only => [:show, :printable_list, :csv_list, :send_pdf_file]

	layout nil

	def index
		output = HelloReport.new(:page_layout => :landscape, :top_margin => 10).to_pdf
		respond_to do |format|
			format.pdf do
				send_data output, :filename => 'hello.pdf',
					:type => 'application/pdf'
			end
		end	
	end

	def show
		@lines_per_page = 28
		
		respond_to do |format|
			format.csv { csv_list }
			format.pdf { prawnto :prawn => {:page_size => 'A4', :page_layout => :landscape, :left_margin => 90, :right_margin => 5}, :inline => false, :skip_page_creation => false }
			format.html { 
				@report = render_walk_sheet_list_as :html	
			}
		end
	end

	def send_pdf_file
		send_file "#{RAILS_ROOT}/docs/multi_page_table.pdf", :type => "application/pdf", :x_sendfile => true
	end

	def printable_list
		pdf = WalksheetReport.new(:walksheet => walksheet, :page_layout => :landscape).to_pdf
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
		WalkSheetReport.render(format, :walksheet => @walksheet.id)
	end

	def get_walksheet
		begin
    @walksheet = current_political_campaign.walksheets.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Walk Sheet was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end
