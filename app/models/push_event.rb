class PushEvent < Event

  field :github_id, :type => String
  field :published_at, :type => DateTime
  field :title, :type => String
  field :commits, :type => Array

end
