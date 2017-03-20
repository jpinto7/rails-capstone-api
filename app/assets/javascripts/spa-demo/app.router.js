(function() {
  'use strict';

  angular
    .module('spa-demo')
    .config(RouterFunction)
    .run(RunFunction);

  RouterFunction.$inject = [
    '$stateProvider',
    '$urlRouterProvider',
    'spa-demo.config.APP_CONFIG'
  ];

  function RouterFunction($stateProvider, $urlRouterProvider, APP_CONFIG) {
    $stateProvider
      .state('auth', {
        abstract: true,
        template: '<ui-view></ui-view>',
        data: {
          authenticate: true
        },
        resolve: {
          auth: function($state, $auth) {
            return $auth.validateUser().catch(function(){
              $state.go('home');
            });
          }
        }
      })
      .state('home', {
        url: '/',
        templateUrl: APP_CONFIG.main_page_html,
        // controller: ,
        // controllerAs: ,
      })
      .state('accountSignup', {
        url: '/signup',
        templateUrl: APP_CONFIG.signup_page_html
      })
      .state('authn', {
        url: '/authn',
        templateUrl: APP_CONFIG.authn_page_html
      })
      .state('newImage', {
        parent: 'auth',
        url: '/images/new',
        templateUrl: APP_CONFIG.new_image_page_html
      })
      .state('showImage', {
        url: '/images/:id',
        templateUrl: APP_CONFIG.show_image_page_html
      })
      .state('images', {
        url: '/images',
        templateUrl: APP_CONFIG.images_page_html
      })
      .state('newThing', {
        parent: 'auth',
        url: '/things/new',
        templateUrl: APP_CONFIG.new_thing_page_html
      })
      .state('showThing', {
        url: '/things/:id',
        templateUrl: APP_CONFIG.show_thing_page_html
      })
      .state('things', {
        parent: 'auth',
        url: '/things?tag',
        templateUrl: APP_CONFIG.things_page_html
      });

    $urlRouterProvider.otherwise('/');
  }

  RunFunction.$inject = ['$rootScope', '$state'];

  function RunFunction($rootScope, $state) {
    $rootScope.$on('auth:logout-success', function() {
      if ($state.current.data && $state.current.data.authenticate) {
        $state.go('home');
      }
    });
  }
})();
