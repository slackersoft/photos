# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Photo.create(name: 'Mushroom', image: File.open(File.join(Rails.root, "spec", "fixtures", "files", "mushroom.png")))
Photo.create(name: 'Mohawk', description: 'Two feet tall', image: File.open(File.join(Rails.root, "spec", "fixtures", "files", "mohawk.jpeg")))
Photo.create(name: 'Sleeping', description: 'The baby sleeps', image: File.open(File.join(Rails.root, "spec", "fixtures", "files", "sleeping.jpeg")))
