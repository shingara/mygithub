class Ability
  include CanCan::Ability

  def initialize(user)
    can [:update, :destroy], User do |user_access|
      user && user_access.id == user.id
    end
    can [:read, :create], User
  end

end
