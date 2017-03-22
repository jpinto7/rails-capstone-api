(function() {
  'use strict';

  angular
    .module('spa-demo.layout')
    .component('sdNavbar', {
      templateUrl: templateUrl,
      controller: NavbarController
    });

  templateUrl.$inject = ['spa-demo.config.APP_CONFIG'];

  function templateUrl(APP_CONFIG) {
    return APP_CONFIG.navbar_html;
  }

  NavbarController.$inject = [
    '$scope',
    '$state',
    '$element',
    'spa-demo.authn.Authn'
  ];

  function NavbarController($scope, $state, $element, Authn) {
    var vm = this;
    var loginDropdown = $element.find('#login-dropdown');
    vm.getLoginLabel = getLoginLabel;
    vm.isAuthenticated = Authn.isAuthenticated;
    vm.goSearch = goSearch;

    vm.$onInit = function() {
      console.log('NavbarController',$scope);
    }

    $scope.$on('$stateChangeSuccess', function() {
      loginDropdown.removeClass('open');
    });

    return;
    //////////////
    function getLoginLabel() {
      return Authn.isAuthenticated() ? Authn.getCurrentUserName() : 'Login';
    }

    function goSearch() {
      $state.go('search', {
        tag: vm.searchString
      });
    }
  }
})();
