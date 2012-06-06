(function (app, $) {
  var fancyBoxIsOpen = false;

  var afterClose = function () {
    if (fancyBoxIsOpen) {
      fancyBoxIsOpen = false;
      Backbone.history.navigate('');
    }
  };

  app.Router = Backbone.Router.extend({
    routes: {
      '': 'root',
      'photos/:photoId': 'photo',
      ':tag': 'tag'
    },

    initialize: function () {
      app.photos.on('destroy', function () {
        $.fancybox.close();
      });
    },

    root: function () {
      fancyBoxIsOpen = false;
      $.fancybox.close();
      app.photoList.clearFilters();
    },

    photo: function (photoId) {
      var model = PhotosApp.photos.get(photoId);
      if (model) {
        var view = new app.views.LargePhoto({model: model});
        $.fancybox(view.render().$el, { afterClose: afterClose });
        fancyBoxIsOpen = true;
      } else {
        Backbone.history.navigate('');
      }
    },

    tag: function (tagName) {
      fancyBoxIsOpen = false;
      $.fancybox.close();
      app.photoList.showTag(tagName);
    }
  });
}(PhotosApp, jQuery));
