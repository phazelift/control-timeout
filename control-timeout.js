// Generated by CoffeeScript 1.10.0
(function() {
  var Timeout, types;

  types = require('types.js');

  Timeout = (function() {
    Timeout.log = types.forceFunction(typeof console !== "undefined" && console !== null ? console.log : void 0);

    Timeout.delay = 0;

    function Timeout(delay) {
      this.timeout = {};
      this.running = {};
      this.delay = (Math.abs(delay)) || Timeout.delay;
    }

    Timeout.prototype.exists = function(id) {
      return this.timeout.hasOwnProperty(id);
    };

    Timeout.prototype.isRunning = function(id) {
      return this.running.hasOwnProperty(id);
    };

    Timeout.prototype.stopOne = function(id) {
      clearTimeout(this.running[id]);
      delete this.running[id];
      return this;
    };

    Timeout.prototype.stop = function(id) {
      if (!id) {
        for (id in this.running) {
          this.stopOne(id);
        }
      } else {
        this.stopOne(id);
      }
      return this;
    };

    Timeout.prototype.setTimeout = function(id, action, delay) {
      this.running[id] = setTimeout((function(_this) {
        return function() {
          delete _this.running[id];
          return action();
        };
      })(this), delay);
      return this;
    };

    Timeout.prototype.run = function(id) {
      var ref, timeout;
      if (types.isString(id) && (this.exists(id)) && (!this.isRunning(id))) {
        this.setTimeout(id, this.timeout[id].action, this.timeout[id].delay);
      } else {
        ref = this.timeout;
        for (id in ref) {
          timeout = ref[id];
          if (!this.isRunning(id)) {
            this.setTimeout(id, timeout.action, timeout.delay);
          }
        }
      }
      return this;
    };

    Timeout.prototype.removeAll = function(stop) {
      if (stop) {
        this.stop();
      }
      this.timeout = {};
      return this;
    };

    Timeout.prototype.remove = function(id) {
      if (id = types.forceString(id)) {
        this.stopOne(id);
        delete this.timeout[id];
      } else {
        Timeout.log('cannot remove invalid or non-existing timeout!');
      }
      return this;
    };

    Timeout.prototype.add = function(id, action, delay) {
      var settings, timeout;
      settings = types.forceObject(id);
      if (!types.forceString(id, settings.id)) {
        Timeout.log('cannot add timeout, invalid or missing arguments!');
        return this;
      }
      timeout = {
        action: types.forceFunction(action, settings.action),
        delay: types.forceNumber(delay, 0) || types.forceNumber(settings.delay, this.delay)
      };
      id = types.forceString(id) || settings.id;
      if (this.exists(id)) {
        Timeout.log('cannot add timeout, id: ' + id + ' exists already!');
      } else {
        this.timeout[id] = timeout;
      }
      return this;
    };

    return Timeout;

  })();

  module.exports = Timeout;

}).call(this);