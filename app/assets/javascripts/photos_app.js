window.PhotosApp = {
  views: {},
  models: {},
  collections: {},
  init: function () {
    PhotosApp.photos = new PhotosApp.collections.Photos();
    PhotosApp.photoList = new PhotosApp.views.PhotoList({collection: PhotosApp.photos, el: '.photo_list'});
    PhotosApp.router = new PhotosApp.Router();
    Backbone.history.start();
  }
};
