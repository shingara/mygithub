require 'spec_helper'

describe User do
  it { User.fields.keys.should be_include('github_login')}
  it { User.fields['github_login'].type.should == String}
  it { User.fields.keys.should be_include('login')}
  it { User.fields['login'].type.should == String}
  it 'should validate factory_girl' do
    Factory.build(:user).should be_valid
  end

  describe 'validation' do
    it 'should required login' do
      Factory.build(:user, :login => '').should_not be_valid
    end

    it 'should required github_login' do
      Factory.build(:user, :github_login => '', :login => 'hello').should_not be_valid
    end
    it 'should required email' do
      Factory.build(:user, :email => '').should_not be_valid
    end

    it 'should require valid github login' do
      Octopussy.should_receive(:user).with('hello').and_raise(Crack::ParseError)
      Factory.build(:user, :github_login => 'hello').should_not be_valid
    end
  end

end
