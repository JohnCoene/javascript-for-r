library(V8)

engine <- v8()

engine$source("https://cdn.jsdelivr.net/npm/fcal/dist/fcal.js")

engine$eval("const calc = new fcal.Fcal();")

engine$call("calc.evaluate", "radius : 23 m")