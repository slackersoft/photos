describe("views.Photo", function () {
  var view, model;
  beforeEach(function () {
    model = new PhotosApp.models.Photo({thumbUrl: 'foo', largeUrl: 'bar'});
    view = new PhotosApp.views.Photo({model: model});
  });

  it("should have the correct className", function () {
    expect(view.className).toEqual('photo');
  });

  describe("#render", function () {
    it("should return itself", function () {
      expect(view.render()).toEqual(view);
    });
  });

  describe("clicking on the photo", function () {
    beforeEach(function () {
      spyOn(jQuery, 'fancybox');
      view.render();
    });

    it("should open the large image in a fancybox", function () {
      view.$('a').click();
      expect(jQuery.fancybox).toHaveBeenCalled();
    });
  });
});
