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
        store.send(.changeWhen(changeContent)) {
            $0.when = changeContent
        }
        store.send(.changeWhere(changeContent)) {
            $0.where_ = changeContent
        }
        store.send(.changeWho(changeContent)) {
            $0.who = changeContent
        }
        store.send(.changeWhy(changeContent)) {
            $0.why = changeContent
        }
        store.send(.changeHow(changeContent)) {
            $0.how = changeContent
        }
        store.send(.changeHappened(changeContent)) {
            $0.happened = changeContent
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
        let editTitle = "Title"

        // execute
        store.send(.changeTitle(editTitle)) {
            // input title
            $0.title = editTitle
        }
        store.send(.create)

        // verify
        store.receive(.createResponse(.success(response))) {
            $0.documentId = response
        }
    }

    func testCreateMemoValidation() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .successCreate,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )
        let documentId = "documentId"
        let editTitle = "Title"

        // select segment memo
        store.send(.tapSegment(.memo)) {
            $0.selectedSegment = .memo
        }

        // execute
        store.send(.create) {
            // failed create validation
            $0.documentId = ""
        }

        store.send(.changeTitle(editTitle)) {
            // input title
            $0.title = editTitle
        }

        store.send(.create)

        // execute
        store.receive(.createResponse(.success(documentId))) {
            // success create
            $0.documentId = documentId
        }
    }

    func testCreateEpValidation() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .successCreate,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )
        let documentId = "documentId"
        let editWhen = "When"

        // select segment ep
        store.send(.tapSegment(.ep)) {
            $0.selectedSegment = .ep
        }

        // execute
        store.send(.create) {
            // failed create validation
            $0.documentId = ""
        }

        store.send(.changeWhen(editWhen)) {
            // input when
            $0.when = editWhen
        }

        store.send(.create)

        // execute
        store.receive(.createResponse(.success(documentId))) {
            // success create
            $0.documentId = documentId
        }
    }

    func testSelectSegments() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .successCreate,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        // execute verify
        store.send(.tapSegment(.ep)) {
            $0.selectedSegment = .ep
        }

        // execute verify
        store.send(.tapSegment(.memo)) {
            $0.selectedSegment = .memo
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
        let editTitle = "Title"

        // execute
        store.send(.changeTitle(editTitle)) {
            // input title
            $0.title = editTitle
        }
        store.send(CreateDairyAction.create)

        // verify
        store.receive(.createResponse(.failure(.init(message: "Failure create"))))
    }

    func testMemoIsEmpty() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .failureCreate,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        store.send(.changeTitle("")) {
            var isEmpty = $0.isEmpty
            isEmpty = true
        }

        store.send(.changeTitle("Title")) {
            $0.title = "Title"
            var isEmpty = $0.isEmpty
            isEmpty = false
        }
    }

    func testEpIsEmpty() throws {
        // setup
        let store = TestStore(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: .failureCreate,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        store.send(.tapSegment(.ep)) {
            $0.selectedSegment = .ep
        }

        store.send(.changeWhen("")) {
            var isEmpty = $0.isEmpty
            isEmpty = true
        }

        store.send(.changeWhen("When")) {
            $0.when = "When"
            var isEmpty = $0.isEmpty
            isEmpty = false
        }
    }
}
