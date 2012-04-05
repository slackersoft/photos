(function (app) {
  app.views.LargePhoto = Backbone.View.extend({
    template: 'large_photo',
    className: 'large_photo',

    render: function () {
      this.$el.html('<img src="' + this.model.get('largeUrl') +
        '" width="' + this.model.get('largeWidth') + '"><div><a href="' +
        this.model.get('rawUrl') + '">Original</a></div>');
      return this;
    }
  });
}(PhotosApp));
