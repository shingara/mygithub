class WatchEvent < Event

  field :github_id, :type => String
  field :published_at, :type => DateTime
  field :who, :type => String
  field :what, :type => String
end
