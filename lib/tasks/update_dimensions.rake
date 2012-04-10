desc "Update dimensions from disk for all photos"
task :update_dimensions => :environment do
  DimensionUpdater.update_dimensions
end
