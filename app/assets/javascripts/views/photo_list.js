(function (app) {
  app.views.PhotoList = Backbone.View.extend({
    events: {
      'click a': 'usePushStateNav'
    },

    initialize: function () {
      this.collection.on('reset', this.render, this);
    },

    render: function () {
      this.$el.empty();

      if (this.selectedTag) {
        this.$el.append('<div class="tag-info">Viewing photos tagged as "' + this.selectedTag + '". <a href="/" class="all_photos">View All</a></div>');
      }

      if (this.collection.isEmpty()) {
        this.$el.append('<div class="no-photos">No photos have been uploaded yet</div>');
      } else {
        this.collection.each(_.bind(function (photo) {
          if ((this.selectedTag && photo.hasTag(this.selectedTag)) || !this.selectedTag) {
            this.$el.append(new app.views.Photo({model: photo}).render().el);
          }
        }, this));

        if (this.$('.photo').length === 0) {
          this.$el.append('<div class="no-photos">No photos have the tag "' + this.selectedTag + '"</div>');
        }
      }
    },

    usePushStateNav: function (e) {
      e.preventDefault();
      Backbone.history.navigate(this.$(e.currentTarget).attr('href'), { trigger: true });
    },

    showTag: function (tag) {
      this.selectedTag = tag;
      this.render();
    },

    clearFilters: function () {
      this.selectedTag = null;
      this.render();
    }
  });
}(PhotosApp));
