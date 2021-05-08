//
//  Seed.swift
//  Seed
//
//  Created by lcr on 2021/05/08.
//  
//

import ComposableArchitecture
import Foundation

struct SeedState: Equatable {
    var diaries: [Diary] = []
}

enum SeedAction: Equatable {
    case showNewDiary
    case fetchDiaries
    case fetchResponse(Result<[Diary], FirebaseApiClient.ApiFailure>)

}

struct SeedEnvironment {
    var client: FirebaseApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let seedReducer = Reducer<SeedState, SeedAction, SeedEnvironment> { state, action, environment in
    switch action {
    case .showNewDiary:
        return .none
    case .fetchDiaries:
        return environment.client
            .fetchDiaries()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(SeedAction.fetchResponse)
    case let .fetchResponse(.success(diaries)):
        state.diaries = diaries
        return .none
    case let .fetchResponse(.failure(failure)):
        print("error")
        return .none
    }
}
