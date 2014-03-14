require 'rake'
require 'rubygems'

task :default => :test

begin
  require 'rspec/core/rake_task'
  desc 'run specs in the current ruby env'
  task :spec do
    sh 'ruby -v'
    RSpec::Core::RakeTask.new
  end
rescue NameError, LoadError => e
  puts e
end

desc 'run validations in the current ruby env'
task :validation  do
  exec 'test/validate.sh'
end

desc 'perform specs and validation'
task :test => [:spec] do
  exec 'test/validate.sh'
end
