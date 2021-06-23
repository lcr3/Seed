//
//  Mock.swift
//
//
//  Created by lcr on 2021/06/04.
//
//

import Combine
import ComposableArchitecture
import FirebaseApiClient

extension FirebaseApiClient {
    static let successSnapshot = FirebaseApiClient {
        .run { subscriber in
            subscriber.send([
                Diary(title: "response",
                      content: "response",
                      userId: 1,
                      createdAt: Date(timeIntervalSince1970: TimeInterval(1_423_053_296))),
            ])
            return AnyCancellable {}
        }
    } create: { _, _, _ in
        .failing("\(Self.self).create is not implemented")
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { _ in
        .failing("\(Self.self).delete is not implemented")
    }

    static let failureSnapshot = FirebaseApiClient {
        .run { subscriber in
            subscriber.send(completion: .failure(ApiFailure(message: "mock error")))
            return AnyCancellable {}
        }
    } create: { _, _, _ in
        .failing("\(Self.self).create is not implemented")
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { _ in
        .failing("\(Self.self).update is not implemented")
    }

    static let successDelete = FirebaseApiClient {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _, _, _ in
        .failing("\(Self.self).create is not implemented")
    } delete: { _ in
        .future { callback in
            callback(.success("deleteDocumentId"))
        }
    } update: { _ in
        .failing("\(Self.self).update is not implemented")
    }

    static let failureDelete = FirebaseApiClient {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _, _, _ in
        .failing("\(Self.self).create is not implemented")
    } delete: { _ in
        .future { callback in
            callback(.failure(ApiFailure(message: "Failure delete")))
        }
    } update: { _ in
        .failing("\(Self.self).update is not implemented")
    }
}
