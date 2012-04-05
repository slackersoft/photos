(function (app, $) {
  app.views.Photo = Backbone.View.extend({
    template: 'photo',
    className: 'photo',

    render: function () {
      this.$el.html('<a href="/photos/' + this.model.id + '"><img src="' +
        this.model.get('thumbUrl') + '" alt="' + this.model.get('name') +
        '" title="' + this.model.get('name') + '" width="' + this.model.get('thumbWidth') +
        '"></a>');
      return this;
    }
  });
}(PhotosApp));
