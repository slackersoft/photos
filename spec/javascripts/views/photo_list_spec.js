describe("views.PhotoList", function () {
  var view, collection;
  beforeEach(function () {
    collection = new PhotosApp.collections.Photos();
    view = new PhotosApp.views.PhotoList({collection: collection});
  });

  describe("#render", function () {
    describe("when there are no photos", function () {
      it("should show a message", function () {
        view.render();
        expect(view.$el.text()).toEqual('No photos have been uploaded yet');
      });
    });

    describe("when there are photos", function () {
      beforeEach(function () {
        collection.reset([jasmine.photoJson(1), jasmine.photoJson(2)], {silent: true});
      });

      it("should render each", function () {
        view.render();
        expect(view.$('.photo').length).toEqual(2);
      });

      describe("when there was content before", function () {
        beforeEach(function () {
          view.$el.append('<div class="photo"></div>');
        });

        it("should render each", function () {
          view.render();
          expect(view.$('.photo').length).toEqual(2);
        });
      });
    });
  });

  describe("when the collection is updated", function () {
    it("should render", function () {
      spyOn(view, 'render');
      collection.reset([jasmine.photoJson(3)]);
      expect(view.$('.photo').length).toEqual(1);
    });
  });

  describe("clicking on a photo", function () {
    var click;
    beforeEach(function () {
      click = jQuery.Event('click');
      collection.reset([jasmine.photoJson(1), jasmine.photoJson(2)], {silent: true});
      view.render();
      view.$('.photo:first a img').trigger(click);
    });

    it("should prevent default", function () {
      expect(click.isDefaultPrevented()).toEqual(true);
    });

    it("should navigate to the url", function () {
      expect(Backbone.history.navigate).toHaveBeenCalledWith(view.$('.photo:first a').attr('href'), { trigger: true });
    });
  });
});
