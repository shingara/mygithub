class User
  include Mongoid::Document

  field :github_login, :type => String
  field :login, :type => String

  devise :database_authenticatable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

end
