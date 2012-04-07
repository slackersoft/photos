FixtureBuilder.configure do |fbuilder|
  # rebuild fixtures automatically when these files change:
  fbuilder.files_to_check += Dir["spec/factories/*.rb", "spec/support/fixture_builder.rb"]

  include FactoryGirl::Syntax::Methods

  # now declare objects
  fbuilder.factory do
    mohawk = create(:photo)
    mushroom = create(:photo, name: 'mushroom', image: File.new(Rails.root.join('spec', 'fixtures', 'files', 'mushroom.png')))
  end

  FactoryGirl.sequences.each do |seq|
    seq.instance_variable_set(:@value, 1000)
  end
end
