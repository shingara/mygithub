require 'spec_helper'

describe Repository do
  it 'should have a valid factory' do
    Factory.build(:repository).should be_valid
  end

  describe '#validation' do
    it 'should not valid if no owner' do
      Factory.build(:repository, :owner => '').should_not be_valid
    end
    it 'should not valid if no name' do
      Factory.build(:repository, :name => '').should_not be_valid
    end
  end
end
