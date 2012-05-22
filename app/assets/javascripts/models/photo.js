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
    },

    removeTag: function (tag) {
      jQuery.ajax({
        url: this.url('remove_tag'),
        type: 'POST',
        data: { tag: tag }
      }).done(_.bind(this.set, this));
    },

    hasTag: function (tag) {
      return _(this.get('tags')).contains(tag);
    }
  });
}(PhotosApp));
