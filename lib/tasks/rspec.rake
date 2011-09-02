require 'rake'

class Rake::Task
  def overwrite(&block)
    @actions.clear
    prerequisites.clear
    enhance(&block)
  end
  def abandon
    prerequisites.clear
    @actions.clear
  end
end

Rake::Task[:spec].abandon

#[:requests, :models, :controllers, :views, :helpers, :mailers, :lib, :routing].each do |sub|
desc "Run all specs in spec/"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "./spec/{requests,models,controllers,views,helpers,mailers,lib,routing}/**/*_spec.rb"
end
