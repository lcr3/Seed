//
//  SeedView.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import Component
import ComposableArchitecture
import CreateDairyFeature
import DiaryDetailFeature
import FirebaseApiClient
import SettingFeature
import SwiftUI

public struct SeedState: Equatable {
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
    public var isSearching: Bool

    public init() {
        diaries = []
        searchText = ""
        isSearching = false
    }
}

public enum SeedAction: Equatable {
    case deleteButtonTapped(Int)
    case startObserve
    case chageSearchText(String)
    case resetSearchText
    case updateDiaries(Result<[Diary], FirebaseApiClient.ApiFailure>)
    case deleteResponse(Result<String, FirebaseApiClient.ApiFailure>)
}

public struct SeedEnvironment {
    var client: FirebaseApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(client: FirebaseApiClient, mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.client = client
        self.mainQueue = mainQueue
    }
}

public let seedReducer = Reducer<SeedState, SeedAction, SeedEnvironment> { state, action, environment in
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
        return environment.client
            .delete(documentId)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(SeedAction.deleteResponse)
    case let .deleteResponse(.success(documentId)):
        return .none
    case let .deleteResponse(.failure(error)):
        return .none
    }
}

public struct SeedView: View {
    public init(store: Store<SeedState, SeedAction>) {
        self.store = store
        ViewStore(store).send(.startObserve)
    }

    private let store: Store<SeedState, SeedAction>
    private var isSearch = false
    @State var isSetting = false

    public var body: some View {
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
                                    store: .init(
                                        initialState: .init(),
                                        reducer: createDairyReducer,
                                        environment: .init(
                                            client: .live,
                                            mainQueue: .main.eraseToAnyScheduler()
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
                                        store: .init(
                                            initialState: .init(diary: diary),
                                            reducer: diaryDetailReducer,
                                            environment: .init(
                                                client: .live,
                                                mainQueue: .main.eraseToAnyScheduler()
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
                .sheet(isPresented: $isSetting) {
                    SettingView(
                        store: .init(
                            initialState: .init(),
                            reducer: settingReducer,
                            environment: .init(
                                mainQueue: .main.eraseToAnyScheduler()
                            )
                        )
                    )
                }
                .navigationBarItems(
                    leading: HStack {
                        Spacer()
                        Button(action: {
                            isSetting = true
                        }) {
                            Image(systemName: "gearshape")
                        }
                    }
                )
            }
        }
    }

    func didDismiss() {

    }
}

//struct SeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeedView.preview
//        SeedView.preview.environment(\.colorScheme, .dark)
//    }
//}