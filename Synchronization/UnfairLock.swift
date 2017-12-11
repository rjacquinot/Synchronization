//
//  UnfairLock.swift
//
//  Copyright © 2017 Romain Jacquinot. All rights reserved.
//

import Foundation


public final class UnfairLock: NSLocking {

    public private(set) var _lock: os_unfair_lock

    public init() {
        _lock = os_unfair_lock()
    }

    @inline(__always)
    public func lock() {
        os_unfair_lock_lock(&_lock)
    }

    @inline(__always)
    public func unlock() {
        os_unfair_lock_unlock(&_lock)
    }

    @inline(__always)
    public func `try`() -> Bool {
        return os_unfair_lock_trylock(&_lock)
    }
}
