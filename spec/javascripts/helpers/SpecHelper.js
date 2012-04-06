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
});


afterEach(function () {
  Backbone.history = oldHistory;
});
