class Coder
  include Mongoid::Document
  field :login, :type => String
  validates_uniqueness_of :login
  index :login, :unique => true
end
