(function () {
  Handlebars.registerHelper('ifCanManageTags', function (options) {
    if (PhotosApp.currentUser.canManageTags()) {
      return options.fn(this);
    } else {
      return "";
    }
  });

  Handlebars.registerHelper('ifCanManagePhotos', function (options) {
    if (PhotosApp.currentUser.canManagePhotos()) {
      return options.fn(this);
    } else {
      return "";
    }
  });
}());
