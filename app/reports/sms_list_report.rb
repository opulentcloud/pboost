class SmsListReport < Ruport::Controller

	stage :list

	def setup
		options.paper_orientation = :portrait
		conditions = ["sms_list.id = ?", options.sms_list]
		self.data = SmsList.find(options.sms_list).voters.report_table(:all,
 :conditions => { "cell_phone != ''" } 
 :only => ['last_name', 'first_name', 'cell_phone'], 
)
	
		data.rename_columns('last_name' => 'Last Name', 'first_name' => 'First Name', 'cell_phone', 'Cell Phone')

	end

	formatter :html do
		build :list do
			output << "<h2>SMS List</h2>"
			output << data.to_html
		end
	end

	formatter :pdf do
		build :list do
			pad(5) { add_text "SMS List" }
			draw_table data
		end
	end

	formatter :csv do
		build :list do
			output << data.to_csv
		end
	end	
end

