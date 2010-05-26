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
      if entry.id =~ /PushEvent\/(\d+)/
        PushEvent.create(:github_id => $1,
                         :title => entry.title,
                         :from_id => self.id,
                         :from_type => self.class,
                         :published_at => entry.published,
                         :title => entry.title)
      elsif entry.id =~ /WatchEvent\/(\d+)/
        github_id = $1
        entry.title =~ /(.+) started watching (.+)/
          WatchEvent.create(:github_id => github_id,
                             :title => entry.title,
                            :from_id => self.id,
                            :from_type => self.class,
                            :published_at => entry.published,
                            :who => $1,
                            :what => $2)
      elsif entry.id =~ /IssuesEvent\/(\d+)/
        github_id = $1
        entry.title =~ /(\S+) (\S+) issue (\d+) on (\S+)/
          IssueEvent.create(:github_id => github_id,
                             :title => entry.title,
                            :from_id => self.id,
                            :from_type => self.class,
                            :published_at => entry.published,
                            :who => $1,
                            :action => $2,
                            :num_issue => $3,
                            :repo_name => $4)
      elsif entry.id =~ /DeleteEvent\/(\d+)/
        github_id = $1
        entry.title =~ /(\S+) deleted branch (\S+) at (\S+)/
          DeleteEvent.create(:github_id => github_id,
                             :title => entry.title,
                            :from_id => self.id,
                            :from_type => self.class,
                            :published_at => entry.published,
                            :who => $1,
                            :branch => $2,
                            :repo_name => $3)
      elsif entry.id =~ /CreateEvent\/(\d+)/
        github_id = $1
        entry.title =~ /(\S+) created tag (\S+) at (\S+)/
          CreateEvent.create(:github_id => github_id,
                             :title => entry.title,
                            :from_id => self.id,
                            :from_type => self.class,
                            :published_at => entry.published,
                            :who => $1,
                            :tag_name => $2,
                            :repo_name => $3)
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
