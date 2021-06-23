//
//  DiaryDetailFeatureTests.swift
//  Tests
//
//  Created by lcr on 2021/05/26.
//
//

import ComposableArchitecture
import DiaryDetailFeature
import FirebaseApiClient
import XCTest

class DiaryDetailFeatureTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChangeTitle() throws {
        // setup
        let diary = Diary(id: "1",
                          title: "title",
                          content: "content",
                          userId: 1,
                          createdAt: Date())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .mock,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )
        let editTitle = "edittitle"
        let editContent = "edittitle"

        // execute
        store.send(.editTitle(editTitle)) {
            // verify
            $0.editedTitle = editTitle
        }

        store.send(.editContent(editContent)) {
            // verify
            $0.editedContent = editContent
        }
    }

    func testSheetButtonTapped() throws {
        // setup
        let diary = Diary(id: "1",
                          title: "title",
                          content: "content",
                          userId: 1,
                          createdAt: Date())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .successDelete,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        // execute
        store.send(.sheetButtonTapped)
    }

    func testSuccessDelete() throws {
        // setup
        let diary = Diary(id: "1",
                          title: "title",
                          content: "content",
                          userId: 1,
                          createdAt: Date())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .successDelete,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )
        store.send(.editTitle("")) {
            $0.editedTitle = ""
        }
        store.send(.editContent("")) {
            $0.editedContent = ""
        }

        // execute
        store.send(.save)

        // verify
        store.receive(.deleteResponse(.success("deleteDocumentId")))
    }

    func testFailureDelete() throws {
        // setup
        let diary = Diary(id: "1",
                          title: "title",
                          content: "content",
                          userId: 1,
                          createdAt: Date())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .failureDelete,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )
        store.send(.editTitle("")) {
            $0.editedTitle = ""
        }
        store.send(.editContent("")) {
            $0.editedContent = ""
        }

        // execute
        store.send(.save)

        // verify
        store.receive(.deleteResponse(.failure(.init(message: "Failure delete"))))
    }

    func testSuccessUpdate() throws {
        // setup
        let diary = Diary(id: "1",
                          title: "title",
                          content: "content",
                          userId: 1,
                          createdAt: Date())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .successUpdate,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        // execute
        store.send(.save)

        // verify
        store.receive(.saveResponse(.success("documentId")))
    }

    func testFailureUpdate() throws {
        // setup
        let diary = Diary(id: "1",
                          title: "title",
                          content: "content",
                          userId: 1,
                          createdAt: Date())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .failureUpdate,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        // execute
        store.send(.save)

        // verify
        store.receive(.saveResponse(.failure(.init(message: "Failure update"))))
    }
}
