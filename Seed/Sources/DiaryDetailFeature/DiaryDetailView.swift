//
//  DiaryDetailView.swift
//  Seed
//
//  Created by lcr on 2021/05/11.
//  
//

import ComposableArchitecture
import SwiftUI

struct DiaryDetailState: Equatable {
    public var diary: Diary
    public var editedTitle: String
    public var editedContent: String

    init(diary: Diary) {
        self.diary = diary
        self.editedTitle = diary.title
        self.editedContent = diary.content
    }
}

enum DiaryDetailAction: Equatable {
    case editTitle(String)
    case editContent(String)
    case sheetButtonTapped
    case save
    case saveResponse(Result<String, FirebaseApiClient.ApiFailure>)
    case deleteResponse(Result<String, FirebaseApiClient.ApiFailure>)
}

struct DiaryDetailEnvironment {
    var client: FirebaseApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let diaryDetailReducer = Reducer<DiaryDetailState, DiaryDetailAction, DiaryDetailEnvironment> { state, action, environment in
    switch action {
    case let .editTitle(title):
        state.editedTitle = title
        return .none
    case let .editContent(content):
        state.editedContent = content
        return .none
    case .sheetButtonTapped:
        // show action sheet
        return .none
    case .save:
        if state.editedTitle.isEmpty && state.editedContent.isEmpty, let id = state.diary.id {
            return environment.client
                .delete(id)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(DiaryDetailAction.deleteResponse)
        }
        let updateDiary = Diary(
            id: state.diary.id,
            title: state.editedTitle,
            content: state.editedContent,
            userId: state.diary.userId,
            createdAt: state.diary.createdAt
        )
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

struct DiaryDetailView: View {
    @Environment(\.presentationMode) @Binding var presentationMode
    let store: Store<DiaryDetailState, DiaryDetailAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                HStack {
                    Text("Title")
                    TextField(
                        "",
                        text: viewStore.binding(
                            get: \.editedTitle,
                            send: DiaryDetailAction.editTitle
                        )
                    )
                    .multilineTextAlignment(.trailing)
                }
                Section(header: Text("Contents")) {
                    TextEditor(
                        text: viewStore.binding(
                            get: \.editedContent,
                            send: DiaryDetailAction.editContent
                        )
                    )
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onDisappear {
                viewStore.send(DiaryDetailAction.save)
            }
        }
    }
}

struct DiaryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryDetailView.preview
        DiaryDetailView.preview.environment(\.colorScheme, .dark)
    }
}
