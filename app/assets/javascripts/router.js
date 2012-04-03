(function (app) {
  app.Router = Backbone.Router.extend({
    routes: {
      '': 'root'
    },

    root: function () {
      app.photos.url = '/photos';
      app.photos.fetch();
    }
  });
}(PhotosApp));
