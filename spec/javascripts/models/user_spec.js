describe("models.User", function () {
  var user;
  beforeEach(function () {
    user = new PhotosApp.models.User();
  });

  describe("#canManageTags", function () {
    describe("when the user is 'authorized'", function () {
      beforeEach(function () {
        user.set({authorized: true});
      });

      it("should return true", function () {
        expect(user.canManageTags()).toEqual(true);
      });
    });

    describe("when the user is not authorized", function () {
      it("should return false", function () {
        expect(user.canManageTags()).toEqual(false);
      });
    });
  });

  describe("#canManagePhotos", function () {
    describe("when the user is an admin", function () {
      beforeEach(function () {
        user.set({admin: true});
      });

      it("should return true", function () {
        expect(user.canManagePhotos()).toEqual(true);
      });
    });

    describe("when the user is not an admin", function () {
      beforeEach(function () {
        user.set({authorized: true});
      });

      it("should return false", function () {
        expect(user.canManagePhotos()).toEqual(false);
      });
    });
  });
});
