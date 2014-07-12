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
