describe("Router", function () {
  var router;
  beforeEach(function () {
    PhotosApp.photos = new PhotosApp.collections.Photos();
    PhotosApp.photoList = new PhotosApp.views.PhotoList({collection: PhotosApp.photos});
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

    it("should tell the photo list to clear its filter", function () {
      spyOn(PhotosApp.photoList, 'clearFilters');
      router.root();
      expect(PhotosApp.photoList.clearFilters).toHaveBeenCalled();
    });
  });

  describe("photo show", function () {
    beforeEach(function () {
      spyOn(jQuery, 'fancybox');

      PhotosApp.photos.reset([
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
      });

      it("should navigate to root", function () {
        jQuery.fancybox.calls.mostRecent().args[1].afterClose();
        expect(Backbone.history.navigate).toHaveBeenCalledWith('');
      });

      describe("when the photoList was filtered", function () {
        beforeEach(function () {
          PhotosApp.photoList.selectedTag = 'foo';
        });

        it("should navigate to the tag", function () {
          jQuery.fancybox.calls.mostRecent().args[1].afterClose();
          expect(Backbone.history.navigate).toHaveBeenCalledWith('foo');
        });
      });

      describe("when the router is closing the fancybox by viewing tags", function () {
        beforeEach(function () {
          jQuery.fancybox.close = jasmine.createSpy('close');
          router.tag('foo');
        });

        it("should not navigate to root", function () {
          jQuery.fancybox.calls.mostRecent().args[1].afterClose();
          expect(Backbone.history.navigate).not.toHaveBeenCalled();
        });
      });
    });

    describe("when the photo is destroyed", function () {
      beforeEach(function () {
        jQuery.fancybox.close = jasmine.createSpy('close');
        PhotosApp.photos.trigger('destroy');
      });

      it("should close the fancy box", function () {
        expect(jQuery.fancybox.close).toHaveBeenCalled();
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
