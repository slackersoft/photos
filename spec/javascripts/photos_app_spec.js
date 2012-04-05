describe("PhotosApp", function () {
  describe(".init", function () {
    var photoJson;
    beforeEach(function () {
      photoJson = [
        {"id": 1, "name": "Mushroom", "thumbUrl": "", "thumbWidth": 100, "largeUrl": "", "largeWidth": 200, "rawUrl": ""},
        {"id": 2, "name": "Mohawk", "thumbUrl": "", "thumbWidth": 75, "largeUrl": "", "largeWidth": 375, "rawUrl": ""},
        {"id": 3, "name": "Sleeping", "thumbUrl": "", "thumbWidth": 100, "largeUrl": "", "largeWidth": 500, "rawUrl": ""}
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

    it("should create a Router", function () {
      expect(PhotosApp.Router).toHaveBeenCalled();
    });

    it("should start the backbone history", function () {
      expect(Backbone.history.start).toHaveBeenCalled();
    });
  });
});
