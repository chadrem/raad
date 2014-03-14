require 'spec_helper'
require 'raad_totem//env'
require 'raad_totem/spoon' if RaadTotem.jruby?

if RaadTotem.jruby?

  describe Spoon do
    it "should work" do
      true.should be_true
    end
  end

end
