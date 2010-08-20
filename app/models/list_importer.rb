class ListImporter
	attr_accessor :file_name, :list_type, :contact_list_id, :mapped_fields, :map_fields_error

	def initialize(filename, listtype, list_id, mappedfields = nil)
		self.file_name = filename
		self.list_type = listtype
		self.contact_list_id = list_id
		self.mapped_fields = mappedfields
		
		case listtype
			when 'robocall_list' then
				if mappedfields.nil?
					self.mapped_fields = { :phone => 0 }
				end
			
			when 'sms_list' then
				if mappedfields.nil?
					self.mapped_fields = { :cell_phone => 0 }
				end

			when 'survey' then
				if mappedfields.nil?
					self.mapped_fields = { :state_file_id => 0 }
				end

		end
		
	end

	def rows(x = 10)
		@rows = []

		begin
			FasterCSV.foreach(self.file_name, :headers => false, :col_sep => ",") do |row|
				@rows << row
				break if @rows.size == x
			end
		rescue FasterCSV::MalformedCSVError => e
			@map_fields_error = e
			raise e
		end
		@rows	
	end

	def need_mapping
		@row

		begin
			FasterCSV.foreach(self.file_name, :headers => false, :col_sep => ",") do |row|
				@row = row
				break
			end
		rescue FasterCSV::MalformedCSVError => e
			@map_fields_error = e
			raise e
		end

		case list_type
			when 'robocall_list' then
				return @row.size != 1
			when 'sms_list' then
				return @row.size != 1
			when 'survey' then
				@list = ContactList.find(self.contact_list_id)
				return (@mapped_fields.size - 1) != @list.questions.count
		end

	end

	def import!
		@list = ContactList.find(self.contact_list_id)
#debugger
		begin
			FasterCSV.foreach(self.file_name) do |row|
				case list_type
					when 'robocall_list' then
						cls = ContactListRobocall.new
						cls.phone = valid_phone_number(row[self.mapped_fields[:phone]])
						@list.contact_list_robocalls << cls unless cls.phone.blank? || @list.contact_list_robocalls.exists?(:phone => cls.phone)
					when 'sms_list' then
						cls = ContactListSmss.new
						cls.cell_phone = valid_phone_number(row[self.mapped_fields[:cell_phone]])
						@list.contact_list_smsses << cls unless cls.cell_phone.blank? || @list.contact_list_smsses.exists?(:cell_phone => cls.cell_phone)
					when 'survey' then
						voter = Voter.find_by_state_file_id(row[self.mapped_fields[:state_file_id]])
						if !(@list.voters.exists?(voter) || voter.nil?)
							@list.voters << voter
							self.mapped_fields.each do |map|
								if map[0].to_s[0,9] == "question_"
									question_id = map[0].to_s.gsub('question_','').to_i
									answer_text = row[map[1]]
									voter.survey_results.create(:contact_list_id => @list.id, :question_id => question_id, :answer => answer_text)
								end
							end
						end
				end
			end
		rescue FasterCSV::MalformedCSVError => e
			@map_fields_error = e
			raise e
		end
	
	end

	def valid_phone_number(phone)
		return '' unless !phone.nil?
		a = ''
		phone.split('').each do |n|
			a += n if n =~ /[0-9]/
		end
		a = a[1, a.size] if a[0] == 49 #remove leading 1's
		a = '' if a.size != 10
		a
	end

end

