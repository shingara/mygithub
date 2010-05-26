class Coder
  include Mongoid::Document
  field :login, :type => String
  field :atom_url, :type => String

  validates_presence_of :login, :atom_url
  validates_uniqueness_of :login, :atom_url

  index :login#, :unique => true
  index :atom_url#, :unique => true

  has_many_related :events, :foreign_key => 'from_id'

  def parse_entries(entries)
    entries.each do |entry|
      if entry.id =~ /PushEvent:(\d+)/
        PushEvent.create(:github_id => $1,
                         :from_id => self.id,
                         :from_type => self.class,
                         :published_at => entry.published,
                         :title => entry.title)
      elsif entry.id =~ /WatchEvent:(\d+)/
        github_id = $1
        entry.title =~ /(.+) started watching (.+)/
          WatchEvent.create(:github_id => github_id,
                            :from_id => self.id,
                            :from_type => self.class,
                            :published_at => entry.published,
                            :who => $1,
                            :what => $2)
      else
        Entry.create(:content => entry.inspect)
      end

    end
    #PushEvent
    #WatchEvent
    #CommitCommentEvent
    #CreateEvent
    #ForkEvent
  end
end
