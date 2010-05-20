# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails)
require 'rspec/rails'
require 'webmock/adapters/rspec/request_pattern_matcher'
require 'webmock/adapters/rspec/webmock_matcher'
require 'webmock/adapters/rspec/matchers'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.include WebMock::Matchers

  # If you'd prefer not to run each of your examples within a transaction,
  # uncomment the following line.
  # config.use_transactional_examples = false
  config.before(:each) do
    Octopussy.stub!(:user).and_return({:name => 'ok'})
    Octopussy.stub!(:following).and_return(['foo', 'bar'])
    Octopussy.stub!(:watched).and_return(['foo', 'bar'])
    WebMock.reset_webmock
    WebMock.stub_request(:post, 'localhost:3001')
  end
  config.before(:all) do
    Mongoid.master.collections.each(&:drop)
  end
end

require 'factories'
#require 'webmock/rspec'

module WebMock
  def assertion_failure(message)
    raise Spec::Expectations::ExpectationNotMetError.new(message)
  end
end

