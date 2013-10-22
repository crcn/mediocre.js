var expect = require("expect.js"),
mediocre = require("..");

describe("pre/post#", function() {

  var mediator = mediocre();

  it("can register a listener", function() {
    mediator.on("test", function() {

    });
  });


  it("can execute a listener", function(next) {
    mediator.on("test", function(message, next) {
      next();
    });
    mediator.execute("test", next);
  });

  it("can add pre hooks onto a listener", function(next) {
    var buffer = "";
    mediator.on("pre test", function(message, next) {
      buffer += "b";
      next();
    });

    mediator.on("test", function(message, next) {
      buffer += "a";
      next();
    });

    mediator.execute("test", function() {
      expect(buffer).to.be("ba");
      next();
    })
  });


  it("add add post hooks onto a listener", function(next) {
    var buffer = "";
    mediator.on("post test", function(message, next) {
      buffer += "b"
      next();
    });

    mediator.on("test", function(message, next) {
      buffer += "a";
      next();
    });

    mediator.execute("test", function() {
      expect(buffer).to.be("ab");
      next();
    });
  });
});