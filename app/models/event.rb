class Event
  include Mongoid::Document
  field :from_type, :type => String
  field :from_id, :type => BSON::ObjectID
end
