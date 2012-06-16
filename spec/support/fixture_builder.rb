FixtureBuilder.configure do |fbuilder|
  # rebuild fixtures automatically when these files change:
  fbuilder.files_to_check += Dir["spec/factories/*.rb", "spec/support/fixture_builder.rb"]

  include FactoryGirl::Syntax::Methods

  # now declare objects
  fbuilder.factory do
    ::FACTORY_BASE_NUMBER = 0
    FileUtils.rm_rf Rails.root.join('public', 'system', 'test').to_s
    Rails.env = 'test'
    mohawk = create(:photo)
    @tag = create(:tag, name: 'mario')
    mushroom = create(:photo, name: 'mushroom', image: File.new(Rails.root.join('spec', 'fixtures', 'files', 'mushroom.png')), tags: [@tag])

    @unauthorized = create(:user, email: 'unauthorized@example.com')
    @unauthorized.sender_emails.create(address: 'still@unauthorized.com')
    @authorized = create(:authorized, email: 'authorized@example.com')
    @admin = create(:admin, email: 'admin@example.com')
  end
end
