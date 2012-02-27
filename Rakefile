#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Photos::Application.load_tasks

task :cruise do
  sh 'rake spec'
  Headless.ly(:display => 42) do |headless|
    begin
      sh 'rake jasmine:ci'
      sh 'rake spec:selenium'
      
    ensure
      headless.destroy
    end
  end
end

task :default => [:spec, 'jasmine:ci']
