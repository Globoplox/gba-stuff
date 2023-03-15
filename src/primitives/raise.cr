# Proc types seems to generate call to raise:
# https://crystal-lang.org/reference/1.7/syntax_and_semantics/c_bindings/callbacks.html
# > Note, however, that functions passed to C can't form closures. If the compiler detects at compile-time that a closure is being passed, an error will be issued.
# >  If the compiler can't detect this at compile-time, an exception will be raised at runtime.
# I don't know or to prevent it yet so lets juste define the symbol and leave it be for now.
def raise(__ignore : String): NoReturn
  while true
  end
end
