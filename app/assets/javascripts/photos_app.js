window.PhotosApp = {
  templates: {},
  views: {},
  models: {},
  collections: {},
  init: function (photos, userConfig) {
    userConfig = userConfig || {authorized: false};
    PhotosApp.currentUser = new PhotosApp.models.User(userConfig);
    PhotosApp.photos = new PhotosApp.collections.Photos();
    PhotosApp.photoList = new PhotosApp.views.PhotoList({collection: PhotosApp.photos, el: '.photo_list'});
    PhotosApp.router = new PhotosApp.Router();
    Backbone.history.start({pushState: true});
    PhotosApp.photos.reset(photos);
  }
};
