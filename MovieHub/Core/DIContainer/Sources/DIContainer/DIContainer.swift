//
//  DIContainer.swift
//  MovieHub
//
//  Created by Antigravity on 03/06/26.
//

import Foundation

public final class DIContainer {
    public static let shared = DIContainer()
    
    private var dependencies: [String: Any] = [:]
    private let lock = NSRecursiveLock()
    
    private init() {}
    
    /// Registers a dependency in the container.
    /// - Parameters:
    ///   - type: The protocol or type to register.
    ///   - dependency: The concrete implementation instance.
    public func register<T>(_ type: T.Type, dependency: Any) {
        lock.lock()
        defer { lock.unlock() }
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    /// Resolves a dependency from the container.
    /// - Parameter type: The protocol or type to resolve.
    /// - Returns: The registered concrete implementation instance.
    public func resolve<T>(_ type: T.Type) -> T {
        lock.lock()
        defer { lock.unlock() }
        let key = String(describing: type)
        guard let dependency = dependencies[key] as? T else {
            fatalError("Dependency '\(key)' not registered in DIContainer.")
        }
        return dependency
    }
}

@propertyWrapper
public struct Inject<T> {
    public var wrappedValue: T {
        return DIContainer.shared.resolve(T.self)
    }
    
    public init() {}
}
