//
//  CreateDairyFeatureTests.swift
//  Tests
//
//  Created by lcr on 2021/05/26.
//
//

import ComposableArchitecture
import CreateDairyFeature
import FirebaseApiClient
import XCTest

class CreateDairyFeatureTests: XCTestCase {
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
                mainQueue: .immediate.eraseToAnyScheduler()
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
                mainQueue: .immediate.eraseToAnyScheduler()
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
                mainQueue: .immediate.eraseToAnyScheduler()
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
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        // execute
        store.send(CreateDairyAction.create)

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
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        // verify
        store.send(CreateDairyAction.update)
    }

    func testSuccessUpdate() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .successUpdate,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )
        let changeTitle = "title"
        let changeContent = "content"
        let response = "documentId"

        // execute
        store.send(CreateDairyAction.changeTitle(changeTitle)) {
            $0.title = changeTitle
        }
        store.send(CreateDairyAction.changeContent(changeContent)) {
            $0.content = changeContent
        }
        store.send(CreateDairyAction.update)

        // verify
        store.receive(.updateResponse(.success(response)))
    }

    func testFailureUpdate() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .failureUpdate,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )
        let changeTitle = "title"
        let changeContent = "content"

        // execute
        store.send(CreateDairyAction.changeTitle(changeTitle)) {
            $0.title = changeTitle
        }
        store.send(CreateDairyAction.changeContent(changeContent)) {
            $0.content = changeContent
        }
        store.send(CreateDairyAction.update)

        // verify
        store.receive(.updateResponse(.failure(.init(message: "Failure update"))))
    }
}
