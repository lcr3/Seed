//
//  CreateDiaryView.swift
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
    var documentId: String
    var title: String
    var content: String

    public init() {
        documentId = ""
        title = ""
        content = ""
    }
}

public enum CreateDairyAction: Equatable {
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

public struct CreateDiaryView: View {
    public init(store: Store<CreateDairyState, CreateDairyAction>) {
        self.store = store
    }

    @Environment(\.presentationMode) @Binding var presentationMode
    let store: Store<CreateDairyState, CreateDairyAction>

    public var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Section(header: Text("Title")) {
                    TextField(
                        "What happened today...",
                        text: viewStore.binding(
                            get: \.title,
                            send: CreateDairyAction.changeTitle
                        )
                    )
                    .multilineTextAlignment(.trailing)
                }
                Section(header: Text("Contents")) {
                    TextEditor(
                        text: viewStore.binding(
                            get: \.content,
                            send: CreateDairyAction.changeContent
                        )
                    )
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(
                trailing: Button("保存") {
                    ViewStore(store).send(.create)
                    presentationMode.dismiss()
                }
            ).onAppear {
                if viewStore.state.documentId.isEmpty {
                    viewStore.send(CreateDairyAction.create)
                }
            }
        }
    }
}

//struct CreateDiaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateDiaryView.preview
//        CreateDiaryView.preview.environment(\.colorScheme, .dark)
//    }
//}
