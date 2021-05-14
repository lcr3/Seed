//
//  Seed.swift
//  Seed
//
//  Created by lcr on 2021/05/08.
//  
//

import ComposableArchitecture
import Foundation

struct SeedState: Equatable {
    public var diaries: [Diary]
    public var deleteDiaryAlertState: DeleteDiaryAlertState

    public init(deleteDiaryAlertState: DeleteDiaryAlertState) {
        diaries = []
        self.deleteDiaryAlertState = deleteDiaryAlertState
    }
}

enum SeedAction: Equatable {
    case deleteButtonTapped(Int)
    case startObserve
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
    case .deleteAlert(.okButtonTapped):
        state.deleteDiaryAlertState.alert = nil
        return environment.client
            .delete(state.deleteDiaryAlertState.documentId)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(SeedAction.deleteResponse)
    case .deleteAlert(.cancelButtonTapped):
        state.deleteDiaryAlertState.alert = nil
        return .none
    case .deleteAlert(.dismissAlert):
        state.deleteDiaryAlertState.alert = nil
        return .none
    }
}
