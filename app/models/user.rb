class User
  include Mongoid::Document

  field :github_login, :type => String, :index => true
  field :login, :type => String, :index => true

  validates_presence_of :login
  validates_presence_of :github_login
  validate :need_valid_github_login
  validates_uniqueness_of :login
  validates_uniqueness_of :github_login

  devise :database_authenticatable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  def need_valid_github_login
    errors.add(:github_login, 'unknow on github') if Octopussy.user(github_login).empty?
  rescue Crack::ParseError
    errors.add(:github_login, 'unknow on github')
  end

end
