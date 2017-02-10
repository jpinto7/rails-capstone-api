(function() {
  'use strict';

  angular
    .module('spa-photoTourist.states')
    .factory('spa-photoTourist.states.State', StateFactory);

  StateFactory.$inject = ['$resource', 'spa-photoTourist.APP_CONFIG'];

  function StateFactory($resource, APP_CONFIG) {
    return $resource(APP_CONFIG.server_url + '/api/states/:id',
      { id: '@id' }
    );
  }
})();
