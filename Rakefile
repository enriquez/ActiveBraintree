require 'rake'
require 'bundler'
require 'rspec'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc 'Run Specs'
RSpec::Core::RakeTask.new do |t|
  t.spec_opts = ['-cfd']
end

task :default => [:spec]

