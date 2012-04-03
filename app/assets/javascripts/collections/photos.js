(function (app) {
  app.collections.Photos = Backbone.Collection.extend({
    model: app.models.Photo
  });
}(PhotosApp));
