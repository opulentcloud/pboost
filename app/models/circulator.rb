# == Schema Information
#
# Table name: circulators
#
#  id           :integer          not null, primary key
#  first_name   :string(32)
#  last_name    :string(32)
#  name         :string(65)       not null
#  address      :string(100)      not null
#  city         :string(32)       not null
#  state        :string(2)        not null
#  zip          :string(5)        not null
#  phone_number :string(10)       not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Circulator < ActiveRecord::Base

  # begin associations
  has_many :petition_headers_circulators, dependent: :destroy
  has_many :petition_headers, through: :petition_headers_circulators
  # end associations
  
  # begin callbacks
  before_validation :do_before_validation
  # end callbacks
  
  # begin validations
  validates_presence_of :first_name, :last_name, :address, :city, :state, :zip, :phone_number
  # end validations

  # begin public instance methods
  def phone_number_formatted
    return '' if phone_number.blank?
    "(#{phone_number[0,3]}) #{phone_number[3,3]}-#{phone_number[6,4]}"
  end
  # end public instance methods
  
  private

  def do_before_validation
    populate_name
    format_phone_number
  end

  def populate_name
    self.name = "#{first_name} #{last_name}".squeeze(' ').strip
  end

  # Store the phone number properly formatted into the database.
  def format_phone_number
    return unless new_record? || phone_number_changed?
    phone = phone_number.to_s.scan(/\d/).join
    phone = phone[1..-1] if phone.starts_with?('1')
    self.phone_number = phone
  end
  
end
