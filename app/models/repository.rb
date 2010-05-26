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

  has_many_related :events, :foreign_key => 'from_id'

  index :url#, :unique => true
  index :atom_url#, :unique => true

  def parse_entries(entries)
    #tag:github.com,2008:Grit::Commit/59c7b0c23a58b2499c911d8907ecd936b73b0172
    entries.each do |entry|
      if entry.id =~ /Grit::Commit\/(.+)/
        CommitEvent.create(:commit_id => $1,
                           :from_id => self.id,
                           :from_type => self.class,
                           :published_at => entry.published,
                           :message => entry.title,
                           :content => entry.content)
      else
        Entry.create(:content => entry.inspect)
      end
    end
  end
end
