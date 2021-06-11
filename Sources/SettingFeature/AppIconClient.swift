//
//  AppIconClient.swift
//  
//
//  Created by lcr on 2021/06/11.
//  
//

import ComposableArchitecture
import SwiftUI

public class AppIconClient {
    public var setIcon: (_ name: String) -> Effect<String, AppIconError>

    public init(setIcon: @escaping (String) -> Effect<String, AppIconError>) {
        self.setIcon = setIcon
    }
}

public struct AppIconError: Error, Equatable {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}

public extension AppIconClient {
    static let live = AppIconClient { name in
            .future { callback in
                UIApplication.shared.setAlternateIconName(name) { error in
                    if let error = error {
                        callback(.failure(.init(message: error.localizedDescription)))
                    }
                    callback(.success(""))
                }
            }
    }
}
