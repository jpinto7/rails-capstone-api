(function() {
  "use strict";

  angular
    .module("spa-demo.layout")
    .component("sdNavbar", {
      templateUrl: templateUrl,
      controller: NavbarController
    });


  templateUrl.$inject = ["spa-demo.config.APP_CONFIG"];
  function templateUrl(APP_CONFIG) {
    return APP_CONFIG.navbar_html;
  }

  NavbarController.$inject = [
    "$scope",
    "spa-demo.authn.Authn",
    "$state"
  ];

  function NavbarController($scope, Authn, $state) {
    var vm=this;
    vm.getLoginLabel = getLoginLabel;
    vm.showOriginSelector = showOriginSelector;
    vm.showSearchByTag = showSearchByTag;

    vm.$onInit = function() {
      //console.log("NavbarController",$scope);
    }

    $scope.$watch(function() { return $state.$current.name; },
      function(stateName) {
        vm.stateName = stateName;
      }
    );
    
    return;
    //////////////
    function getLoginLabel() {
      return Authn.isAuthenticated() ? Authn.getCurrentUserName() : "Login";
    }

    function showOriginSelector() {
      return vm.stateName === 'home';
    }

    function showSearchByTag() {
      return vm.stateName === 'finder';
    }
  }
})();
