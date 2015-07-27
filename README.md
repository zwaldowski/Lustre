# Lustre

Lustre is a more protocol-oriented variant of the nascent `Result` pattern in
Swift 2.0, as seen commonly [in the community](https://github.com/antitypical/Result).

Lustre provides a protocol, `EitherType`, as well as two concrete
implementations, `Either<T, U>` and `Result<T>`.

* The protocol is Swift-oriented and provides common functionality to monadic
  types such as equatability and case analysis.
* The `Either` type is modelled after the same name in Scala or Haskell. By
  convention, the "Left" case is a failure or negative scenario, but `Either`
  is more generally designed around any switch between two first-class values.
* The `Result` type is related to the type of the same name in Haskell, and can
  be considered a specialization of `Either` designed for compatibility with
  Swift's error-handling. Its `Failure` case takes `ErrorType`, and convenience
  methods are provided for conversion to and from Swift error handling syntax.

## Why the Protocol?

A good chunk of the time, you'll be using the concrete `Either` and `Result`.
Like the design of Swift's `map` and `flatMap`, the default implementations of
`map` and `flatMap` return a `Result`.

Making your own `EitherType` is useful for API design, when you want to model
specific scenarios but also get the convenience of an `Either` API. This
includes types not strictly represented by an enum with two cases, or a wrapper
of another result, etc.

It might be advantageous to make your own concrete type conforming to
`EitherType` and give it extra functionality. Consider an idiomatic `JSON`
enum type. A JSON parser might return a `JSONResult`. On that type, you could
have convenience methods to return a `Result<String>` if the JSON value is the
string case, etc. But by conforming to `EitherType`, it is also mostly
interchangeable with any `Result` instance.

The need for this repo can go away if extensions with `where` cases are added
to generics to parallel protocol extensions. See [rdar://21901489](http://www.openradar.me/radar?id=4677878595715072).
Until then, Lustre is a scalable, usable, and idiomatic version of the pattern
you already know and more-or-less tolerate. Unlike previous versions of Lustre,
there are no weird hacks, no `Any`, and no syntactical difference from the
common-case `Result` type.

## Availability

Lustre, on this branch, is intended for Swift 2.0. The old hacky version for
Swift 1.2 is still [preserved](https://github.com/zwaldowski/Lustre/tree/swift-1_2).

## What's up with the name?

Result `=>` Lustre. It's an anagram.
