(function (app) {
  app.views.LargePhoto = Backbone.View.extend({
    template: app.templates.large_photo,
    className: 'large_photo',

    events: {
      'click .add_tag': 'addTag',
      'click .remove_tag': 'removeTag'
    },

    initialize: function () {
      this.model.on('change', this.render, this);
    },

    render: function () {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    },

    addTag: function (e) {
      e.preventDefault();
      var newTag = window.prompt('What tag do you want to add?');
      if (newTag && newTag.length > 0) {
        this.model.addTag(newTag);
      }
    },

    removeTag: function (e) {
      e.preventDefault();
      var tagEl = this.$(e.currentTarget).closest('li');
      this.model.removeTag(tagEl.text().replace(/x$/, ''));
    }
  });
}(PhotosApp));
