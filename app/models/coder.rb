class Coder
  include Mongoid::Document
  field :login, :type => String
  field :atom_url, :type => String

  validates_presence_of :login, :atom_url
  validates_uniqueness_of :login, :atom_url

  index :login#, :unique => true
  index :atom_url#, :unique => true

  has_many_related :events

  def parse_entries(entries)
    entries.each do |entry|
      if entry.id =~ /PushEvent:(\d+)/
        events << PushEvent.create(:github_id => $1,
                                   :published_at => entry.published,
                                   :title => entry.title)
        save!
      end

    end
    #PushEvent
    #WatchEvent
    #CommitCommentEvent
    #CreateEvent
    #ForkEvent
  end
end
