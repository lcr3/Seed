//
//  CreateDiary.swift
//  Seed
//
//  Created by lcr on 2021/05/09.
//  
//

import ComposableArchitecture
import Firebase

struct CreateDairyState: Equatable {
    var title: String
    var content: String

    init() {
        title = ""
        content = ""
    }
}

enum CreateDairyAction: Equatable {
    case changeTitle(String)
    case changeContent(String)
    case create
    case createResponse(Result<Bool, FirebaseApiClient.ApiFailure>)
}

struct CreateDairyEnvironment {
    var client: FirebaseApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let createDairyReducer = Reducer<CreateDairyState, CreateDairyAction, CreateDairyEnvironment> { state, action, environment in
    switch action {
    case let .changeTitle(title):
        state.title = title
        return .none
    case let .changeContent(content):
        state.content = content
        return .none
    case .create:
        if state.title.isEmpty && state.content.isEmpty {
            return .none
        }
        let newDiary = Diary(
            title: state.title,
            content: state.content,
            userId: 1,
            createdAt: Timestamp())
        return environment.client
            .create(newDiary)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(CreateDairyAction.createResponse)
    case let .createResponse(.success(result)):
        return .none
    case let .createResponse(.failure(failure)):
        return .none
    }
}
