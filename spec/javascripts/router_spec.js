describe("Router", function () {
  var router;
  beforeEach(function () {
    router = new PhotosApp.Router();
    PhotosApp.photos = new PhotosApp.collections.Photos();
    PhotosApp.photoList = new PhotosApp.views.PhotoList({collection: PhotosApp.photos});
  });

  describe("root", function () {
    beforeEach(function () {
      spyOn(jQuery.fancybox, 'close');
    });

    it("should close any open photo box", function () {
      router.root();
      expect(jQuery.fancybox.close).toHaveBeenCalled();
    });

    it("should tell the photo list to clear its filter", function () {
      spyOn(PhotosApp.photoList, 'clearFilters');
      router.root();
      expect(PhotosApp.photoList.clearFilters).toHaveBeenCalled();
    });
  });

  describe("photo show", function () {
    beforeEach(function () {
      spyOn(jQuery, 'fancybox');

      PhotosApp.photos = new PhotosApp.collections.Photos([
        jasmine.photoJson(1)
      ]);
    });

    it("should open the specified photo in a fancybox", function () {
      router.photo(1);
      expect(jQuery.fancybox).toHaveBeenCalled();
    });

    describe("when the fancybox is closed", function () {
      beforeEach(function () {
        router.photo(1);
        jQuery.fancybox.mostRecentCall.args[1].afterClose();
      });

      it("should navigate to root", function () {
        expect(Backbone.history.navigate).toHaveBeenCalledWith('');
      });
    });

    describe("when the photo doesn't exist", function () {
      it("should navigate to root", function () {
        router.photo(42);
        expect(jQuery.fancybox).not.toHaveBeenCalled();
        expect(Backbone.history.navigate).toHaveBeenCalledWith('');
      });
    });
  });

  describe("tag show", function () {
    beforeEach(function () {
      spyOn(jQuery.fancybox, 'close');
    });

    it("should close any open photo box", function () {
      router.tag('foo');
      expect(jQuery.fancybox.close).toHaveBeenCalled();
    });

    it("should tell the photo list to filter by tag", function () {
      spyOn(PhotosApp.photoList, 'showTag');
      router.tag('foo');
      expect(PhotosApp.photoList.showTag).toHaveBeenCalledWith('foo');
    });
  });
});
