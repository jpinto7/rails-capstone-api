(function() {
  'use strict';

  angular
    .module('spa-photoTourist.states')
    .config(StatesConfigFunction);

  StatesConfigFunction.$inject = ['$resourceProvider'];

  function StatesConfigFunction($resourceProvider) {
    $resourceProvider.defaults.actions.update = {
      method: 'PUT'
    };
  }
})();
