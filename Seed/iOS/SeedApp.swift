//
//  SeedApp.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//
//

import ComposableArchitecture
import Firebase
import FirebaseApiClient
import SeedFeature
import SwiftUI

@main
struct SeedApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SeedView(
                store: .init(
                    initialState: .init(),
                    reducer: seedReducer,
                    environment: .init(
                        client: .live,
                        mainQueue: .main.eraseToAnyScheduler()
                    )
                )
            )
        }
    }
}
