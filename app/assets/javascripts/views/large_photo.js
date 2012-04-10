(function (app) {
  app.views.LargePhoto = Backbone.View.extend({
    template: app.templates.large_photo,
    className: 'large_photo',

    render: function () {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    }
  });
}(PhotosApp));
