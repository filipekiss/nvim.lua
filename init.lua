Nebula = require("nebula")

Nebula.augroup("CreateMissingFolder", {
  {
    events = {"BufWritePre", "FileWritePre"},
    targets = { "*" },
    modifiers = {"silent!"},
    command = "call mkdir(expand('<afile>:p:h'), 'p')"
  }
})

Nebula.init()
