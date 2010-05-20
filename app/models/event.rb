class Event
  include Mongoid::Document
  belongs_to_related :from, :polymorphic => true
end
