require 'spec_helper'
require 'raad_totem/env'

describe "RaadTotem env" do
  it "should test for jruby" do
    [true, false].should include(RaadTotem.jruby?)
  end

  it "should report ruby path" do
    File.exist?(RaadTotem.ruby_path).should be_true
  end

  it "should default to empty ruby_options" do
    RaadTotem.ruby_options.should == []
  end

  it "should set ruby_options" do
    RaadTotem.ruby_options = "a b"
    RaadTotem.ruby_options.should == ['a', 'b']
  end
end
