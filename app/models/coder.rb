class Coder
  include Mongoid::Document
  field :login, :type => String
  field :atom_url, :type => String

  validates_presence_of :login, :atom_url
  validates_uniqueness_of :login, :atom_url

  index :login#, :unique => true
  index :atom_url#, :unique => true

  def parse_entries(entries)

  end
end
