(function (app) {
  app.views.PhotoList = Backbone.View.extend({
    events: {
      'click .photo a': 'openPhoto'
    },

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
    },

    openPhoto: function (e) {
      e.preventDefault();
      Backbone.history.navigate(this.$(e.currentTarget).attr('href'), { trigger: true });
    }
  });
}(PhotosApp));
