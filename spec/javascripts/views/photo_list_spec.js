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

      it("should not show a link to all photos", function () {
        view.render();
        expect(view.$('.all_photos').length).toEqual(0);
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

  describe("#showTag", function () {
    beforeEach(function () {
      collection.reset([jasmine.photoJson(1), jasmine.photoJson(2)]);
      collection.at(0).set({tags: ['foo', 'bar']});
      view.showTag('Foo');
    });

    it("should only render photos that are associated with the specified tag", function () {
      expect(view.$('.photo').length).toEqual(1);
      expect(view.$('.photo a').attr('href')).toEqual('/photos/1');
    });

    it("should show a link to all photos", function () {
      view.render();
      expect(view.$('.all_photos').length).toEqual(1);
    });

    describe("when the view renders again", function () {
      beforeEach(function () {
        view.render();
      });

      it("should only render photos that are associated with the specified tag", function () {
        expect(view.$('.photo').length).toEqual(1);
        expect(view.$('.photo a').attr('href')).toEqual('/photos/1');
      });
    });

    describe("when no photos have the tag", function () {
      it("should show a message", function () {
        view.showTag('baz');
        expect(view.$('.photo').length).toEqual(0);
        expect(view.$el.text()).toMatch(/No photos have the tag "baz"/);
      });
    });

    describe("clicking the all photos link", function () {
      var click;
      beforeEach(function () {
        click = jQuery.Event('click');
        view.$('.all_photos').trigger(click);
      });

      it("should prevent default", function () {
        expect(click.isDefaultPrevented()).toEqual(true);
      });

      it("should navigate to the url", function () {
        expect(Backbone.history.navigate).toHaveBeenCalledWith('/', { trigger: true });
      });
    });
  });

  describe("#clearFilter", function () {
    beforeEach(function () {
      collection.reset([jasmine.photoJson(1), jasmine.photoJson(2)]);
      collection.at(0).set({tags: ['foo', 'bar']});
      view.showTag('foo');
    });

    it("should render all photos", function () {
      view.clearFilters();
      expect(view.$('.photo').length).toEqual(2);
    });

    it("should not show a link to all photos", function () {
      view.clearFilters();
      expect(view.$('.all_photos').length).toEqual(0);
    });

    describe("when there was already no filter", function () {
      beforeEach(function () {
        view.clearFilters();
      });

      it("should be idempotent", function () {
        view.clearFilters();
        expect(view.$('.photo').length).toEqual(2);
        expect(view.$('.all_photos').length).toEqual(0);
      });
    });
  });
});
