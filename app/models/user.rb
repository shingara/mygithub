class User
  include Mongoid::Document

  field :github_login, :type => String
  field :login, :type => String
  field :following, :type => Array
  field :repo_watched, :type => Array
  field :atom_feeds, :type => Array, :default => []

  validates_presence_of :login
  validates_presence_of :github_login

  validate :need_valid_github_login

  validates_uniqueness_of :login
  validates_uniqueness_of :github_login
  index :login#, :unique => true
  index :github_login#, :unique => true

  devise :database_authenticatable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  before_save :fetch_following
  before_save :fetch_repo_watched
  before_save :update_atom_feeds

  after_save :push_atom_feeds

  def update_github_data!
    fetch_following
    fetch_repo_watched
    save!
  end

  def coders
    following.map{|f| Coder.where(:login => f).limit(1).first}
  end

  def repositories
    repo_watched.map{|f| Repository.where(:url => f['url']).limit(1).first}
  end

  private

  def need_valid_github_login
    errors.add(:github_login, 'unknow on github') if Octopussy.user(github_login).empty?
  rescue Crack::ParseError
    errors.add(:github_login, 'unknow on github')
  end

  def fetch_following
    self.following = Octopussy.following(github_login)
    self.following.each {|f|
      Coder.find_or_create_by(:login => f, :atom_url => "http://github.com/#{f}.atom")
    }
  end

  def fetch_repo_watched
    self.repo_watched = Octopussy.watched(github_login)
    self.repo_watched.each do |repo|
      next unless repo.is_a?(Hash)
      next unless repo.has_key?('url')
      re = Repository.find_or_initialize_by(:url => repo['url'])
      re.owner = repo['owner']
      re.name = repo['name']
      # TODO: Add other branches
      re.atom_url << File.join(repo['url'], '/commits/master.atom')
      re.save
    end
  end

  def update_atom_feeds
    self.atom_feeds = []
    following.each do |f|
      self.atom_feeds << "http://github.com/#{f}.atom"
    end
    repo_watched.each do |r|
      self.atom_feeds << "#{r['url']}/commits/master.atom"
    end
  end

  def push_atom_feeds
    self.atom_feeds.each do |atom|
      Mygithub::Application::SUBSCRIBE_CHANNEL.push(atom)
    end
  end

end
