factories = require "factories"

module.exports = factories.any [
  require("./obj"),
  require("./fn"),
  require("./str"),
  require("./array")
]