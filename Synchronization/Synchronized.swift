//
//  AtomicValue.swift
//
//  Copyright © 2017 Romain Jacquinot. All rights reserved.
//

import Foundation


/// A wrapper that provides synchronization over the type `Wrapped`.
///
/// - Note:
/// For thread-safe objects, use Atomic<Wrapped> instead.
public final class Synchronized<Wrapped> {

    public init(_ initialValue: Wrapped) {
        self.value = initialValue
    }

    /// The wrapped value of this instance, unwrapped atomically.
    ///
    /// - Warning:
    /// This property does not make any guarantees about thread safety.
    /// It only ensures a whole value is returned.
    public var atomicallyUnwrapped: Wrapped {
        lock.lock()
        defer {
            lock.unlock()
        }
        return value
    }

    /// Atomically sets the wrapped value to a new value.
    ///
    /// - Parameter newValue: The new value.
    public func set(_ newValue: Wrapped) {
        lock.lock()
        value = newValue
        lock.unlock()
    }

    /// Provides synchronized access to the value.
    @discardableResult
    public func access<R>(_ closure: (inout Wrapped) throws -> R) rethrows -> R {
        lock.lock()
        defer { lock.unlock() }
        return try closure(&value)
    }

    private var value: Wrapped
    private let lock = UnfairLock()
}


// MARK: - Convenience initializers

public extension Synchronized where Wrapped: ExpressibleByNilLiteral {

    convenience init() {
        self.init(nil)
    }
}


public extension Synchronized where Wrapped: ExpressibleByArrayLiteral {

    convenience init() {
        self.init([])
    }
}


public extension Synchronized where Wrapped: ExpressibleByDictionaryLiteral {

    convenience init() {
        self.init([:])
    }
}
