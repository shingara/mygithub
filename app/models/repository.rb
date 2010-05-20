class Repository
  include Mongoid::Document
  field :owner, :type => String
  field :name, :type => String
  field :url, :type => String
  field :atom_url, :type => Array, :default => []

  validates_presence_of :name
  validates_presence_of :owner
  validates_presence_of :url
  validates_presence_of :atom_url
  validates_uniqueness_of :url

  index :url#, :unique => true
  index :atom_url#, :unique => true

  def parse_entries(entries)

  end
end
