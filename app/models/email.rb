class Email < ActiveRecord::Base
  validates :address, presence: true, uniqueness: { case_sensitive: false }
end
