(function() {
  'use strict';

  angular
    .module('spa-photoTourist.states')
    .directive('sdStates', StatesDirective);

  StatesDirective.$inject = ['spa-photoTourist.APP_CONFIG'];

  function StatesDirective(APP_CONFIG) {
    var directive = {
      templateUrl: APP_CONFIG.states_html,
      replace: true,
      bindToController: true,
      controller: 'spa-photoTourist.states.StatesController',
      controllerAs: 'statesVM',
      restrict: 'E',
      scope: {},
      link: link
    };
    return directive;

    function link(scope, element, attrs) {
      console.log('StatesDirective', scope);
    }
  }
})();
