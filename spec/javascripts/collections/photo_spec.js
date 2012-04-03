describe("collections.Photos", function () {
  var collection;
  beforeEach(function () {
    collection = new PhotosApp.collections.Photos();
  });

  it("should have the correct model", function () {
    expect(collection.model).toEqual(PhotosApp.models.Photo);
  });
});
