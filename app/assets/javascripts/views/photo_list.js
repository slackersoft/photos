(function (app) {
  app.views.PhotoList = Backbone.View.extend({
    initialize: function () {
      this.collection.on('reset', this.render, this);
    },

    render: function () {
      var self = this;
      this.$el.empty();

      if (this.collection.isEmpty()) {
        this.$el.html('<div class="no-photos">No photos have been uploaded yet</div>');
      } else {
        this.collection.each(function (photo) {
          self.$el.append(new app.views.Photo({model: photo}).render().el);
        });
      }
    }
  });
}(PhotosApp));
