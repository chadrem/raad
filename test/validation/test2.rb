$:.unshift File.dirname(__FILE__) + '/../../lib'
require 'rubygems'
require 'raad_totem'

class Test2

  # hanging service

  def start
    puts 'test2 running'
    Thread.stop
  end

  def stop
    puts 'test2 stop called'
  end

end
