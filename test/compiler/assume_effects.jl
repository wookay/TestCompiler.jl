module test_compiler_assume_effects

using Test

codecov = Base.JLOptions().code_coverage != 0

# Base.@assume_effects :terminates_locally f
# function `f` to be constant-folded

Base.@assume_effects :terminates_locally function fact(x)
    # usage 1:
    # this :terminates_locally allows `fact` to be constant-folded
    res = 1
    0 ≤ x < 20 || error("bad fact")
    while x > 1
        res *= x
        x -= 1
    end
    return res
end

pair = code_typed() do
    fact(12)
end |> only

if codecov
    @test pair.first.code[1] == Expr(:code_coverage_effect)
else
    @test pair.first.code[1] == Core.ReturnNode(479001600)
end
@test pair.second === Int64

pair = code_typed() do
    map((2,3,4)) do x
        # usage 2:
        # this :terminates_locally allows this anonymous function to be constant-folded
        Base.@assume_effects :terminates_locally
        res = 1
        0 ≤ x < 20 || error("bad fact")
        while x > 1
            res *= x
            x -= 1
        end
        return res
    end
end |> only
if codecov
    @test pair.first.code[1] == Expr(:code_coverage_effect)
else
    @test pair.first.code[1] == Core.ReturnNode((2, 6, 24))
end
@test pair.second === Tuple{Int64, Int64, Int64}

pair = code_typed() do
    map((2,3,4)) do x
        res = 1
        0 ≤ x < 20 || error("bad fact")
        # usage 3:
        # with this :terminates_locally annotation the compiler skips tainting
        # `:terminates` effect within this `while` block, allowing the parent
        # anonymous function to be constant-folded
        Base.@assume_effects :terminates_locally while x > 1
            res *= x
            x -= 1
        end
        return res
    end
end |> only
if codecov
    @test pair.first.code[1] == Expr(:code_coverage_effect)
else
    @test pair.first.code[1] == Core.ReturnNode((2, 6, 24))
end
@test pair.second === Tuple{Int64, Int64, Int64}


