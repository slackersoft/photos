(function (app, $) {
  app.views.Photo = Backbone.View.extend({
    template: 'photo',
    className: 'photo',

    events: {
      'click a': 'enlargePhoto'
    },

    render: function () {
      this.$el.html('<a href="' + this.model.get('largeUrl') + '"><img src="' +
        this.model.get('thumbUrl') + '" alt="' + this.model.get('name') +
        '" title="' + this.model.get('name') + '" width="' + this.model.get('thumbWidth') +
        '"></a>');
      return this;
    },

    enlargePhoto: function (e) {
      e.preventDefault();
      $.fancybox($('<div class="large_photo"><img src="' + this.model.get('largeUrl') +
        '" width="' + this.model.get('largeWidth') + '"><div><a href="' +
        this.model.get('rawUrl') + '">Original</a></div></div>'));
    }
  });
}(PhotosApp, jQuery));
