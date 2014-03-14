$:.unshift File.dirname(__FILE__) + '/../../lib'
require 'rubygems'
require 'raad_totem'

class Test1

  # typical, well behaved stoppable service

  def start
    @stopped = false
    sleep(3)
    puts 'test1 running'
    sleep(0.1) while !@stopped
  end

  def stop
    puts 'test1 stop called'
    @stopped = true
  end

end
