//
//  Atomic.swift
//
//  Copyright © 2017 Romain Jacquinot. All rights reserved.
//

import Foundation


/// This class will ensure that a whole value is always returned from the getter or set by the setter,
/// regardless of setter activity on any other thread.
///
/// - Warning: `Atomic<Wrapped>` does not make any guarantees about thread safety.
public final class Atomic<Wrapped> {

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

    private var value: Wrapped
    private let lock = UnfairLock()
}


// MARK: - Convenience initializers

public extension Atomic where Wrapped: ExpressibleByNilLiteral {

    convenience init() {
        self.init(nil)
    }
}
