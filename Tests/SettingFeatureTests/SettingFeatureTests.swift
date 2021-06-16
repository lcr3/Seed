//
//  SettingFratureTests.swift
//  
//
//  Created by lcr on 2021/06/16.
//  
//

import ComposableArchitecture
//import FirebaseApiClient
import SettingFeature
import XCTest

class SeedFeatureTests: XCTestCase {

    func testToggleIsUseSystemFontSize() {
        // setup
        let store = TestStore(
            initialState: SettingState(),
            reducer: settingReducer,
            environment: SettingEnvironment(
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        // execute
        store.send(.toggleIsUseSystemFontSize) {
            $0.isUseSystemFontSize = false
            $0.fontSizePoint = SettingState.defaultFontSizePoint
        }

        store.send(.sliderFontSizeChanged(3.0)) {
            $0.fontSizePoint = 3.0
        }

        store.send(.toggleIsUseSystemFontSize) {
            $0.isUseSystemFontSize = true
            $0.fontSizePoint = SettingState.defaultFontSizePoint
        }
    }

    func testChangeIcon() {
        let store = TestStore(
            initialState: IconMenuState(),
            reducer: iconMenuReducer,
            environment: IconMenuEnvironment(
                mainQueue: .immediate.eraseToAnyScheduler(),
                client: .mock
            )
        )

        // 現在設定されているIconを取得
        store.send(.getSelectedIcon) {
            $0.selectedIconFlavor = .light
        }

        // darkに変更
        store.send(.select(.dark))

        // レスポンス
        store.receive(.changeIcon(.success(.dark))) {
            $0.selectedIconFlavor = .dark
        }

        // lightに変更
        store.send(.select(.light))

        // レスポンス
        store.receive(.changeIcon(.success(.light))) {
            $0.selectedIconFlavor = .light
        }
    }

    func testFailureChangeIcon() {
        let store = TestStore(
            initialState: IconMenuState(),
            reducer: iconMenuReducer,
            environment: IconMenuEnvironment(
                mainQueue: .immediate.eraseToAnyScheduler(),
                client: .failure
            )
        )

        // darkに変更
        store.send(.select(.dark))

        // レスポンス
        store.receive(.changeIcon(.failure(.init(message: "change icon error")))) {
            $0.selectedIconFlavor = .light
        }
    }
}

private extension AppIconClient {
    static let mock = AppIconClient { iconFlavor in
            .future { callback in
                callback(.success(iconFlavor))
            }
    }

    static let failure = AppIconClient { IconFlavor in
            .future { callback in
                callback(.failure(.init(message: "change icon error")))
            }
    }
}
