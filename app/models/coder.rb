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
      Rails.logger.info(entry.id)
      Entry.create(:content => entry.inspect)
      if entry.id =~ /PushEvent:(\d+)/
        events << PushEvent.create(:github_id => $1,
                                   :published_at => entry.published,
                                   :title => entry.title)
        save!
      end

      if entry.id =~ /WatchEvent:(\d+)/
        github_id = $1
        entry.title =~ /(.+) started watching (.+)/
        events << WatchEvent.create(:github_id => github_id,
                                   :published_at => entry.published,
                                   :who => $1,
                                   :what => $2)
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
