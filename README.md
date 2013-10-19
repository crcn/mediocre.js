### Features

- pre-hooks
- post-hooks
- 

```javascript

var mediator = require("mediocre")();


mediator.on("validate", function (command, next) {
  //validate 
});


//validate, then login
mediator.on({ validate: { } }, "login", function (command, next) {
  // login
});




mediator.on("pre login", funciton (command, next) {
  // pre login hook
});

mediator.on("post login", function (command, next) {
  // post login hook
});


```
