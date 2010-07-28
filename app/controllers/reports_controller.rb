class ReportsController < ApplicationController
	before_filter :require_user
	before_filter :get_contact_list, :only => [:show, :printable_list, :csv_list, :send_pdf_file]

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
		respond_to do |format|
			format.csv { send_csv_file }
			format.pdf { 
				if @contact_list.class.to_s != 'Walksheet'
					@contact_list.errors.add_to_base('You can not print a Walksheet from this List.')
					redirect_to contact_list_url(@contact_list)
				end	
				send_pdf_file 
			}
		end
		
		return
		#@lines_per_page = 28
		#respond_to do |format|
			#format.csv { csv_list }
			#format.pdf { prawnto :prawn => {:page_size => 'A4', :page_layout => :landscape, :left_margin => 90, :right_margin => 5}, :inline => false, :skip_page_creation => false }
			#format.html { 
			#	@report = render_walk_sheet_list_as :html	
			#}
		#end
	end

	def send_csv_file
		full_file_name = ''
		file_name = ''
		rendered_report = nil

		case @report_type
			when 'sms_list' then 
				full_file_name = "#{RAILS_ROOT}/docs/sms_list_#{@contact_list.id}.csv"
				file_name = "sms_list_#{@contact_list.id}.csv"
				rendered_report = @contact_list.contact_list_smsses.report_table(:all, :only => ['cell_phone']).save_as(full_file_name) unless File.exists?(full_file_name)
		end	

		if rendered_report
			if rendered_report == ''
				File.delete(full_file_name)
				rendered_report = nil
				render :text => 'There are no records found for this list.'
				return
			#else
			#	send_data(rendered_report,
			#		:type => 'text/csv',
			#		:filename => file_name)
			end
		end
			
		if RAILS_ENV == 'production'
			send_file "#{full_file_name}", :type => "text/csv", :x_sendfile => true
		else
			send_file "#{full_file_name}", :type => "text/csv"
		end

	end

	def send_pdf_file
		if RAILS_ENV == 'production'
		send_file "#{RAILS_ROOT}/docs/canvass_list_#{@contact_list.id}.pdf", :type => "application/pdf", :x_sendfile => true
		else
			send_file "#{RAILS_ROOT}/docs/canvass_list_#{@contact_list.id}.pdf", :type => "application/pdf"
		end
	end

	def printable_list
		pdf = WalksheetReport.new(:walksheet => walksheet, :page_layout => :landscape).to_pdf
		send_data pdf, :type => 'application/pdf',
									:filename => 'canvass_list.pdf'
	end

	def csv_list
		csv = render_walk_sheet_list_as :csv
		send_data csv, :type => 'text/csv',
			:filename => 'canvass_list.csv'
	end

protected
	def render_walk_sheet_list_as(format)
		WalkSheetReport.render(format, :walksheet => @walksheet.id)
	end

	def get_contact_list
		begin
    	@contact_list = current_political_campaign.contact_lists.find(params[:sms_list_id] ||= params[:walksheet_id] ||= params[:id])
    	@report_type = params[:report_type]
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested List was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end
