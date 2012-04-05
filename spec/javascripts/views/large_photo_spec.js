describe("views.LargePhoto", function () {
  var view, model;
  beforeEach(function () {
    model = new PhotosApp.models.Photo({thumbUrl: 'foo', largeUrl: 'bar'});
    view = new PhotosApp.views.LargePhoto({model: model});
  });

  it("should have the correct className", function () {
    expect(view.className).toEqual('large_photo');
  });

  describe("#render", function () {
    it("should return itself", function () {
      expect(view.render()).toEqual(view);
    });
  });
});
