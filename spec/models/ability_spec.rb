require 'spec_helper'

describe Ability do
  describe 'about User' do
    [:create, :read].each do |action|
      context "##{action}" do
        it 'should access to every one' do
          ability = Ability.new(nil)
          ability.should be_can(action, User.new)
        end
      end
    end

    [:update, :destroy].each do |action|
      context "##{action}" do
        it "should not access if it's not your user" do
          ability = Ability.new(nil)
          ability.should_not be_can(action, Factory(:user))
        end
        it "should access if it's own user" do
          user = Factory(:user)
          ability = Ability.new(user)
          ability.should be_can(action, user)
        end
      end
    end
  end
end
