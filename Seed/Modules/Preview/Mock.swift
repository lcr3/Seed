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

extension CreateDiaryView {
    static var preview = CreateDiaryView(
        store: Store(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: FirebaseApiClient.mock,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
    )
}
