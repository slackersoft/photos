describe("models.Photo", function () {
  var model;
  beforeEach(function () {
    model = new PhotosApp.models.Photo(jasmine.photoJson(13));
  });

  describe("#url", function () {
    describe("without a parameter", function () {
      it("should be correct", function () {
        expect(model.url()).toEqual('/photos/13');
      });
    });

    describe("with a paramter", function () {
      it("should append the path to the root url", function () {
        expect(model.url('foo')).toEqual('/photos/13/foo');
      });
    });
  });

  describe("#addTag", function () {
    it("should call the server to add the tag", function () {
      model.addTag('hi');
      expect(mostRecentAjaxRequest()).not.toBeNull();
      expect(mostRecentAjaxRequest().url).toEqual('/photos/13/add_tag');
      expect(mostRecentAjaxRequest().method).toEqual('POST');
      expect(mostRecentAjaxRequest().params).toMatch(/(^|[?&])tag=hi(&|$)/);
    });

    describe("when the server responds", function () {
      describe("successfully", function () {
        beforeEach(function () {
          model.addTag('hi');
          mostRecentAjaxRequest().response({
            status: 200,
            responseText: JSON.stringify({tags: ['hello', 'goodbye']})
          });
        });

        it("should set itself with the new tags", function () {
          expect(model.get('tags')).toEqual(['hello', 'goodbye']);
        });
      });
    });
  });

  describe("#removeTag", function () {
    beforeEach(function () {
      model.set({tags: ['foo', 'bar']});
    });

    describe("when the model has the specified tag", function () {
      beforeEach(function () {
        model.removeTag('foo');
      });

      it("should call the server to remove the tag", function () {
        expect(mostRecentAjaxRequest()).not.toBeNull();
        expect(mostRecentAjaxRequest().url).toEqual('/photos/13/remove_tag');
        expect(mostRecentAjaxRequest().method).toEqual('POST');
        expect(mostRecentAjaxRequest().params).toMatch(/(^|[?&])tag=foo(&|$)/);
      });

      describe("when the server responds", function () {
        describe("successfully", function () {
          beforeEach(function () {
            mostRecentAjaxRequest().response({
              status: 200,
              responseText: JSON.stringify({tags: ['bar', 'baz']})
            });
          });

          it("should set itself with the updated tags", function () {
            expect(model.get('tags')).toEqual(['bar', 'baz']);
          });
        });
      });
    });
  });

  describe("#hasTag", function () {
    beforeEach(function () {
      model.set({tags: ['foo', 'bar']});
    });

    describe("when the model has the tag", function () {
      it("should return true", function () {
        expect(model.hasTag('foo')).toEqual(true);
      });
    });

    describe("when the model does not have the tag", function () {
      it("should return false", function () {
        expect(model.hasTag('baz')).toEqual(false);
      });
    });
  });
});
