(function() {
  'use strict';

  angular
    .module('spa-demo.finder')
    .component('sdFinderSearchBox', {
      templateUrl: templateUrl,
      controller: FinderSearchBoxController,
      //bindings: {},
    });

  templateUrl.$inject = ['spa-demo.config.APP_CONFIG'];

  function templateUrl(APP_CONFIG) {
    return APP_CONFIG.finder_search_box_html;
  }

  FinderSearchBoxController.$inject = [
    '$scope',
    'spa-demo.finder.currentTag'
  ];

  function FinderSearchBoxController($scope, currentTag) {
    var vm = this;
    vm.lookupThings = lookupThings;
    vm.getCurrentTag = getCurrentTag;
    vm.clear = clear;

    vm.$onInit = function() {
      //console.log('CurrentOriginSelectorController',$scope);
    }
    return;
    //////////////
    function getCurrentTag() {
      return currentTag.getTag();
    }

    function clear() {
      vm.tag = '';
      $scope.select_tag.$setPristine();
      currentTag.setTag(null);
    }

    function lookupThings() {
      currentTag.setTag(vm.tag);
    }

  }
})();
