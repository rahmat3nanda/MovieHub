//
//  Storage.swift
//  Persistence
//
//  Created by Rahmat Trinanda Pramudya Amar on 04/06/26.
//

public protocol Storage {
    func get<T: Codable>(_ type: T.Type, forKey key: KeyStorage) throws -> T?
    func set<T: Codable>(_ value: T, forKey key: KeyStorage) throws
}
