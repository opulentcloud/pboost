# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)      default(""), not null
#  last_name              :string(255)      default(""), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # not using: :registerable, :rememberable, 
  devise :async, :confirmable, :database_authenticatable, :lockable, 
    :recoverable, :timeoutable, :trackable, :validatable, :registerable,
    :rememberable, :omniauthable

  # begin validations
  validates :first_name, presence: true
  validates :last_name, presence: true 
  # end validations

  # begin associations
  has_many :users_roles
  has_many :roles, through: :users_roles
  accepts_nested_attributes_for :roles, allow_destroy: true
  has_many :verifications, dependent: :destroy
  has_many :petition_headers_users, dependent: :destroy
  has_many :petition_headers, through: :petition_headers_users
  def circulators
    if is_in_role?("Administator") || is_in_role?("Employee")
      Circulator.order(:last_name).order(:first_name)
    elsif is_in_role?("Customer")
      Circulator.joins(:petition_headers).where("petition_headers.id IN (?)", petition_headers.pluck(:id)).order("circulators.last_name, circulators.first_name")
    else
      Circulator.where("1=0")
    end
  end
  # end associations

  # begin callbacks
  after_create :check_for_roles
  before_destroy :confirm_other_admin_exists
  # end callbacks
  
  # begin instance methods
  def name
    "#{first_name} #{last_name}".squeeze(' ').strip
  end
  
  def is_in_role?(name)
    roles.where(name: name).exists?
  end
  # end instance methods
  
  # begin private instance methods
private
  # A new user should be given the customer role unless they have roles defined
  def check_for_roles
    return if roles.exists?
    roles << Role.where(name: 'Customer').first
  end

  def confirm_other_admin_exists
    return User.where("users.id != ?", id).includes(:roles).where("roles.name = ?", 'Administrator').exists?
  end
  # end private instance methods
end
