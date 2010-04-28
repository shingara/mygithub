class User
  include Mongoid::Document



  field :login, :type => String
  field :email, :type => String
  field :github_login, :type => String

end
