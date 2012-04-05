describe("Router", function () {
  var router;
  beforeEach(function () {
    router = new PhotosApp.Router();
  });

  describe("root", function () {
    beforeEach(function () {
      spyOn(jQuery.fancybox, 'close');
    });

    it("should close any open photo box", function () {
      router.root();
      expect(jQuery.fancybox.close).toHaveBeenCalled();
    });
  });

  describe("photo show", function () {
    beforeEach(function () {
      spyOn(jQuery, 'fancybox');

      PhotosApp.photos = new PhotosApp.collections.Photos([
        {id: 1}
      ]);
    });

    it("should open the specified photo in a fancybox", function () {
      router.photo(1);
      expect(jQuery.fancybox).toHaveBeenCalled();
    });
  });
});
