require 'rake'
require 'rspec'
require 'rspec/core/rake_task'

desc 'Run Specs'
RSpec::Core::RakeTask.new do |t|
  t.spec_opts = ['-cfd']
end

task :default => [:spec]

