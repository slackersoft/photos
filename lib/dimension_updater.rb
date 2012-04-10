class DimensionUpdater
  def self.update_dimensions
    photo_count = 0
    Photo.find_each do |photo|
      photo.reset_dimensions!
      log('.')
      photo_count += 1
    end

    log("\nUpdated #{photo_count} photos\n")
  end

  def self.log(message)
    print message
  end
end
