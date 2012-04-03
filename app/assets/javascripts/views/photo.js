(function (app) {
  app.views.Photo = Backbone.View.extend({
    template: 'photo',
    className: 'photo',

    render: function () {
      this.$el.html('<a href="' + this.model.get('largeUrl') +
        '" rel="photo" data-behavior="fancybox"><img src="' +
        this.model.get('thumbUrl') + '" alt="' + this.model.get('name') +
        '" title="' + this.model.get('name') + '"></a>');
      return this;
    }
  });
}(PhotosApp));
