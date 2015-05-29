//
//  Try.swift
//  Lustre
//
//  Created by Zachary Waldowski on 5/8/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

// MARK: Free try

/**
    Wrap the result of a Cocoa-style function signature into a result type,
    either through currying or inline with a trailing closure.

    :param: function A statically-known version of the calling function.
    :param: file A statically-known version of the calling file in the project.
    :param: line A statically-known version of the calling line in code.
    :param: wrapError A transform to wrap the resulting error, such as in a
                      custom domain or with extra context.
    :param: fn A function with a Cocoa-style `NSErrorPointer` signature.
    :returns: A result type created by wrapping the returned optional.
**/
public func try<R: ResultType>(function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__, @noescape wrapError transform: (NSError -> NSError) = identityError, @noescape fn: NSErrorPointer -> R.Value?) -> R {
    var err: NSError?
    switch (fn(&err), err) {
    case (.Some(let value), _):
        return success(value)
    case (.None, .Some(let error)):
        return failure(transform(error))
    default:
        return failure(transform(error(function: function, file: file, line: line)))
    }
}

/**
    Wrap the result of a Cocoa-style function signature returning its value via
    output parameter into a result type, either through currying or inline with
    a trailing closure.

    :param: function A statically-known version of the calling function.
    :param: file A statically-known version of the calling file in the project.
    :param: line A statically-known version of the calling line in code.
    :param: wrapError A transform to wrap the resulting error, such as in a
                      custom domain or with extra context.
    :param: fn A function with a Cocoa-style signature of many output pointers.
    :returns: A result type created by wrapping the returned byref value.
**/
public func try<R: ResultType>(function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__, @noescape wrapError transform: (NSError -> NSError) = identityError, @noescape fn: (UnsafeMutablePointer<R.Value>, NSErrorPointer) -> Bool) -> R {
    var value: R.Value!
    var err: NSError?
    
    let didSucceed = withUnsafeMutablePointer(&value) { (ptr) -> Bool in
        bzero(UnsafeMutablePointer(ptr), sizeof(ImplicitlyUnwrappedOptional<R.Value>))
        return fn(UnsafeMutablePointer(ptr), &err)
    }
    
    switch (didSucceed, err) {
    case (true, _):
        return success(value)
    case (false, .Some(let error)):
        return failure(transform(error))
    default:
        return failure(transform(error(function: function, file: file, line: line)))
    }
}

/**
    Wrap the result of a Cocoa-style function signature into a result type,
    either through currying or inline with a trailing closure.

    :param: function A statically-known version of the calling function.
    :param: file A statically-known version of the calling file in the project.
    :param: line A statically-known version of the calling line in code.
    :param: wrapError A transform to wrap the resulting error, such as in a
                      custom domain or with extra context.
    :param: fn A function with a Cocoa-style `NSErrorPointer` signature.
    :returns: A result type created by wrapping the returned optional.
**/
public func try<T>(function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__, @noescape wrapError transform: NSError -> NSError = identityError, @noescape fn: NSErrorPointer -> T?) -> Result<T> {
    var err: NSError?
    switch (fn(&err), err) {
    case (.Some(let value), _):
        return success(value)
    case (.None, .Some(let error)):
        return failure(transform(error))
    default:
        
        return failure(transform(error(function: function, file: file, line: line)))
    }
}

/**
    Wrap the result of a Cocoa-style function signature returning its value via
    output parameter into a result type, either through currying or inline with
    a trailing closure.

    :param: function A statically-known version of the calling function.
    :param: file A statically-known version of the calling file in the project.
    :param: line A statically-known version of the calling line in code.
    :param: wrapError A transform to wrap the resulting error, such as in a
                      custom domain or with extra context.
    :param: fn A function with a Cocoa-style signature of many output pointers.
    :returns: A result type created by wrapping the returned byref value.
**/
public func try<T>(function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__, @noescape wrapError transform: NSError -> NSError = identityError, @noescape fn: (UnsafeMutablePointer<T>, NSErrorPointer) -> Bool) -> Result<T> {
    var value: T!
    var err: NSError?
    
    let didSucceed = withUnsafeMutablePointer(&value) { ptr -> Bool in
        bzero(UnsafeMutablePointer(ptr), sizeof(ImplicitlyUnwrappedOptional<T>))
        return fn(UnsafeMutablePointer(ptr), &err)
    }
    
    switch (didSucceed, err) {
    case (true, _):
        return success(value)
    case (false, .Some(let error)):
        return failure(transform(error))
    default:
        return failure(transform(error(function: function, file: file, line: line)))
    }
}

/**
    Wrap the result of a Cocoa-style function signature returning an object via
    output parameter into a result type, either through currying or inline with
    a trailing closure.

    :param: function A statically-known version of the calling function.
    :param: file A statically-known version of the calling file in the project.
    :param: line A statically-known version of the calling line in code.
    :param: wrapError A transform to wrap the resulting error, such as in a
                      custom domain or with extra context.
    :param: fn A Cocoa-style function with many output parameters.
    :returns: A result type created by wrapping the object returned by reference.
**/
public func try<T: AnyObject>(function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__, @noescape wrapError transform: (NSError -> NSError) = identityError, @noescape fn: (AutoreleasingUnsafeMutablePointer<T?>, NSErrorPointer) -> Bool) -> Result<T> {
    var value: T?
    var err: NSError?
    switch (fn(&value, &err), value, err) {
    case (true, .Some(let value), _):
        return success(value)
    case (false, _, .Some(let error)):
        return failure(transform(error))
    default:
        return failure(transform(error(function: function, file: file, line: line)))
    }
}

/**
    Wrap the result of a Cocoa-style function signature into a result type,
    either through currying or inline with a trailing closure.

    :param: function A statically-known version of the calling function.
    :param: file A statically-known version of the calling file in the project.
    :param: line A statically-known version of the calling line in code.
    :param: wrapError A transform to wrap the resulting error, such as in a
                      custom domain or with extra context.
    :param: fn A function with a Cocoa-style `NSErrorPointer` signature.
    :returns: A result type created by wrapping the returned optional.
**/
public func try(function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__, @noescape wrapError transform: (NSError -> NSError) = identityError, @noescape fn: NSErrorPointer -> Bool) -> Result<Void> {
    var err: NSError?
    switch (fn(&err), err) {
    case (true, _):
        return success()
    case (false, .Some(let error)):
        return failure(transform(error))
    default:
        return failure(transform(error(function: function, file: file, line: line)))
    }
}
