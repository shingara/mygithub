class User
  include Mongoid::Document

  field :github_login, :type => String, :index => true
  field :login, :type => String, :index => true
  field :following, :type => Array
  field :repo_watched, :type => Array

  validates_presence_of :login
  validates_presence_of :github_login

  validate :need_valid_github_login

  validates_uniqueness_of :login
  validates_uniqueness_of :github_login

  devise :database_authenticatable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  before_create :fetch_following
  before_create :fetch_repo_watched

  def update_github_data!
    fetch_following
    fetch_repo_watched
    save!
  end

  private

  def need_valid_github_login
    errors.add(:github_login, 'unknow on github') if Octopussy.user(github_login).empty?
  rescue Crack::ParseError
    errors.add(:github_login, 'unknow on github')
  end

  def fetch_following
    self.following = Octopussy.following(github_login)
  end

  def fetch_repo_watched
    self.repo_watched = Octopussy.watched(github_login)
  end

end
