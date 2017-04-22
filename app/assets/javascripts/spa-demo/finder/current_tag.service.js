(function() {
  'use strict';

  angular
    .module('spa-demo.finder')
    .service('spa-demo.finder.currentTag', CurrentTag);

  CurrentTag.$inject = ['$rootScope'];

  function CurrentTag($rootScope) {
    var service = this;
    this.version = 0;
    this.tag = null;

    return;
    ////////////////
  }

  function parameterize(tag) {
    return tag.toLowerCase().replace(/[^a-z0-9]+/g,'-').replace(/(^-|-$)/g,'');
  }

  function compareTag(tag) {
    if (tag !== this.tag) {
      this.tag = tag;
      this.version += 1;
    }
  }

  CurrentTag.prototype.getVersion = function() {
    return this.version;
  }

  CurrentTag.prototype.getTag = function() {
    return this.tag;
  }

  CurrentTag.prototype.setTag = function(tag) {
    if (tag) {
      var parameterizedTag = parameterize(tag);
      compareTag.call(this, parameterizedTag);
    } else {
      compareTag.call(this, tag);
    }
  }
})();
