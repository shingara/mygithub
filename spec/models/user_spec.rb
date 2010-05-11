require 'spec_helper'

describe User do
  it { User.fields.keys.should be_include('github_login')}
  it { User.fields['github_login'].type.should == String}

  it { User.fields.keys.should be_include('following')}
  it { User.fields['following'].type.should == Array}

  it { User.fields.keys.should be_include('repo_watched')}
  it { User.fields['repo_watched'].type.should == Array}

  it { User.fields.keys.should be_include('atom_feeds')}
  it { User.fields['atom_feeds'].type.should == Array}

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
      expect do
        user = Factory(:user, :github_login => 'shingara')
        user.following.should == ['antires', 'dhh']
        user.coders.map(&:login).sort.should == ['antires', 'dhh']
      end.to change(Coder, :count).by(2)
    end

    it "should fetch all repo_watched's user" do
      repos = [{"description"=>"Merb Core: All you need. None you don't.", "has_downloads"=>true, "has_issues"=>true, "homepage"=>"http://www.merbivore.com", "forks"=>50, "watchers"=>538, "fork"=>false, "has_wiki"=>true, "url"=>"http://github.com/wycats/merb-core", "private"=>false, "name"=>"merb-core", "owner"=>"wycats", "open_issues"=>0},
                                                                      {"description"=>"Merb More: The Full Stack. Take what you need; leave what you don't.", "has_downloads"=>true, "has_issues"=>true, "homepage"=>"http://www.merbivore.com", "forks"=>30, "watchers"=>279, "fork"=>false, "has_wiki"=>true, "url"=>"http://github.com/wycats/merb-more", "private"=>false, "name"=>"merb-more", "owner"=>"wycats", "open_issues"=>0}]
      Octopussy.should_receive(:watched).with('shingara2').and_return(repos)
      expect do
        user = Factory(:user, :github_login => 'shingara2')
        user.repo_watched.should == repos
        user.repositories.map(&:url).should == ['http://github.com/wycats/merb-core', 'http://github.com/wycats/merb-more']
      end.to change(Repository, :count)
    end
  end

  describe '#before_save' do
    it 'should update all atom_feeds with all user followers and repo_watched' do
      Octopussy.should_receive(:following).with('shingara3').and_return(['antires', 'dhh'])
      Octopussy.should_receive(:watched).with('shingara3').and_return([{'url' => 'http://github.com/durran/mongoid'}, {'url' => 'http://github.com/rails/rails'}])
      user = Factory(:user, :github_login => 'shingara3')
      user.atom_feeds.should == ['http://github.com/antires.atom', 'http://github.com/dhh.atom', 'http://github.com/durran/mongoid/commits/master.atom', 'http://github.com/rails/rails/commits/master.atom']
    end
  end

  describe '#after_save' do
    include WebMock

    it 'should post subscribe to pushme about all coders watch by user' do
      Octopussy.should_receive(:following).with('shingara').and_return(['antires', 'dhh'])
      Octopussy.should_receive(:watched).with('shingara').and_return([])
      user = Factory(:user, :github_login => 'shingara')
      WebMock.should have_requested(:post, 'http://localhost:3001').with(:push => {:feed_url => 'http://github.com/antires.atom', :feed_type => 'atom', :pusher => {:push_type => 'post_http', :options => {:url => 'http://'}}})
      WebMock.should have_requested(:post, 'http://localhost:3001').with(:push => {:feed_url => 'http://github.com/dhh.atom', :feed_type => 'atom', :pusher => {:push_type => 'post_http', :options => {:url => 'http://'}}})
    end
    it 'should post subscribe to pushme about all repositories watch by user'
  end

end
