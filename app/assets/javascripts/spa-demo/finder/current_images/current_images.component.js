(function() {
  'use strict';

  angular
    .module('spa-demo.finder')
    .component('sdFinderCurrentImages', {
      templateUrl: imagesTemplateUrl,
      controller: CurrentImagesController,
    })
    .component('sdFinderCurrentImageViewer', {
      templateUrl: imageViewerTemplateUrl,
      controller: CurrentImageViewerController,
      bindings: {
        name: '@',
        minWidth: '@'
      }
    })
    ;

  imagesTemplateUrl.$inject = ['spa-demo.config.APP_CONFIG'];

  function imagesTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.finder_current_images_html;
  }
  imageViewerTemplateUrl.$inject = ['spa-demo.config.APP_CONFIG'];

  function imageViewerTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.finder_current_image_viewer_html;
  }

  CurrentImagesController.$inject = [
    '$scope',
    'spa-demo.finder.currentSubjects'
  ];

  function CurrentImagesController($scope, currentSubjects) {
    var vm=this;
    vm.imageClicked = imageClicked;
    vm.isCurrentImage = currentSubjects.isCurrentImageIndex;

    vm.$onInit = function() {
      console.log('CurrentImagesController',$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentSubjects.getImages(); },
        function(images) { vm.images = images; }
      );
    }
    return;
    //////////////
    function imageClicked(index) {
      currentSubjects.setCurrentImage(index);
    }
  }

  CurrentImageViewerController.$inject = ['$scope',
                                          'spa-demo.finder.currentSubjects'];
  function CurrentImageViewerController($scope, currentSubjects) {
    var vm=this;
    vm.viewerIndexChanged = viewerIndexChanged;

    vm.$onInit = function() {
      console.log('CurrentImageViewerController',$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentSubjects.getImages(); },
        function(images) { vm.images = images; }
      );
      $scope.$watch(
        function() { return currentSubjects.getCurrentImageIndex(); },
        function(index) { vm.currentImageIndex = index; }
      );
    }
    return;
    //////////////
    function viewerIndexChanged(index) {
      console.log('viewer index changed, setting currentImage', index);
      currentSubjects.setCurrentImage(index);
    }
  }

})();
