(function (app) {
  app.views.Photo = Backbone.View.extend({
    template: app.templates.small_photo,
    className: 'photo',

    render: function () {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    }
  });
}(PhotosApp));
