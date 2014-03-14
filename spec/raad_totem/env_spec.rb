require 'spec_helper'
require 'raad_totem/env'

describe "RaadTotem env" do

  it "should set default env to :development" do
    RaadTotem.env.should == :development
    RaadTotem.development?.should be_true
  end

  it "should set development env" do
    [:development, :dev, "development", "dev"].each do |env|
      RaadTotem.env = env
      RaadTotem.env.should == :development
      RaadTotem.development?.should be_true
      [:production?, :stage?, :test?].each{|env| RaadTotem.send(env).should be_false}
    end
  end

  it "should set production env" do
    [:production, :prod, "production", "prod"].each do |env|
      RaadTotem.env = env
      RaadTotem.env.should == :production
      RaadTotem.production?.should be_true
      [:development?, :stage?, :test?].each{|env| RaadTotem.send(env).should be_false}
    end
  end

  it "should set stage env" do
    [:stage, :staging, "stage", "staging"].each do |env|
      RaadTotem.env = env
      RaadTotem.env.should == :stage
      RaadTotem.stage?.should be_true
      [:development?, :production?, :test?].each{|env| RaadTotem.send(env).should be_false}
    end
  end

  it "should set test env" do
    [:test, "test"].each do |env|
      RaadTotem.env = env
      RaadTotem.env.should == :test
      RaadTotem.test?.should be_true
      [:development?, :production?, :stage?].each{|env| RaadTotem.send(env).should be_false}
    end
  end

  it "should set arbritary env" do
    [:arbritary, "arbritary"].each do |env|
      RaadTotem.env = env
      RaadTotem.env.should == :arbritary
      [:development?, :production?, :stage?, :test?].each{|env| RaadTotem.send(env).should be_false}
    end
  end

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
