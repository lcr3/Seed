//
//  SeedFeature.swift
//  
//
//  Created by lcr on 2021/06/18.
//  
//

import ComposableArchitecture
import FirebaseApiClient

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
