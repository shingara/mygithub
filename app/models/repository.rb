class Repository
  include Mongoid::Document
  field :owner, :type => String
  field :name, :type => String
  field :url, :type => String

  validates_presence_of :name
  validates_presence_of :owner
  validates_presence_of :url
  validates_uniqueness_of :url
  index :url, :unique => true
end
