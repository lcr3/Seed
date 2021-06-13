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
    public var setIcon: (_ name: String?) -> Effect<String?, AppIconError>
    public var iconName: String?

    public init(setIcon: @escaping (String?) -> Effect<String?, AppIconError>,
        iconName: String?) {
            self.setIcon = setIcon
            self.iconName = UIApplication.shared.alternateIconName
    }
}

public struct AppIconError: Error, Equatable {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}

public extension AppIconClient {
    static let live = AppIconClient(setIcon: { name in
            .future { callback in
                UIApplication.shared.setAlternateIconName(name) { error in
                    if let error = error {
                        callback(.failure(.init(message: "file: \(name) \(error.localizedDescription)")))
                    }
                    callback(.success(name))
                }
            }
    }, iconName: UIApplication.shared.alternateIconName)
}
