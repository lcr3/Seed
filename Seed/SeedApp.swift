//
//  SeedApp.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import ComposableArchitecture
import Firebase
import SwiftUI

@main
struct SeedApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SeedView(
                store: Store(initialState: SeedState(),
                             reducer: seedReducer,
                             environment: SeedEnvironment(
                                client: FirebaseApiClient.live,
                                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                             )
                )
            )
        }
    }
}
