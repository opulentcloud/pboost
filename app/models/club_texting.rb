class ClubTexting
	require 'rubygems'
	require 'uri'
	require 'net/https'
	
	CLUB_TEXTING_URL = 'https://app.clubtexting.com/api/sending/'

	class TextMessage
		attr_accessor :user_name, :password, :phone_number, :subject, :message, :express

		def initialize(usr, pwd, phn, sub, msg, exp)
			self.user_name = usr
			self.password = pwd
			self.phone_number = phn
			self.subject = sub
			self.message = msg
			self.express = exp
			
			#testing
			self.user_name = 'dstinnie' if self.user_name.blank?
			self.password = 'china1' if self.password.blank?
			self.phone_number = '9497357010' if self.phone_number.blank?
			self.subject = 'Test Subject' if self.subject.blank?
			self.message = 'Test Message' if self.message.blank?
			self.express = '1' if self.express.blank?
		end

		def to_s
			"user=#{user_name}&pass=#{password}&phonenumber=#{phone_number}&subject=#{subject}&message=#{message}&express=#{express}"
		end

	end
	
	def self.send_text(message)
		uri = URI.parse(CLUB_TEXTING_URL)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true if uri.scheme == 'https'
		
		headers = { 'Content-Type' => 'application/x-www-form-urlencoded', 'Content-Length' => message.to_s.size.to_s }

		puts message.to_s
		
		post = Net::HTTP::Post.new(uri.path, headers)
		post.basic_auth uri.user, user.password if uri.user
		response = http.request post, message.to_s

		case response
			when Net::HTTPCreated; response('Location')
			when Net::HTTPSuccess; ClubTexting.translate_response(response.body);
			else response.error;
		end
		
	end
	
	def self.valid_characters(text)
		#valid characters are a-z, A-Z, 0-9, .,:;!?()~=+-_\/@$#&%
		#the following characters count as two:
		# ~ @ # % + = / \ \r\n
	end

	def self.translate_response(response)
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
	
end
