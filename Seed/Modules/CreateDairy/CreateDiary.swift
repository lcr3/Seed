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
    var documentId: String
    var title: String
    var content: String

    init() {
        documentId = ""
        title = ""
        content = ""
    }
}

enum CreateDairyAction: Equatable {
    case changeTitle(String)
    case changeContent(String)
    case create
    case update
    case createResponse(Result<String, FirebaseApiClient.ApiFailure>)
    case updateResponse(Result<String, FirebaseApiClient.ApiFailure>)
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
        print("つくりやす")
        return environment.client
            .create(state.title, state.content, 1)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(CreateDairyAction.createResponse)
    case .update:
        if state.title.isEmpty && state.content.isEmpty {
            // delete
            return .none
        }
        let newDiary = Diary(
            id: state.documentId,
            title: state.title,
            content: state.content,
            userId: 1,
            createdAt: Timestamp())
        return environment.client
            .update(newDiary)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(CreateDairyAction.updateResponse)
    case let .createResponse(.success(documentId)):
        state.documentId = documentId
        return .none
    case let .createResponse(.failure(failure)):
        return .none
    case let .updateResponse(.success(result)):
        return .none
    case let .updateResponse(.failure(failure)):
        return .none
    }
}
