class User
  include Mongoid::Document

  field :github_login, :type => String
  field :login, :type => String

  validates_presence_of :login
  validates_presence_of :github_login

  devise :database_authenticatable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

end
