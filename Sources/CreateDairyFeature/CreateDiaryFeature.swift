//
//  CreateDiaryFeature.swift
//  Seed
//
//  Created by lcr on 2021/05/09.
//
//

import ComposableArchitecture
import Firebase
import FirebaseApiClient
import SwiftUI

public struct CreateDairyState: Equatable {
    public var documentId: String
    public var title: String
    public var content: String
    public var selectedSegment: Diary.ContentType
    public var segments: [Diary.ContentType]

    public init() {
        documentId = ""
        title = ""
        content = ""
        segments = [.memo, .ep]
        selectedSegment = .memo
    }
}

public enum CreateDairyAction: Equatable {
    case tapSegment(Diary.ContentType)
    case changeTitle(String)
    case changeContent(String)
    case create
    case update
    case createResponse(Result<String, FirebaseApiClient.ApiFailure>)
    case updateResponse(Result<String, FirebaseApiClient.ApiFailure>)
}

public struct CreateDairyEnvironment {
    var client: FirebaseApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(client: FirebaseApiClient, mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.client = client
        self.mainQueue = mainQueue
    }
}

public let createDairyReducer = Reducer<CreateDairyState, CreateDairyAction, CreateDairyEnvironment> { state, action, environment in
    switch action {
    case let .tapSegment(type):
        state.selectedSegment = type
        return .none
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
        if state.title.isEmpty, state.content.isEmpty {
            // delete
            return .none
        }
        let newDiary = Diary(
            id: state.documentId,
            title: state.title,
            content: state.content,
            userId: 1,
            createdAt: Date()
        )
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
