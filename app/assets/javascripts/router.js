(function (app, $) {
  app.Router = Backbone.Router.extend({
    routes: {
      '': 'root',
      'photos/:photoId': 'photo'
    },

    root: function () {
      $.fancybox.close();
    },

    photo: function (photoId) {
      var view = new app.views.LargePhoto({model: PhotosApp.photos.get(photoId)});
      $.fancybox(view.render().$el, {
        afterClose: function () {
          Backbone.history.navigate('');
        }
      });
    }
  });
}(PhotosApp, jQuery));
