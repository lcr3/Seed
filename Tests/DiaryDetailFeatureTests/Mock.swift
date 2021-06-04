//
//  Mock.swift
//  
//
//  Created by lcr on 2021/06/04.
//  
//

import ComposableArchitecture
import FirebaseApiClient

extension FirebaseApiClient {
    static let successCreate = FirebaseApiClient {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _, _, _ in
        .future { callback in
            callback(.success("documentId"))
        }
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { diary in
        .failing("\(Self.self).update is not implemented")
    }

    static let failureCreate = FirebaseApiClient {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _, _, _ in
        .future { callback in
            callback(.failure(FirebaseApiClient.ApiFailure(message: "Failure create")))
        }
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { diary in
        .failing("\(Self.self).update is not implemented")
    }

    static let successUpdate = FirebaseApiClient {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _, _, _ in
        .failing("\(Self.self).create is not implemented")
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { diary in
        .future { callback in
            callback(.success("documentId"))
        }
    }

    static let failureUpdate = FirebaseApiClient {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _, _, _ in
        .failing("\(Self.self).create is not implemented")
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { diary in
        .future { callback in
            callback(.failure(FirebaseApiClient.ApiFailure(message: "Failure update")))
        }
    }

    static let successDelete = FirebaseApiClient() {
            .failing("\(Self.self).snapshot is not implemented")
        } create: { _, _, _ in
            .failing("\(Self.self).create is not implemented")
        } delete: { _ in
            .future { callback in
                callback(.success("deleteDocumentId"))
            }
        } update: { diary in
            .failing("\(Self.self).update is not implemented")
        }

        static let failureDelete = FirebaseApiClient() {
            .failing("\(Self.self).snapshot is not implemented")
        } create: { _, _, _ in
            .failing("\(Self.self).create is not implemented")
        } delete: { _ in
            .future { callback in
                callback(.failure(ApiFailure(message: "Failure delete")))
            }
        } update: { diary in
            .failing("\(Self.self).update is not implemented")
        }
}
