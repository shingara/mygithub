class IssueEvent < Event
  field :who, :type => String
  field :action, :type => String
  field :num_issue, :type => Integer
  field :repo_name, :type => String
end
