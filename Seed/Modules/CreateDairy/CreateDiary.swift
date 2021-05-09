//
//  CreateDiary.swift
//  Seed
//
//  Created by lcr on 2021/05/09.
//  
//

import ComposableArchitecture

struct CreateDairyState: Equatable {
    var isLoading = false
    var creationCompleted = false
}

enum CreateDairyAction: Equatable {
    case create(Diary)
    case createResponse(Result<Bool, FirebaseApiClient.ApiFailure>)
}

struct CreateDairyEnvironment {
    var client: FirebaseApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let createDairyReducer = Reducer<CreateDairyState, CreateDairyAction, CreateDairyEnvironment> { state, action, environment in
    switch action {
    case let .create(diary):
        state.isLoading = true
        return environment.client
            .create(diary)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(CreateDairyAction.createResponse)
    case let .createResponse(.success(result)):
        state.isLoading = false
        state.creationCompleted = true
        return .none
    case let .createResponse(.failure(failure)):
        state.isLoading = false
        return .none
    }

}
