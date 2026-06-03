//
//  AppDelegate+Registration.swift
//  MovieHub
//
//  Created by Rahmat Trinanda Pramudya Amar on 03/06/26.
//

import DIContainer
import NetworkManager

extension AppDelegate {
    func register() {
        DIContainer.shared.register(NetworkService.self, dependency: URLSessionNetworkService())
    }
}
