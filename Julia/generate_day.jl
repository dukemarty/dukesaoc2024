
using Pkg

Pkg.generate(ARGS[1])
Pkg.activate(ARGS[1])
Pkg.develop(path="./aoclib")
