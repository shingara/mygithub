require 'spec_helper'

describe Coder do
  describe 'validation' do
    it 'should have a valid Factory girl' do
      Factory.build(:coder).should be_valid
    end

    it "should not valid with twice same login" do
      coder = Factory(:coder)
      Factory.build(:coder, :login => coder.login).should_not be_valid
    end
  end
end
