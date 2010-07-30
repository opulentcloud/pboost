class ClubTexting
	require 'rubygems'
	require 'uri'
	require 'net/https'
	
	CLUB_TEXTING_URL = 'https://app.clubtexting.com/api/sending/'

	attr_accessor :user_name, :password, :message, :express, :list

	def initialize(msg, list)
		self.user_name = 'dstinnie'# if self.user_name.blank?
		self.password = 'china1'# if self.password.blank?
		self.message = msg
		self.express = '1'
		self.list = list
	end

	def send_messages!
		uri = URI.parse(CLUB_TEXTING_URL)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true if uri.scheme == 'https'

		self.list.each do |sms|
			txt = ClubTexting::TextMessage.new(self.user_name, self.password, sms.cell_phone, self.message, self.express)
			sms.status = send_text(uri, http, txt)
			sms.save!
			if ['-1','-2','-7'].include?(sms.status)
				raise "Exiting SMS Scheduled Send Prematurely Due To Error Code #{sms.status} being encountered."
			end
		end	

		http = nil
	end

	def send_text(uri, http, message)
		
		headers = { 'Content-Type' => 'application/x-www-form-urlencoded', 'Content-Length' => message.to_s.size.to_s }

		puts message.to_s
		
		post = Net::HTTP::Post.new(uri.path, headers)
		post.basic_auth uri.user, user.password if uri.user
		response = http.request post, message.to_s

		case response
			when Net::HTTPCreated; response('Location')
			when Net::HTTPSuccess; response.body;
			else response.error;
		end
		
	end
	
	def valid_characters(text)
		#valid characters are a-z, A-Z, 0-9, .,:;!?()~=+-_\/@$#&%
		#the following characters count as two:
		# ~ @ # % + = / \ \r\n
	end

	def translate_response(response)
		case response
			when '1' then 'Message Sent'
			when '-1' then 'Invalid user or password'
			when '-2' then 'Credit Limit Reached'
			when '-5' then 'Local Opt Out'
			when '-7' then 'Subject or Message contains invalid characters'
			when '-104' then 'Globally Opted Out'
			when '-106' then 'Incorrectly Formatted Phone Number'
			when '-10' then 'Unknown Error'
			else
				'Unknown Response'
			end
	end

	class TextMessage
		attr_accessor :user_name, :password, :phone_number, :message, :express

		def initialize(username, pwd, cell_number, msg, express)
			self.user_name = username
			self.password = pwd
			self.phone_number = cell_number
			self.message = msg
			self.express = express
		end

		def to_s
			"user=#{user_name}&pass=#{password}&phonenumber=#{phone_number}&subject=&message=#{message}&express=#{express}"
		end

	end
	
end
