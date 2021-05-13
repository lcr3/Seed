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
    public var showCreateDiary: Bool
    public var deleteDiaryAlertState: DeleteDiaryAlertState

    public init(deleteDiaryAlertState: DeleteDiaryAlertState) {
        diaries = []
        showCreateDiary = false
        self.deleteDiaryAlertState = deleteDiaryAlertState
    }
}

enum SeedAction: Equatable {
    case addButtonTapped
    case deleteButtonTapped(Int)
    case showedNewDiary
    case fetchDiaries
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
    case .addButtonTapped:
        state.showCreateDiary = true
        return .none
    case .showedNewDiary:
        state.showCreateDiary = false
        return .none
    case .fetchDiaries:
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
            fatalError("")
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
        let deleteDiaryIndex = state.diaries.firstIndex {
            $0.id == documentId
        }
        guard let wrapIndex = deleteDiaryIndex else {
            fatalError("Not found delete diary index")
        }
        state.diaries.remove(at: wrapIndex)
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
