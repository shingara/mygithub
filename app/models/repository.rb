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
    #tag:github.com,2008:Grit::Commit/59c7b0c23a58b2499c911d8907ecd936b73b0172
    entries.each do |entry|
      Rails.logger.info(entry.id)
      Entry.create(:content => entry.inspect)
      if entry.id =~ /Grit::Commit\/(.+)/
        events << CommitEvent.create(:commit_id => $1,
                                     :published_at => entry.published,
                                     :message => entry.title,
                                     :content => entry.content)
        save!
      end
    end
  end
end
