var oldHistory;
beforeEach(function () {
  oldHistory = Backbone.history;
  Backbone.history = {
    start: jasmine.createSpy('start'),
    route: jasmine.createSpy('route'),
    navigate: jasmine.createSpy('navigate')
  };

  PhotosApp.photos = null;
  PhotosApp.photoList = null;
  PhotosApp.currentUser = new PhotosApp.models.User({authorized: false});
  jasmine.Ajax.useMock();
  clearAjaxRequests();
});


afterEach(function () {
  Backbone.history = oldHistory;
});

jasmine.photoJson = function (id) {
  return {
    id: id,
    name: "Mushroom",
    description: "",
    thumbUrl: "",
    thumbWidth: 100,
    thumbHeight: 100,
    largeUrl: "",
    largeWidth: 200,
    largeHeight: 500,
    rawUrl: "",
    tags: []
  };
};
