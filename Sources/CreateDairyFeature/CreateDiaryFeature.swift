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
    public var when: String
    public var where_: String
    public var who: String
    public var why: String
    public var how: String
    public var happened: String

    public var selectedSegment: Diary.ContentType
    public var segments: [Diary.ContentType]

    public var isEmpty: Bool {
        if selectedSegment.isMemo, title.isEmpty, content.isEmpty {
            return true
        }
        if selectedSegment.isEp, title.isEmpty, when.isEmpty, where_.isEmpty, who.isEmpty, why.isEmpty, how.isEmpty, happened.isEmpty {
            return true
        }
        return false
    }

    public init() {
        documentId = ""
        title = ""
        content = ""
        segments = [.memo, .ep]
        selectedSegment = .memo
        when = ""
        where_ = ""
        who = ""
        why = ""
        how = ""
        happened = ""
    }
}

public enum CreateDairyAction: Equatable {
    case tapSegment(Diary.ContentType)
    case changeTitle(String)
    case changeContent(String)
    case changeWhen(String)
    case changeWhere(String)
    case changeWho(String)
    case changeWhy(String)
    case changeHow(String)
    case changeHappened(String)
    case create
    case createResponse(Result<String, FirebaseApiClient.ApiFailure>)
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
    case let .changeWhen(text):
        state.when = text
        return .none
    case let .changeWhere(text):
        state.where_ = text
        return .none
    case let .changeWho(text):
        state.who = text
        return .none
    case let .changeWhy(text):
        state.why = text
        return .none
    case let .changeHow(text):
        state.how = text
        return .none
    case let .changeHappened(text):
        state.happened = text
        return .none
    case .create:
        if state.isEmpty {
            return .none
        }
        let diary: Diary
        if state.selectedSegment.isMemo {
            diary = Diary(
                title: state.title,
                content: state.content,
                userId: 1,
                type: Diary.ContentType.memo.rawValue
            )
        } else {
            diary = Diary(
                title: state.title,
                userId: 1,
                type: Diary.ContentType.ep.rawValue,
                when: state.when,
                where_: state.where_,
                who: state.who,
                why: state.why,
                how: state.how,
                happened: state.happened
            )
        }
        return environment.client
            .create(diary)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(CreateDairyAction.createResponse)
    case let .createResponse(.success(documentId)):
        state.documentId = documentId
        return .none
    case let .createResponse(.failure(failure)):
        return .none
    }
}
