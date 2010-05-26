class CommitEvent < Event
  field :commit_id, :type => String
  field :published_at, :type => DateTime
  field :message, :type => String
  field :content, :type => String
end
