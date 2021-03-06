//
//  DiaryDetailView.swift
//  Seed
//
//  Created by lcr on 2021/05/11.
//
//

import ComposableArchitecture
import FirebaseApiClient
import SwiftUI

public struct DiaryDetailState: Equatable {
    public var diary: Diary
    public var editedTitle: String
    public var editedContent: String
    public var editedWhen: String
    public var editedWhere: String
    public var editedWho: String
    public var editedWhy: String
    public var editedHow: String
    public var editedHappened: String

    public init(diary: Diary) {
        self.diary = diary
        editedTitle = diary.title
        editedContent = diary.content
        editedWhen = diary.when
        editedWhere = diary.where_
        editedWho = diary.who
        editedWhy = diary.why
        editedHow = diary.how
        editedHappened = diary.happened
    }
}

public enum DiaryDetailAction: Equatable {
    case editTitle(String)
    case editContent(String)
    case editWhen(String)
    case editWhere(String)
    case editWho(String)
    case editWhy(String)
    case editHow(String)
    case editHappened(String)
    case sheetButtonTapped
    case save
    case saveResponse(Result<String, FirebaseApiClient.ApiFailure>)
    case deleteResponse(Result<String, FirebaseApiClient.ApiFailure>)
}

public struct DiaryDetailEnvironment {
    var client: FirebaseApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(client: FirebaseApiClient, mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.client = client
        self.mainQueue = mainQueue
    }
}

public let diaryDetailReducer = Reducer<DiaryDetailState, DiaryDetailAction, DiaryDetailEnvironment> { state, action, environment in
    switch action {
    case let .editTitle(title):
        state.editedTitle = title
        return .none
    case let .editContent(content):
        state.editedContent = content
        return .none
    case let .editWhen(text):
        state.editedWhen = text
        return .none
    case let .editWhere(text):
        state.editedWhere = text
        return .none
    case let .editWho(text):
        state.editedWho = text
        return .none
    case let .editWhy(text):
        state.editedWhy = text
        return .none
    case let .editHow(text):
        state.editedHow = text
        return .none
    case let .editHappened(text):
        state.editedHappened = text
        return .none
    case .sheetButtonTapped:
        // show action sheet
        return .none
    case .save:
        if state.diary.isMemo, state.editedTitle.isEmpty, state.editedContent.isEmpty, let id = state.diary.id {
            return environment.client
                .delete(id)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(DiaryDetailAction.deleteResponse)
        } else if !state.diary.isMemo, state.editedTitle.isEmpty, state.editedWhen.isEmpty, state.editedWhere.isEmpty, state.editedWho.isEmpty, state.editedWhy.isEmpty, state.editedHow.isEmpty, state.editedHappened.isEmpty, let id = state.diary.id {
            return environment.client
                .delete(id)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(DiaryDetailAction.deleteResponse)
        }
        let updateDiary: Diary
        if state.diary.isMemo {
            updateDiary = Diary(
                id: state.diary.id,
                title: state.editedTitle,
                content: state.editedContent,
                createdAt: state.diary.createdAt,
                type: Diary.ContentType.memo.rawValue,
                when: "",
                where_: "",
                who: "",
                why: "",
                how: "",
                happened: ""
            )
        } else {
            updateDiary = Diary(
                id: state.diary.id,
                title: state.editedTitle,
                content: "",
                userId: state.diary.userId,
                createdAt: state.diary.createdAt,
                type: Diary.ContentType.ep.rawValue,
                when: state.editedWhen,
                where_: state.editedWhere,
                who: state.editedWho,
                why: state.editedWhy,
                how: state.editedHow,
                happened: state.editedHappened
            )
        }
        return environment.client
            .update(updateDiary)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(DiaryDetailAction.saveResponse)
    case let .saveResponse(.success(documentId)):
        print("success saved")
        return .none
    case let .saveResponse(.failure(error)):
        print("failure saved")
        return .none
    case let .deleteResponse(.success(documentId)):
        print("success delete")
        return .none
    case let .deleteResponse(.failure(error)):
        print("failure delete")
        return .none
    }
}
