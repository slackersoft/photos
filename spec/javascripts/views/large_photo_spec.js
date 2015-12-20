describe("views.LargePhoto", function () {
  var view, model;
  beforeEach(function () {
    model = new PhotosApp.models.Photo(jasmine.photoJson(1));
    view = new PhotosApp.views.LargePhoto({model: model});
  });

  it("should have the correct className", function () {
    expect(view.className).toEqual('large_photo');
  });

  describe("#render", function () {
    it("should return itself", function () {
      expect(view.render()).toEqual(view);
    });

    it("should render when the model changes", function () {
      expect(view.$el.html()).toEqual('');
      model.set({foo: 'bar'});
      expect(view.$el.html()).not.toEqual('');
    });
  });

  describe("clicking add tag", function () {
    beforeEach(function () {
      spyOn(window, 'prompt');
      spyOn(model, 'addTag');
    });

    describe("when the user can manage tags", function () {
      beforeEach(function () {
        PhotosApp.currentUser = new PhotosApp.models.User({authorized: true});
        view.render();
      });

      it("should prevent default", function () {
        var click = jQuery.Event('click');
        view.$('.add_tag').trigger(click);
        expect(click.isDefaultPrevented()).toEqual(true);
      });

      it("should prompt the user for a tag", function () {
        view.$('.add_tag').click();
        expect(window.prompt).toHaveBeenCalledWith('What tag do you want to add?');
      });

      describe("when the user enters a tag", function () {
        beforeEach(function () {
          window.prompt.and.returnValue('hi');
        });

        it("should add a tag to the model", function () {
          view.$('.add_tag').click();
          expect(model.addTag).toHaveBeenCalledWith('hi');
        });
      });

      describe("when the user enters a blank tag", function () {
        beforeEach(function () {
          window.prompt.and.returnValue('');
          view.$('.add_tag').click();
        });

        it("should not add a new tag", function () {
          expect(model.addTag).not.toHaveBeenCalled();
        });
      });

      describe("when the user cancels adding a tag", function () {
        beforeEach(function () {
          window.prompt.and.returnValue(null);
          view.$('.add_tag').click();
        });

        it("should not add a new tag", function () {
          expect(model.addTag).not.toHaveBeenCalled();
        });
      });
    });

    describe("when the user can't manage tags", function () {
      beforeEach(function () {
        PhotosApp.currentUser = new PhotosApp.models.User({authorized: false});
        view.render();
      });

      it("should not have a link to click", function () {
        expect(view.$('.add_tag').length).toEqual(0);
      });
    });
  });

  describe("clicking to remove a tag", function () {
    beforeEach(function () {
      model.set({tags: ['foo', 'bar', 'baz']});
      spyOn(model, 'removeTag');
    });

    describe("when the user can manage tags", function () {
      beforeEach(function () {
        PhotosApp.currentUser = new PhotosApp.models.User({authorized: true});
        view.render();
      });

      it("should prevent default", function () {
        var click = jQuery.Event('click');
        view.$('.remove_tag:eq(1)').trigger(click);
        expect(click.isDefaultPrevented()).toEqual(true);
      });


      it("should tell the model to remove the specified tag", function () {
        view.$('.remove_tag:eq(1)').click();
        expect(model.removeTag).toHaveBeenCalledWith('bar');
      });
    });

    describe("when the user can't manage tags", function () {
      beforeEach(function () {
        PhotosApp.currentUser = new PhotosApp.models.User({authorized: false});
        view.render();
      });

      it("should not have a link to click", function () {
        expect(view.$('.remove_tag').length).toEqual(0);
      });
    });
  });

  describe("clicking a tag", function () {
    beforeEach(function () {
      model.set({tags: ['foo', 'bar']});
      view.$('.tags li:last').click();
    });

    it("should navigate to the specified tag", function () {
      expect(Backbone.history.navigate).toHaveBeenCalledWith('/bar', { trigger: true });
    });
  });

  describe("deleting a photo", function () {
    beforeEach(function () {
      spyOn(model, 'destroy');
    });

    describe("when the user can manage photos", function () {
      beforeEach(function () {
        PhotosApp.currentUser = new PhotosApp.models.User({admin: true});
        view.render();
      });

      it("should prevent default", function () {
        var click = jQuery.Event('click');
        view.$('.delete').trigger(click);
        expect(click.isDefaultPrevented()).toEqual(true);
      });


      it("should tell the model to remove the specified tag", function () {
        view.$('.delete').click();
        expect(model.destroy).toHaveBeenCalled();
      });
    });

    describe("when the user can't manage photos", function () {
      beforeEach(function () {
        PhotosApp.currentUser = new PhotosApp.models.User({authorized: true, admin: false});
        view.render();
      });

      it("should not have a link to click", function () {
        expect(view.$(".delete").length).toEqual(0);
      });
    });
  });

  describe("editing a photo", function () {
    describe("when the user can manage photos", function () {
      beforeEach(function () {
        PhotosApp.currentUser = new PhotosApp.models.User({admin: true});
        view.render();
      });

      it("should have a link to edit", function () {
        expect(view.$('.edit').length).toEqual(1);
      });
    });

    describe("when the user can't manage photos", function () {
      beforeEach(function () {
        PhotosApp.currentUser = new PhotosApp.models.User({authorized: true, admin: false});
        view.render();
      });

      it("should not have a link to click", function () {
        expect(view.$(".edit").length).toEqual(0);
      });
    });
  });
});
