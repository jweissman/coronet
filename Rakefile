#!/usr/bin/env rake
require "bundler/gem_tasks"
task :default => [:spec]

desc "Run focused behavior examples"
task :spec do
  exec "bundle exec rspec -cf doc --pattern spec/**/*.spec,spec/coronet/**/*.spec"
end