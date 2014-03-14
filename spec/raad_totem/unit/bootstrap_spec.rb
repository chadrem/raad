require 'spec_helper'

# @TODO workaround to bug with Kernel.caller between 1.8 and 1.9 need to dig in this.
$RAAD_TOTEM_NOT_RUN=true
require 'raad_totem/bootstrap'

describe RaadTotem::Bootstrap do
  it "should work" do
    true.should be_true
  end
end
