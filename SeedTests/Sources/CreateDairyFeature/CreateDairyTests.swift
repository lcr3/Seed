//
//  CreateDairyTests.swift
//  SeedTests
//
//  Created by lcr on 2021/05/26.
//  
//

import Combine
import ComposableArchitecture
import Firebase
import XCTest

@testable import Seed

class CreateDairyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChangeTitle() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .mock,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
            )
        )
        let changeTitle = "title"

        // execute
        store.send(.changeTitle(changeTitle)) {
            // verify
            $0.title = changeTitle
        }
    }

    func testChangeContent() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .mock,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
            )
        )
        let changeContent = "content"

        // execute
        store.send(.changeContent(changeContent)) {
            // verify
            $0.content = changeContent
        }
    }

    func testSuccessCreate() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .successCreate,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
            )
        )
        let response = "documentId"

        // execute
        store.send(.create)

        // verify
        store.receive(.createResponse(.success(response))) {
            $0.documentId = response
        }
    }

    func testFailureCreate() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .failureCreate,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
            )
        )

        // execute
        store.send(.create)

        // verify
        store.receive(.createResponse(.failure(.init(message: "Failure create"))))
    }

    func testNoDataUpdate() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .successUpdate,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
            )
        )

        // verify
        store.send(.update)
    }

    func testSuccessUpdate() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .successUpdate,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
            )
        )
        let changeTitle = "title"
        let changeContent = "content"
        let response = "documentId"

        // execute
        store.send(.changeTitle(changeTitle)) {
            $0.title = changeTitle
        }
        store.send(.changeContent(changeContent)) {
            $0.content = changeContent
        }
        store.send(.update)

        //verify
        store.receive(.updateResponse(.success(response)))
    }

    func testFailureUpdate() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .failureUpdate,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
            )
        )
        let changeTitle = "title"
        let changeContent = "content"

        // execute
        store.send(.changeTitle(changeTitle)) {
            $0.title = changeTitle
        }
        store.send(.changeContent(changeContent)) {
            $0.content = changeContent
        }
        store.send(.update)

        // verify
        store.receive(.updateResponse(.failure(.init(message: "Failure update"))))
    }

}

extension FirebaseApiClient {
    static let successCreate = FirebaseApiClient() {
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

    static let failureCreate = FirebaseApiClient() {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _, _, _ in
        .future { callback in
            callback(.failure(ApiFailure(message: "Failure create")))
        }
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { diary in
        .failing("\(Self.self).update is not implemented")
    }

    static let successUpdate = FirebaseApiClient() {
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

    static let failureUpdate = FirebaseApiClient() {
        .failing("\(Self.self).snapshot is not implemented")
    } create: { _, _, _ in
        .failing("\(Self.self).create is not implemented")
    } delete: { _ in
        .failing("\(Self.self).delete is not implemented")
    } update: { diary in
        .future { callback in
            callback(.failure(ApiFailure(message: "Failure update")))
        }
    }
}
