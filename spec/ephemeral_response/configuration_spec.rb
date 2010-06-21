require 'spec_helper'

describe EphemeralResponse::Configuration do
  subject { EphemeralResponse::Configuration }

  describe "#fixture_directory" do
    it "has a default" do
      subject.fixture_directory.should == "spec/fixtures/ephemeral_response"
    end

    it "can be overwritten" do
      subject.fixture_directory = "test/fixtures/ephemeral_response"
      subject.fixture_directory.should == "test/fixtures/ephemeral_response"
    end
  end

  describe "#expiration" do
    it "defaults to 86400" do
      subject.expiration.should == 86400
    end

    it "can be overwritten" do
      subject.expiration = 43200
      subject.expiration.should == 43200
    end

    context "setting a block" do
      it "returns the value of the block" do
        subject.expiration = lambda { one_day * 7 }
        subject.expiration.should == 604800
      end

      it "raises an error when the return value of the block is not a FixNum" do
        expect do
          subject.expiration = lambda { "1 day" }
        end.to raise_exception(TypeError, "expiration must be expressed in seconds")
      end
    end
  end

  describe "#reset" do
    it "resets expiration, fixture directory, and white list to the defaults" do
      subject.fixture_directory = "test/fixtures/ephemeral_response"
      subject.expiration = 1
      subject.white_list = 'localhost'
      subject.fixture_directory.should == "test/fixtures/ephemeral_response"
      subject.expiration.should == 1
      subject.white_list.should == ['localhost']

      subject.reset

      subject.fixture_directory.should == subject.const_get(:DEFAULTS)[:fixture_directory]
      subject.expiration.should == subject.const_get(:DEFAULTS)[:expiration].call
      subject.white_list.should == []
    end
  end

  describe "#white_list" do
    it "defaults to an empty array" do
      subject.white_list.should == []
    end
  end

  describe "#white_list=" do
    it "sets a single host" do
      subject.white_list = 'localhost'
      subject.white_list.should == ['localhost']
    end

    it "sets multiple hosts" do
      subject.white_list = 'localhost', 'smackaho.st'
      subject.white_list.should == ['localhost', 'smackaho.st']
    end
  end
end
