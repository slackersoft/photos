(function (app) {
  app.models.Photo = Backbone.Model.extend({
    url: function (extraPath) {
      var builder = ['/photos/', this.id];
      if (extraPath) {
        builder.push('/');
        builder.push(extraPath);
      }
      return builder.join('');
    },

    addTag: function (tag) {
      jQuery.ajax({
        url: this.url('add_tag'),
        type: 'POST',
        data: { tag: tag }
      }).done(_.bind(this.set, this));
    }
  });
}(PhotosApp));
