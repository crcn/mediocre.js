var protoclass = require("protoclass");

/**
 */

function Message (name, data, options, mediator, parent) {

  this.name     = name;
  this.data     = data;
  this.options  = options || {};
  this.mediator = mediator;
  this.parent   = parent;
  this.args     = [];
  this.root     = parent ? parent.root : this;

}

/**
 */

protoclass(Message, {

  /**
   */

  __isCommand: true,

  /**
   */

  child: function (name, options) {
    return new Message(name, this.data, options, this.mediator, this);
  }
});

/**
 */

module.exports = Message;