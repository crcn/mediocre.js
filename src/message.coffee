class Message

  ###
  ###

  __isCommand: true

  ###
  ###

  constructor: (@name, @data, @options = {}, @parent = undefined) ->
    @args = []
    @root = if @parent then @parent.root else @

  ###
  ###

  child: (name, options) -> new Message name, @data, options, @



module.exports = Message