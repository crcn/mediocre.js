var expect = require("expect.js"),
mediocre = require("..");

describe("pre/post#", function() {

  var mediator = mediocre();

  it("can call a listener from an object", function(next) {

    var buffer = "";


    mediator.on("test", function (message, next) {
      buffer += "a";
      expect(message.options.hello).to.be(true);
      next();
    });


    mediator.on("test3", function (message, next) {
      buffer += "c";
      next();
    });

    mediator.on("test2", { test: { hello: true }, test3: true }, { test3: false }, function (message, next) {
      buffer += "b";
      next();
    });

    mediator.execute("test2", function() {
      expect(buffer).to.be("accb");
      next();
    });
  });


});