// Generated by CoffeeScript 1.10.0
(function() {
  var Timeout, moduleName, types,
    slice = [].slice;

  types = require('types.js');

  moduleName = 'control-timeout';

  Timeout = (function() {
    Timeout.setLog = function(log) {
      return Timeout.log = types.forceFunction(log);
    };

    Timeout.log = Timeout.setLog(typeof console !== "undefined" && console !== null ? console.log : void 0);

    Timeout.delay = 0;

    function Timeout(delay) {
      this.timeouts = {};
      this.running = {};
      this.delay = (Math.abs(delay)) || Timeout.delay;
    }

    Timeout.prototype.exists = function(id) {
      return this.timeouts.hasOwnProperty(id);
    };

    Timeout.prototype.isRunning = function(id) {
      return this.running.hasOwnProperty(id);
    };

    Timeout.prototype._stopOne = function(id) {
      if (this.isRunning(id)) {
        clearTimeout(this.running[id]);
        delete this.running[id];
      }
      return this;
    };

    Timeout.prototype.stop = function() {
      var i, id, ids, len;
      ids = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (!ids.length) {
        for (id in this.running) {
          this._stopOne(id);
        }
      } else {
        for (i = 0, len = ids.length; i < len; i++) {
          id = ids[i];
          this._stopOne(id);
        }
      }
      return this;
    };

    Timeout.prototype.setDelay = function(id, delay) {
      if (this.exists(id)) {
        return this.timeouts[id].delay = types.forceNumber(delay, this.timeouts[id].delay);
      }
    };

    Timeout.prototype.getTimeout = function(id) {
      return this.running[id];
    };

    Timeout.prototype._setTimeout = function(id, action, delay) {
      return this.running[id] = setTimeout((function(_this) {
        return function() {
          delete _this.running[id];
          return action();
        };
      })(this), delay);
    };

    Timeout.prototype.run = function() {
      var args, id, ref, ref1, ref2, timeout, timeouts;
      id = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      timeouts = [];
      if (!id) {
        ref = this.timeouts;
        for (id in ref) {
          timeout = ref[id];
          if (!this.isRunning(id)) {
            timeouts.push(this._setTimeout(id, (ref1 = timeout.action).bind.apply(ref1, [null].concat(slice.call(args))), timeout.delay));
          }
        }
      } else if (this.exists(id)) {
        timeouts.push(this._setTimeout(id, (ref2 = this.timeouts[id].action).bind.apply(ref2, [null].concat(slice.call(args))), this.timeouts[id].delay));
      } else {
        Timeout.log(moduleName + ': timeout with id: "' + id + '" was not found');
      }
      switch (timeouts.length) {
        case 0:
          Timeout.log(moduleName + ': no timeouts were found, nothing to run..');
          return null;
        case 1:
          return timeouts[0];
        default:
          return timeouts;
      }
    };

    Timeout.prototype.removeAll = function() {
      this.stop();
      this.timeouts = {};
      return this;
    };

    Timeout.prototype.remove = function() {
      var i, id, ids, len;
      ids = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (ids.length) {
        for (i = 0, len = ids.length; i < len; i++) {
          id = ids[i];
          this._stopOne(id);
          delete this.timeouts[id];
        }
      } else {
        Timeout.log(moduleName + ': cannot remove, invalid or non-existing timeout!');
      }
      return this;
    };

    Timeout.prototype._add = function(id, action, delay) {
      if (types.notString(id) || !id.length) {
        Timeout.log(moduleName + ': cannot add timeout, invalid or missing id!');
      } else if (this.exists(id)) {
        Timeout.log(moduleName + ': cannot add timeout, id: ' + id + ' exists already!');
      } else {
        this.timeouts[id] = {
          action: types.forceFunction(action),
          delay: Math.abs(types.forceNumber(delay, this.delay))
        };
        return id;
      }
      return void 0;
    };

    Timeout.prototype.add = function(id, action, delay) {
      if (types.isObject(id)) {
        return this._add(id.id, id.action, id.delay);
      } else {
        return this._add(id, action, delay);
      }
    };

    return Timeout;

  })();

  module.exports = Timeout;

}).call(this);
