require 'spec_helper'

describe User do
  it { User.fields.keys.should be_include('github_login')}
  it { User.fields['github_login'].type.should == String}

  it { User.fields.keys.should be_include('following')}
  it { User.fields['following'].type.should == Array}

  it { User.fields.keys.should be_include('repo_watched')}
  it { User.fields['repo_watched'].type.should == Array}

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

    it 'should not valid if login already use' do
      Factory.create(:user, :login => 'hello')
      Factory.build(:user, :login => 'hello').should_not be_valid
    end

    it 'should not valid if github_login already use' do
      Factory.create(:user, :github_login => 'hello_github')
      Factory.build(:user, :github_login => 'hello_github').should_not be_valid
    end
  end

  describe '#before_create' do
    it "should fetch all following's user" do
      Octopussy.should_receive(:following).with('shingara').and_return(['antires', 'dhh'])
      user = Factory(:user, :github_login => 'shingara')
      user.following.should == ['antires', 'dhh']
    end

    it "should fetch all repo_watched's user" do
      Octopussy.should_receive(:watched).with('shingara2').and_return(['http://github.com/durran/mongoid', 'http://github.com/rails/rails'])
      user = Factory(:user, :github_login => 'shingara2')
      user.repo_watched.should == ['http://github.com/durran/mongoid', 'http://github.com/rails/rails']
    end
  end

end
