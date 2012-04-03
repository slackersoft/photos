describe("Router", function () {
  var router;
  beforeEach(function () {
    router = new PhotosApp.Router();
    PhotosApp.photos = new PhotosApp.collections.Photos();
    spyOn(PhotosApp.photos, 'fetch');
  });

  describe("root", function () {
    it("should set the root url correctly and call fetch", function () {
      router.root();
      expect(PhotosApp.photos.url).toEqual('/photos');
      expect(PhotosApp.photos.fetch).toHaveBeenCalled();
    });
  });
});
