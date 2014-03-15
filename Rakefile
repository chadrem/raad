require 'bundler/gem_tasks'

task :default => :spec

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
