### Features

- pre-hooks
- post-hooks
- 

```javascript

var mediator = require("mediocre")();



mediator.on("validate", function (command, next) {
  //validate 
  command.paren.
});


//mediator.on(commandName, preHook, preHook, ...., commandName, fn, postHook, postHook);



//
mediator.on("login", { validate: { username: "string" });





//validate, then login
mediator.on({ 
  validate: { 
    username: "string",
    password: "string"
    } 
  }, "login", function (command, next) {
  // login
});



mediator.on("pre initialize", "checkSession", function(err) {
  
});


mediator.on("checkSession", function(command, next) {
  // ajaxRequest
  if(!session) return next(new Error("access denied")) ;
  
  next();
});


mediator.execute("login", , function(err, result) {
  
});


mediator.on("pre login", funciton (command, next) {
  // pre login hook
});

mediator.on("post login", function (command, next) {
  // post login hook
});


```
