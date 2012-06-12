require 'spec_helper'

describe SenderEmail do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:address) }
    it { should allow_value('foo@bar.com').for(:address) }
    it { should_not allow_value('foo@@bar.com').for(:address) }
    it { should validate_uniqueness_of(:address).with_message('has been claimed by another account') }
  end
end
