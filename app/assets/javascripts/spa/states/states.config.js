(function() {
  'use strict';

  angular
    .module('spa-photoTourist.states')
    .config(StatesConfigFunction);

  StatesConfigFunction.$inject = ['$resourceProvider'];

  function StatesConfigFunction($resourceProvider) {
    $resourceProvider.defaults.actions.update = {
      method: 'PUT',
      transformRequest: buildNestedBody
    };
    $resourceProvider.defaults.actions.save = {
      method: 'POST',
      transformRequest: buildNestedBody
    };
    $resourceProvider.defaults.actions.remove = {
      method: 'DELETE',
      transformRequest: buildNestedBody
    };
  }

  function buildNestedBody(data) {
    return angular.toJson({state: data});
  }
})();
