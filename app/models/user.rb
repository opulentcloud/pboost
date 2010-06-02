class User < ActiveRecord::Base
	#===== authlogic config ======
	acts_as_authentic do |c| #AuthLogic base
		c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
		c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
		c.logged_in_timeout = 90.minutes
	end

	#===== SCOPES =======
	default_scope :include => [:organization, :time_zone, :roles]

	#===== VALIDATIONS ======
	validates_associated :roles
	validates_presence_of :first_name, :last_name
	validates_presence_of :organization_id, :if => :should_validate_organization?
	validates_associated :organization, :if => :should_validate_organization?
	validates_associated :time_zone
	validates_length_of :phone, :is => 10, :allow_nil => true, :allow_blank => true
	validates_numericality_of :phone, :integer => true, :message => 'is not valid', :allow_nil => true, :allow_blank => true

	#===== ASSOCIATIONS =====
	has_and_belongs_to_many :roles
	
	belongs_to :organization
	accepts_nested_attributes_for :organization

	belongs_to :time_zone

	has_many :political_campaigns, :through => :organization

	#===== PROPERTIES ======
	attr_accessor :phone_area_code, :phone_prefix, :phone_suffix

	def phone_area_code
		return unless !phone.blank?
		phone[0,3]
	end

	def phone_prefix
		return unless !phone.blank?
		phone[3,3]
	end

	def phone_suffix
		return unless !phone.blank?
		phone[6,4]
	end

	#====== EVENTS ======
	def before_validation
		begin
			self.phone = @phone_area_code + @phone_prefix + @phone_suffix
		rescue
		end	
	end	

	#===== METHODS =====
	def active?
		active
	end

	def has_no_credentials?
		crypted_password.blank?
	end

	def role_symbols
		roles.map do |role|
			role.name.downcase.underscore.to_sym
		end	
	end

private
	#===== PRIVATE METHODS =====
	def should_validate_organization?
		roles.include?('Customer')
	end

end
