describe("views.Photo", function () {
  var view, model;
  beforeEach(function () {
    model = new PhotosApp.models.Photo(jasmine.photoJson(1));
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
});
