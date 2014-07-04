class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # not using: :registerable, :rememberable, 
  devise :async, :database_authenticatable, :lockable, :recoverable, 
        :timeoutable, :trackable, :validatable, :registerable

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
  def confirm_other_admin_exists
    return User.where("users.id != ?", id).includes(:roles).where("roles.name = ?", 'Administrator').exists?
  end
  # end private instance methods
end
