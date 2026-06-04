//
//  AppDelegate+Registration.swift
//  MovieHub
//
//  Created by Rahmat Trinanda Pramudya Amar on 03/06/26.
//

import DIContainer
import NetworkManager
import Persistence
import SharedUI

extension AppDelegate {
    func register() {
        DIContainer.shared.register(NetworkService.self, dependency: URLSessionNetworkService())
        DIContainer.shared.register(Storage.self, dependency: UserDefaultsStorage())
        DIContainer.shared.register(ToastService.self, dependency: DefaultToastService())
    }
}
