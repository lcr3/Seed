//
//  SeedView.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import ComposableArchitecture
import SwiftUI

struct SeedState: Equatable {
    public var diaries: [Diary]
    public var filteredDiaries: [Diary] {
        if searchText.isEmpty {
            return diaries
        }
        return diaries.filter {
            $0.title.contains(searchText) || $0.content.contains(searchText)
        }
    }
    public var searchText: String
    public var deleteDiaryAlertState: DeleteDiaryAlertState
    public var isSearching: Bool

    public init(deleteDiaryAlertState: DeleteDiaryAlertState) {
        diaries = []
        searchText = ""
        isSearching = false
        self.deleteDiaryAlertState = deleteDiaryAlertState
    }
}

enum SeedAction: Equatable {
    case deleteButtonTapped(Int)
    case startObserve
    case chageSearchText(String)
    case resetSearchText
    case updateDiaries(Result<[Diary], FirebaseApiClient.ApiFailure>)
    case deleteResponse(Result<String, FirebaseApiClient.ApiFailure>)
    case deleteAlert(DeleteDiaryAlertAction)
}

struct SeedEnvironment {
    var client: FirebaseApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let seedReducer = Reducer<SeedState, SeedAction, SeedEnvironment> { state, action, environment in
    switch action {
    case let .chageSearchText(text):
        state.searchText = text
        state.isSearching = !state.searchText.isEmpty
        return .none
    case .resetSearchText:
        state.searchText = ""
        state.isSearching = false
        return .none
    case .startObserve:
        return environment.client
            .updateSnapshot()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(SeedAction.updateDiaries)
    case let .updateDiaries(.success(diaries)):
        state.diaries = diaries
        return .none
    case let .updateDiaries(.failure(failure)):
        print("error: \(failure)")
        return .none
    case let .deleteButtonTapped(index):
        let targetDiary = state.diaries[index]
        guard let documentId = targetDiary.id else {
            fatalError("Document id is empty.")
        }
        state.deleteDiaryAlertState.documentId = documentId
        state.deleteDiaryAlertState.alert = .init(
            title: TextState("⚠削除してもよろしいですか?"),
            message: TextState(targetDiary.title),
            primaryButton: .default(.init("OK"),
                                    send: .okButtonTapped),
            secondaryButton: .cancel()
        )
        return .none
    case let .deleteResponse(.success(documentId)):
        state.deleteDiaryAlertState.documentId = ""
        return .none
    case let .deleteResponse(.failure(error)):
        state.deleteDiaryAlertState.documentId = ""
        return .none
    case .deleteAlert(let action):
        switch action {
        case .okButtonTapped:
            state.deleteDiaryAlertState.alert = nil
            return environment.client
                .delete(state.deleteDiaryAlertState.documentId)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SeedAction.deleteResponse)
        case .cancelButtonTapped:
            state.deleteDiaryAlertState.alert = nil
            return .none
        case .dismissAlert:
            state.deleteDiaryAlertState.alert = nil
            return .none
        }
    }
}

struct SeedView: View {
    init(store: Store<SeedState, SeedAction>) {
        self.store = store
        ViewStore(store).send(.startObserve)
    }
    private var isSearch = false
    let store: Store<SeedState, SeedAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    List {
                        Section {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.systemGray)
                                    .padding(.leading, -12)
                                TextField("検索",
                                          text: viewStore.binding(
                                            get: \.searchText,
                                            send: SeedAction.chageSearchText)
                                )
                            }
                            .overlay(
                                HStack {
                                    Spacer()
                                    if viewStore.state.isSearching {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.systemGray)
                                            .onTapGesture {
                                                ViewStore(store).send(SeedAction.resetSearchText)
                                            }
                                    }
                                }
                            )
                        }
                        Section(header: HStack {
                            Text("Diary")
                            Spacer()
                            NavigationLink(
                                destination: CreateDiaryView(
                                    store: Store(
                                        initialState: CreateDairyState(),
                                        reducer: createDairyReducer,
                                        environment: CreateDairyEnvironment(
                                            client: FirebaseApiClient.live,
                                            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                                        )
                                    )
                                )
                            ) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.body)
                            }
                        }) {
                            ForEach(viewStore.state.filteredDiaries, id: \.self) { diary in
                                NavigationLink(
                                    destination: DiaryDetailView(
                                        store: Store(
                                            initialState: DiaryDetailState(diary: diary),
                                            reducer: diaryDetailReducer,
                                            environment: DiaryDetailEnvironment(
                                                client: FirebaseApiClient.live,
                                                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                                            )
                                        )
                                    ),
                                    label: {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(diary.title)
                                                .bold()
                                            Text(diary.content)
                                                .font(.caption)
                                                .lineLimit(1)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.bottom, 8)
                                        .padding(.top, 8)
                                    }
                                )
                                .contextMenu(
                                    menuItems: {
                                        HStack {
                                            Text(diary.title)
                                            Text(diary.content)
                                        }
                                    }
                                )
                            }.onDelete { offsets in
                                guard let index = offsets.first else { return }
                                ViewStore(store).send(.deleteButtonTapped(index))
                            }
                        }
                    }.animation(.easeIn)
                    .listStyle(InsetGroupedListStyle())
                }
                .alert(
                    store.scope(
                        state: { $0.deleteDiaryAlertState.alert },
                        action: SeedAction.deleteAlert
                    ),
                    dismiss: DeleteDiaryAlertAction.dismissAlert
                )
                .navigationTitle("Seed")
            }
        }
    }
}

struct SeedView_Previews: PreviewProvider {
    static var previews: some View {
        SeedView.preview
        SeedView.preview.environment(\.colorScheme, .dark)
    }
}
