var oldHistory;
beforeEach(function () {
  oldHistory = Backbone.history;
  Backbone.history = {
    start: jasmine.createSpy('start'),
    route: jasmine.createSpy('route')
  };

  PhotosApp.photos = null;
  PhotosApp.photoList = null;
});


afterEach(function () {
  Backbone.history = oldHistory;
});
