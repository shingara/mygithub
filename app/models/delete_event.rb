class DeleteEvent < Event
  field :who, :type => String
  field :branch, :type => String
  field :repo_name, :type => String
end
