(function (app) {
  app.models.User = Backbone.Model.extend({
    canManageTags: function () {
      return this.get('authorized') === true;
    },

    canManagePhotos: function () {
      return this.get('admin') === true;
    }
  });
}(PhotosApp));
