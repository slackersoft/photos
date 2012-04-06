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
      var model = PhotosApp.photos.get(photoId);
      if (model) {
        var view = new app.views.LargePhoto({model: model});
        $.fancybox(view.render().$el, {
          afterClose: function () {
            Backbone.history.navigate('');
          }
        });
      } else {
        Backbone.history.navigate('');
      }
    }
  });
}(PhotosApp, jQuery));
