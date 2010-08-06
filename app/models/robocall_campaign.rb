class RobocallCampaign < Campaign

	#====== ASSOCIATIONS =======
	belongs_to :contact_list
	has_one :live_answer_attachment, :as => :attachable, :dependent => :destroy
	accepts_nested_attributes_for :live_answer_attachment
	has_one :answer_machine_attachment, :as => :attachable, :dependent => :destroy
	accepts_nested_attributes_for :answer_machine_attachment

	#====== VALIDATIONS =======
	validates_datetime :scheduled_at, 
		:after => lambda { Time.zone.now - 1.minute }, 
		:if => :do_scheduling?
	validates_presence_of :caller_id, :contact_list_id
	validate :valid_scrub_dnc
	validate :valid_caller_id
	validate :valid_sound_file

	#====== EVENTS ======
	def before_validation
		self.caller_id = format_caller_id
	end

	#====== INSTANCE METHODS ======
	def do_scheduling?
		!self.scheduled_at.blank?
	end

	def valid_scrub_dnc
		errors.add(:scrub_dnc, 'Please choose Yes or No for Scrub DNC') unless self.scrub_dnc == true || self.scrub_dnc == false
	end

	def valid_sound_file
		if self.single_sound_file == true
			errors.add_to_base('You must attach your sound file for Live Answer Calls.') if self.live_answer_attachment.nil?
		else
			errors.add_to_base('You must attach your sound file for Live Answer Calls and Answer Machine Calls.') if self.live_answer_attachment.nil? || self.answer_machine_attachment.nil?
		end
	end

	def valid_caller_id
		a = ''
		
		if !self.caller_id.nil?
			self.caller_id.split('').each do |tc|
				a += tc if (tc =~ /[0-9]/) == 0
			end

			a = a[1, a.size] if a[0] == 49 #remove leading 1
		end

		if a.size != 10
			errors.add(:caller_id, 'is not a valid phone number.')
		end
	end

	def format_caller_id
		a = ''
		
		if !self.caller_id.nil?
			self.caller_id.split('').each do |tc|
				a += tc if (tc =~ /[0-9]/) == 0
			end

			a = a[1, a.size] if a[0] == 49 #remove leading 1
		end

		self.caller_id = a.nil? ? nil : a
	end

	def is_deleteable?
		return true if ['n/a','Sent'].include?(self.status)
		false
	end

	def is_editable?
		return true if self.status == 'n/a'
		return true if self.scheduled_at.nil?
		return true if self.scheduled_at > Time.zone.now + 2.hours
		false
	end

	def status
		if !self.scheduled_at.nil? == true
			if (Time.zone.now > self.scheduled_at)
				'Sent'
			else
				'Scheduled'
			end
		else
			'n/a'
		end
	end

	def status_display
		s = self.status
		d = nil

		d = case s
			when 'Sent' then format_date_time(self.scheduled_at)
			when 'Scheduled' then format_date_time(self.scheduled_at)
			else ''			
		end
		d = ': ' + d unless d.blank?
		s+d
	end

end

