(function() {
  'use strict';

  angular
    .module('spa-photoTourist.states')
    .controller('spa-photoTourist.states.StatesController', StatesController)

  StatesController.$inject = ['spa-photoTourist.states.State'];

  function StatesController(State) {
    var vm = this;
    vm.states = [];
    vm.state = {};

    activate();
    return;

    function activate() {
      newState();
      vm.states = State.query();
    }

    function newState() {
      vm.state = new State();
    }

    function handleError(response) {
      console.log(response);
    }

    function edit(object, index) {

    }

    function create() {

    }

    function update() {

    }

    function remove() {

    }

    function removeElement(elements, element) {

    }
  }
})();
