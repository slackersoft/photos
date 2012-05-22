(function (app, $) {
  app.Router = Backbone.Router.extend({
    routes: {
      '': 'root',
      'photos/:photoId': 'photo',
      ':tag': 'tag'
    },

    root: function () {
      $.fancybox.close();
      app.photoList.clearFilters();
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
    },

    tag: function (tagName) {
      $.fancybox.close();
      app.photoList.showTag(tagName);
    }
  });
}(PhotosApp, jQuery));
