var Message        = require("./message"),
factory            = require("./factory"),
listenerCollection = require("./factory/collection"),
type               = require("type-component"),
async              = require("async"),
protoclass         = require("protoclass");



function Mediator () {
  this._listeners = {};
}


protoclass(Mediator, {

  /**
   */

  on: function (nameOrPlugin) {

    var listeners, nameParts, collection, listener;

    listeners = Array.prototype.slice.call(arguments, 1);

    if (nameOrPlugin.test) {
      return factory.push(nameOrPlugin);
    }

    nameParts = this._parse(nameOrPlugin);

    if(!(listener = this._listeners[nameParts.name])) {
      listener = this._listeners[nameParts.name] = { pre: [], post: [] };
    }

    listeners = factory.create(this, listeners);

    if(nameParts.type) {
      collection = listener[nameParts.type];
      collection.push(listeners);
    } else {
      listener.callback = listeners;
    }

    return {
      dispose: function () {
        var i;
        if (collection) {
          i = collection.indexOf(listeners);
          if(~i) {
            collection.splice(i, 1);
          }
        } else {
          delete this._listeners[nameParts.name];
        }
      }
    };
  },

  /**
   */

  message: function (name, data, options) {

    if(arguments.length === 2) {{}
      options = {};
    }

    return new Message(name, data, options, this);
  },

  /**
   */

  once: function (name) {
    var listeners, listener;

    listeners = Array.prototype. slice.call(arguments, 1);
    listeners.unshift(function (message, next) {
      listener.dispose();
      next();
    });

    return listener = this.on.apply(this, [name].concat(listeners));
  },

  /**
   */

  execute: function (nameOrMessage, data, next) {
    var msg, listener, chain;

    if (!nameOrMessage.__isCommand) {
      msg = this.message(nameOrMessage, data);
    } else {
      msg = nameOrMessage;
      next = data;
    }

    if (arguments.length === 2 && type(data) === "function") {
      next = data;
    }

    if (type(next) !== "function") {
        next = function () {};
    }

    listener = this._listeners[msg.name] || {};

    chain = (listener.pre || []).
      concat(listener.callback || []).
      concat(listener.post || [])


    if (!chain.length) {
      return next(new Error("command '"+ nameOrMessage + "' does not exist"));
    }

    async.eachSeries(chain, function (listener, next) {
      listener(msg, next);
    }, function (err) {
      if(err) return next.apply(this, arguments);
      next.apply(this, [null].concat(msg.args));
    });
  },

  /**
   */

  _parse: function (message) {
    var messageParts = message.split(" "),
    name = messageParts.pop(),
    t = messageParts.pop(); // pre? post?

    return { type: t, name: name };
  }
});

module.exports = function () {
  return new Mediator();
}