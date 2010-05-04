require 'spec_helper'

describe User do
  it { User.fields.keys.should be_include('github_login')}
  it { User.fields['github_login'].type.should == String}
  it { User.fields.keys.should be_include('login')}
  it { User.fields['login'].type.should == String}
  it 'should validate factory_girl' do
    Factory.build(:user).should be_valid
  end
end
