class ListImporter

	attr_accessor :file_name, :list_type, :contact_list_id, :map_fields_error

	def initialize(filename, listtype, list_id)
		self.file_name = filename
		self.list_type = listtype
		self.contact_list_id = list_id
	end

	def need_mapping?	
		@row

		begin
			FasterCSV.foreach(self.file_name) do |row|
				@row = row
				break
			end
		rescue FasterCSV::MalformedCSVError => e
			@map_fields_error = e
			raise e
		end

		case list_type
			when 'sms_list' then
				return !@row.size == 1
		end

	end

	def import!
		@list = ContactList.find(self.contact_list_id)
debugger
		begin
			FasterCSV.foreach(self.file_name) do |row|
				case list_type
					when 'sms_list' then
						cls = ContactListSmss.new
						cls.cell_phone = valid_phone_number(row[0])
						@list.contact_list_smsses << cls unless cls.cell_phone.blank? || @list.contact_list_smsses.exists?(:cell_phone => cls.cell_phone)
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
		phone.each do |n|
			a += n if n =~ /[0-9]/
		end
		a = a[1, a.size] if a[0] == '1'
		a = '' if a.size != 10
		a
	end

end

