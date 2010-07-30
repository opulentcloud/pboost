class SmsListReport < Ruport::Controller

	stage :list

	def setup
	debugger
		options.paper_orientation = :portrait
		conditions = ["sms_list.id = ?", options.sms_list]
		self.data = SmsList.find(options.sms_list).contact_list_smsses.report_table(:all,
 :only => ['cell_phone']
)
	
		self.data.rename_columns('cell_phone' => 'Cell Phone')

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

