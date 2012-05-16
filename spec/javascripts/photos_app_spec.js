describe("PhotosApp", function () {
  describe(".init", function () {
    var photoJson;
    beforeEach(function () {
      photoJson = [
        jasmine.photoJson(1),
        jasmine.photoJson(2),
        jasmine.photoJson(3)
      ];
      jQuery('#jasmine_content').html('<div class="photo_list"></div>');
      spyOn(PhotosApp, 'Router');
      PhotosApp.init(photoJson);
    });

    it("should create a Photos collection", function () {
      expect(PhotosApp.photos).not.toBeNull();
      expect(PhotosApp.photos.size()).toEqual(photoJson.length);
    });

    it("should create a PhotoList view", function () {
      expect(PhotosApp.photoList).not.toBeNull();
      expect(PhotosApp.photoList.el).toEqual(jQuery('#jasmine_content .photo_list')[0]);
    });

    it("should initialize an empty currentUser", function () {
      expect(PhotosApp.currentUser).not.toBeNull();
      expect(PhotosApp.currentUser.get('authorized')).toEqual(false);
    });

    it("should create a Router", function () {
      expect(PhotosApp.Router).toHaveBeenCalled();
    });

    it("should start the backbone history", function () {
      expect(Backbone.history.start).toHaveBeenCalled();
    });

    describe("when passed a user", function () {
      beforeEach(function () {
        PhotosApp.init(photoJson, {email: 'foo@bar.com', authorized: true});
      });

      it("should initialize the correct currentUser", function () {
        expect(PhotosApp.currentUser).not.toBeNull();
        expect(PhotosApp.currentUser.get('authorized')).toEqual(true);
        expect(PhotosApp.currentUser.get('email')).toEqual('foo@bar.com');
      });
    });
  });
});
