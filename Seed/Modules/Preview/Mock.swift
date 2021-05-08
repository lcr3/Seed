//
//  Mock.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import ComposableArchitecture
import SwiftUI

extension SeedView {
    static var preview = SeedView(
        store: Store(
            initialState: SeedState(),
            reducer: seedReducer,
            environment: SeedEnvironment(
                client: FirebaseApiClient.mock,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
    )
}

extension DialySectionHeader {
    static var preview = Self("Dialy") {
    }
}
