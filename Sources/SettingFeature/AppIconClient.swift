//
//  AppIconClient.swift
//
//
//  Created by lcr on 2021/06/11.
//
//

import ComposableArchitecture
import SwiftUI

public enum IconFlavor: String, CaseIterable, Identifiable {
    case light = "Light" // default
    case dark = "Dark"

    public var id: String { rawValue }

    static func defaultIcon() -> Self {
        return .light
    }

    init(value: String) {
        if value == IconFlavor.dark.rawValue {
            self = .dark
        } else {
            self = .light
        }
    }
}

public class AppIconClient {
    public var setIcon: (_ name: IconFlavor) -> Effect<IconFlavor, AppIconError>
    public var iconName: IconFlavor {
        if let name = UIApplication.shared.alternateIconName {
            return .init(value: name)
        }
        return .defaultIcon()
    }

    public init(setIcon: @escaping (IconFlavor) -> Effect<IconFlavor, AppIconError>) {
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
    static let live = AppIconClient(setIcon: { iconFlavor in
        .future { callback in
            UIApplication.shared.setAlternateIconName(iconFlavor.rawValue) { error in
                if let error = error {
                    callback(.failure(.init(message: "file: \(iconFlavor.rawValue) \(error.localizedDescription)")))
                }
                callback(.success(iconFlavor))
            }
        }
    })
}