#=
help?> ?Base.@assume_effects
  Base.@assume_effects setting... [ex]

  Override the compiler's effect modeling. This macro can be used in several contexts:

    1. Immediately before a method definition, to override the entire effect modeling of the applied method.

    2. Within a function body without any arguments, to override the entire effect modeling of the enclosing method.

    3. Applied to a code block, to override the local effect modeling of the applied code block.

  Examples
  ≡≡≡≡≡≡≡≡

  julia> Base.@assume_effects :terminates_locally function fact(x)
             # usage 1:
             # this :terminates_locally allows `fact` to be constant-folded
             res = 1
             0 ≤ x < 20 || error("bad fact")
             while x > 1
                 res *= x
                 x -= 1
             end
             return res
         end
  fact (generic function with 1 method)

  julia> code_typed() do
             fact(12)
         end |> only
  CodeInfo(
  1 ─     return 479001600
  ) => Int64

  julia> code_typed() do
             map((2,3,4)) do x
                 # usage 2:
                 # this :terminates_locally allows this anonymous function to be constant-folded
                 Base.@assume_effects :terminates_locally
                 res = 1
                 0 ≤ x < 20 || error("bad fact")
                 while x > 1
                     res *= x
                     x -= 1
                 end
                 return res
             end
         end |> only
  CodeInfo(
  1 ─     return (2, 6, 24)
  ) => Tuple{Int64, Int64, Int64}

  julia> code_typed() do
             map((2,3,4)) do x
                 res = 1
                 0 ≤ x < 20 || error("bad fact")
                 # usage 3:
                 # with this :terminates_locally annotation the compiler skips tainting
                 # `:terminates` effect within this `while` block, allowing the parent
                 # anonymous function to be constant-folded
                 Base.@assume_effects :terminates_locally while x > 1
                     res *= x
                     x -= 1
                 end
                 return res
             end
         end |> only
  CodeInfo(
  1 ─     return (2, 6, 24)
  ) => Tuple{Int64, Int64, Int64}

  │ Julia 1.8
  │
  │  Using Base.@assume_effects requires Julia version 1.8.

  │ Julia 1.10
  │
  │  The usage within a function body requires at least Julia 1.10.

  │ Julia 1.11
  │
  │  The code block annotation requires at least Julia 1.11.

  │ Warning
  │
  │  Improper use of this macro causes undefined behavior (including crashes, incorrect answers, or other hard to track bugs). Use with care and only
  │  as a last resort if absolutely required. Even in such a case, you SHOULD take all possible steps to minimize the strength of the effect
  │  assertion (e.g., do not use :total if :nothrow would have been sufficient).

  In general, each setting value makes an assertion about the behavior of the function, without requiring the compiler to prove that this behavior is indeed
  true. These assertions are made for all world ages. It is thus advisable to limit the use of generic functions that may later be extended to invalidate
  the assumption (which would cause undefined behavior).

  The following settings are supported.

    •  :consistent

    •  :effect_free

    •  :nothrow

    •  :terminates_globally

    •  :terminates_locally

    •  :notaskstate

    •  :inaccessiblememonly

    •  :noub

    •  :noub_if_noinbounds

    •  :nortcall

    •  :foldable

    •  :removable

    •  :total

  Extended help
  ≡≡≡≡≡≡≡≡≡≡≡≡≡

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :consistent
  ===========

  The :consistent setting asserts that for egal (===) inputs:

    •  The manner of termination (return value, exception, non-termination) will always be the same.

    •  If the method returns, the results will always be egal.

  │ Note
  │
  │  This in particular implies that the method must not return a freshly allocated mutable object. Multiple allocations of mutable objects (even
  │  with identical contents) are not egal.

  │ Note
  │
  │  The :consistent-cy assertion is made world-age wise. More formally, write fᵢ for the evaluation of f in world-age i, then this setting requires:
  │
  │  ∀ i, x, y: x ≡ y → fᵢ(x) ≡ fᵢ(y)
  │
  │  However, for two world ages i, j s.t. i ≠ j, we may have fᵢ(x) ≢ fⱼ(y).
  │
  │  A further implication is that :consistent functions may not make their return value dependent on the state of the heap or any other global state
  │  that is not constant for a given world age.

  │ Note
  │
  │  The :consistent-cy includes all legal rewrites performed by the optimizer. For example, floating-point fastmath operations are not considered
  │  :consistent, because the optimizer may rewrite them causing the output to not be :consistent, even for the same world age (e.g. because one ran
  │  in the interpreter, while the other was optimized).

  │ Note
  │
  │  If :consistent functions terminate by throwing an exception, that exception itself is not required to meet the egality requirement specified
  │  above.

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :effect_free
  ============

  The :effect_free setting asserts that the method is free of externally semantically visible side effects. The following is an incomplete list of
  externally semantically visible side effects:

    •  Changing the value of a global variable.

    •  Mutating the heap (e.g. an array or mutable value), except as noted below

    •  Changing the method table (e.g. through calls to eval)

    •  File/Network/etc. I/O

    •  Task switching

  However, the following are explicitly not semantically visible, even if they may be observable:

    •  Memory allocations (both mutable and immutable)

    •  Elapsed time

    •  Garbage collection

    •  Heap mutations of objects whose lifetime does not exceed the method (i.e. were allocated in the method and do not escape).

    •  The returned value (which is externally visible, but not a side effect)

  The rule of thumb here is that an externally visible side effect is anything that would affect the execution of the remainder of the program if the
  function were not executed.

  │ Note
  │
  │  The :effect_free assertion is made both for the method itself and any code that is executed by the method. Keep in mind that the assertion must
  │  be valid for all world ages and limit use of this assertion accordingly.

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :nothrow
  ========

  The :nothrow settings asserts that this method does not throw an exception (i.e. will either always return a value or never return).

  │ Note
  │
  │  It is permissible for :nothrow annotated methods to make use of exception handling internally as long as the exception is not rethrown out of
  │  the method itself.

  │ Note
  │
  │  If the execution of a method may raise MethodErrors and similar exceptions, then the method is not considered as :nothrow. However, note that
  │  environment-dependent errors like StackOverflowError or InterruptException are not modeled by this effect and thus a method that may result in
  │  StackOverflowError does not necessarily need to be !:nothrow (although it should usually be !:terminates too).

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :terminates_globally
  ====================

  The :terminates_globally settings asserts that this method will eventually terminate (either normally or abnormally), i.e. does not loop indefinitely.

  │ Note
  │
  │  This :terminates_globally assertion covers any other methods called by the annotated method.

  │ Note
  │
  │  The compiler will consider this a strong indication that the method will terminate relatively quickly and may (if otherwise legal) call this
  │  method at compile time. I.e. it is a bad idea to annotate this setting on a method that technically, but not practically, terminates.

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :terminates_locally
  ===================

  The :terminates_locally setting is like :terminates_globally, except that it only applies to syntactic control flow within the annotated method. It is
  thus a much weaker (and thus safer) assertion that allows for the possibility of non-termination if the method calls some other method that does not
  terminate.

  │ Note
  │
  │  :terminates_globally implies :terminates_locally.

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :notaskstate
  ============

  The :notaskstate setting asserts that the method does not use or modify the local task state (task local storage, RNG state, etc.) and may thus be safely
  moved between tasks without observable results.

  │ Note
  │
  │  The implementation of exception handling makes use of state stored in the task object. However, this state is currently not considered to be
  │  within the scope of :notaskstate and is tracked separately using the :nothrow effect.

  │ Note
  │
  │  The :notaskstate assertion concerns the state of the currently running task. If a reference to a Task object is obtained by some other means
  │  that does not consider which task is currently running, the :notaskstate effect need not be tainted. This is true, even if said task object
  │  happens to be === to the currently running task.

  │ Note
  │
  │  Access to task state usually also results in the tainting of other effects, such as :effect_free (if task state is modified) or :consistent (if
  │  task state is used in the computation of the result). In particular, code that is not :notaskstate, but is :effect_free and :consistent may
  │  still be dead-code-eliminated and thus promoted to :total.

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :inaccessiblememonly
  ====================

  The :inaccessiblememonly setting asserts that the method does not access or modify externally accessible mutable memory. This means the method can access
  or modify mutable memory for newly allocated objects that is not accessible by other methods or top-level execution before return from the method, but it
  can not access or modify any mutable global state or mutable memory pointed to by its arguments.

  │ Note
  │
  │  Below is an incomplete list of examples that invalidate this assumption:
  │
  │    •  a global reference or getglobal call to access a mutable global variable
  │
  │    •  a global assignment or setglobal! call to perform assignment to a non-constant global variable
  │
  │    •  setfield! call that changes a field of a global mutable variable

  │ Note
  │
  │  This :inaccessiblememonly assertion covers any other methods called by the annotated method.

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :noub
  =====

  The :noub setting asserts that the method will not execute any undefined behavior (for any input). Note that undefined behavior may technically cause the
  method to violate any other effect assertions (such as :consistent or :effect_free) as well, but we do not model this, and they assume the absence of
  undefined behavior.

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :nortcall
  =========

  The :nortcall setting asserts that the method does not call Core.Compiler.return_type, and that any other methods this method might call also do not call
  Core.Compiler.return_type.

  │ Note
  │
  │  To be precise, this assertion can be used when a call to Core.Compiler.return_type is not made at runtime; that is, when the result of
  │  Core.Compiler.return_type is known exactly at compile time and the call is eliminated by the optimizer. However, since whether the result of
  │  Core.Compiler.return_type is folded at compile time depends heavily on the compiler's implementation, it is generally risky to assert this if
  │  the method in question uses Core.Compiler.return_type in any form.

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :foldable
  =========

  This setting is a convenient shortcut for the set of effects that the compiler requires to be guaranteed to constant fold a call at compile time. It is
  currently equivalent to the following settings:

    •  :consistent

    •  :effect_free

    •  :terminates_globally

    •  :noub

    •  :nortcall

  │ Note
  │
  │  This list in particular does not include :nothrow. The compiler will still attempt constant propagation and note any thrown error at compile
  │  time. Note however, that by the :consistent-cy requirements, any such annotated call must consistently throw given the same argument values.

  │ Note
  │
  │  An explicit @inbounds annotation inside the function will also disable constant folding and not be overridden by :foldable.

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :removable
  ==========

  This setting is a convenient shortcut for the set of effects that the compiler requires to be guaranteed to delete a call whose result is unused at
  compile time. It is currently equivalent to the following settings:

    •  :effect_free

    •  :nothrow

    •  :terminates_globally

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  :total
  ======

  This setting is the maximum possible set of effects. It currently implies the following other settings:

    •  :consistent

    •  :effect_free

    •  :nothrow

    •  :terminates_globally

    •  :notaskstate

    •  :inaccessiblememonly

    •  :noub

    •  :nortcall

  │ Warning
  │
  │  :total is a very strong assertion and will likely gain additional semantics in future versions of Julia (e.g. if additional effects are added
  │  and included in the definition of :total). As a result, it should be used with care. Whenever possible, prefer to use the minimum possible set
  │  of specific effect assertions required for a particular application. In cases where a large number of effect overrides apply to a set of
  │  functions, a custom macro is recommended over the use of :total.

  ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  Negated effects
  ===============

  Effect names may be prefixed by ! to indicate that the effect should be removed from an earlier meta effect. For example, :total !:nothrow indicates that
  while the call is generally total, it may however throw.
=#

end # module test_compiler_assume_effects
