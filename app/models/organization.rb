class Organization < ActiveRecord::Base
	default_scope :order => 'organizations.name',
		:include => [:organization_type, :account_type]
	
	#===== CLASS ASSOCIATIONS ======
	belongs_to :account_type
	belongs_to :organization_type
	has_many :users, :dependent => :destroy
	has_many :political_campaigns, :dependent => :destroy
	accepts_nested_attributes_for :political_campaigns

	has_many :federal_campaigns
	accepts_nested_attributes_for :federal_campaigns	

	has_many :state_campaigns
	accepts_nested_attributes_for :state_campaigns	
	
	#===== CLASS VALIDATIONS =====
validates_presence_of :organization_type_id, :name, :account_type_id
	validates_length_of :phone, :fax, :is => 10, :allow_nil => true, :allow_blank => true
	validates_numericality_of :phone, :fax, :integer => true, :message => 'is not valid', :allow_nil => true, :allow_blank => true
	validates_associated :organization_type
	validates_associated :account_type

	#====== CLASS PROPERTIES ======
	attr_accessor :phone_area_code, :phone_prefix, :phone_suffix
	attr_accessor :fax_area_code, :fax_prefix, :fax_suffix
	attr_accessor :per_page #how many results per page to display
	@@per_page = 10

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

	def fax_area_code
		return unless !fax.blank?
		fax[0,3]
	end

	def fax_prefix
		return unless !fax.blank?
		fax[3,3]
	end

	def fax_suffix
		return unless !fax.blank?
		fax[6,4]
	end
	
	#====== CLASS EVENTS ======
	def before_validation
		begin
			self.phone = @phone_area_code + @phone_prefix + @phone_suffix
		rescue
		end
		
		begin
			self.fax = @fax_area_code+@fax_prefix+@fax_suffix
		rescue
		end
	end	

private
	#===== PRIVATE METHODS ======
	
end
