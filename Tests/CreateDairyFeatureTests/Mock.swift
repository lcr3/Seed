//
//  File.swift
//
//
//  Created by lcr on 2021/06/04.
//
//

import ComposableArchitecture
import CreateDairyFeature
import FirebaseApiClient

extension CreateDiaryView {
    static var preview = CreateDiaryView(
        store: Store(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: FirebaseApiClient.mock,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
    )
}

extension FirebaseApiClient {
    static let successCreate = FirebaseApiClient {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _ in
        .future { callback in
            callback(.success("documentId"))
        }
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { _ in
        .failing("\(Self.self).update is not implemented")
    }

    static let failureCreate = FirebaseApiClient {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _ in
        .future { callback in
            callback(.failure(FirebaseApiClient.ApiFailure(message: "Failure create")))
        }
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { _ in
        .failing("\(Self.self).update is not implemented")
    }

    static let successUpdate = FirebaseApiClient {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _ in
        .failing("\(Self.self).create is not implemented")
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { _ in
        .future { callback in
            callback(.success("documentId"))
        }
    }

    static let failureUpdate = FirebaseApiClient {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _ in
        .failing("\(Self.self).create is not implemented")
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { _ in
        .future { callback in
            callback(.failure(FirebaseApiClient.ApiFailure(message: "Failure update")))
        }
    }
}
