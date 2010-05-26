class CreateEvent < Event
  field :who, :type => String
  field :tag_name, :type => String
  field :repo_name, :type => String
end
