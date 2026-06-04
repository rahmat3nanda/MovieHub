//
//  UserDefaultsStorage.swift
//  Persistence
//
//  Created by Rahmat Trinanda Pramudya Amar on 04/06/26.
//

import Foundation

public final class UserDefaultsStorage: Storage {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func get<T: Codable>(_ type: T.Type, forKey key: any KeyStorage) throws -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            return nil
        }
        return try decoder.decode(T.self, from: data)
    }

    public func set<T: Codable>(_ value: T, forKey key: any KeyStorage) throws {
        let data = try encoder.encode(value)
        userDefaults.set(data, forKey: key.rawValue)
    }
}
