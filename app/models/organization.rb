class Organization < ActiveRecord::Base
	default_scope :order => 'organizations.name',
		:include => [:account, :organization_type]
	
	named_scope :active, :conditions => ['enabled = true']
	
	#===== CLASS ASSOCIATIONS ======
	has_one :account, :dependent => :destroy
	accepts_nested_attributes_for :account
	has_one :prepay_account
	has_one :invoice_account
	belongs_to :organization_type
	has_many :users, :dependent => :destroy
	has_many :political_campaigns, :dependent => :destroy
	accepts_nested_attributes_for :political_campaigns

	has_many :federal_campaigns, :dependent => :destroy
	accepts_nested_attributes_for :federal_campaigns	

	has_many :state_campaigns, :dependent => :destroy
	accepts_nested_attributes_for :state_campaigns	

	has_many :county_campaigns, :dependent => :destroy
	accepts_nested_attributes_for :county_campaigns	

	has_many :municipal_campaigns, :dependent => :destroy
	accepts_nested_attributes_for :municipal_campaigns	
	
	#===== CLASS VALIDATIONS =====
	validates_presence_of :organization_type_id, :name
	validates_length_of :phone, :fax, :is => 10, :allow_nil => true, :allow_blank => true
	validates_numericality_of :phone, :fax, :integer => true, :message => 'is not valid', :allow_nil => true, :allow_blank => true
	validates_associated :organization_type
	validates_associated :account
	validates_uniqueness_of :email

	#====== CLASS PROPERTIES ======
	attr_accessor :account_type_id
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
	def after_find
		case self.account.class.to_s
			when 'PrepayAccount' then
				@account_type_id = AccountType.find_by_name('Pre-Pay').id
			when 'InvoiceAccount' then
				@account_type_id = AccountType.find_by_name('Invoice').id
			else
				raise 'Invalid Account Type for Organization'
			end
	end	

	def before_update
		return true unless !@account_type_id.nil?

		begin
			account_type = AccountType.find(@account_type_id)
		rescue
			errors.add_to_base('Account Type not found.')
			return
		end

		case account_type.name
			when 'Pre-Pay' then 
				if self.invoice_account
					sql = "UPDATE accounts SET type = 'PrepayAccount' WHERE accounts.id = #{self.account.id}"
					ActiveRecord::Base.connection.execute(sql)
				end
			when 'Invoice' then
				if self.prepay_account
					sql = "UPDATE accounts SET type = 'InvoiceAccount' WHERE accounts.id = #{self.account.id}"
					ActiveRecord::Base.connection.execute(sql)
				end
			else
				errors.add_to_base('Organization Account Type could not be determined.')
		end
	
	end

	def before_validation_on_create
		self.build_prepay_account unless !@account_type_id.nil?

		begin
			account_type = AccountType.find(@account_type_id)
		rescue
			account_type = AccountType.find_by_name("Pre-Pay")
		end
		case account_type.name
			when 'Pre-Pay' then 
				self.build_prepay_account
			when 'Invoice' then
				self.build_invoice_account
			else
				errors.add_to_base('Organization Account Type could not be determined.')
		end

	end
	
	def before_create
		if self.enabled.nil?
			self.enabled = true
		end
	end

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
