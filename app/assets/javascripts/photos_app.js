window.PhotosApp = {
  templates: {},
  views: {},
  models: {},
  collections: {},
  init: function (photos) {
    PhotosApp.photos = new PhotosApp.collections.Photos();
    PhotosApp.photoList = new PhotosApp.views.PhotoList({collection: PhotosApp.photos, el: '.photo_list'});
    PhotosApp.photos.reset(photos);
    PhotosApp.router = new PhotosApp.Router();
    Backbone.history.start({pushState: true});
  }
};
