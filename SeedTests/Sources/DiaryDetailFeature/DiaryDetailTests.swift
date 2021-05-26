//
//  DiaryDetailTests.swift
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
class DiaryDetailTests: XCTestCase {

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
                          createdAt: Timestamp())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .mock,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
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
                          createdAt: Timestamp())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .successDelete,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
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
                          createdAt: Timestamp())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .successDelete,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
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
                          createdAt: Timestamp())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .failureDelete,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
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
                          createdAt: Timestamp())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .successUpdate,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
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
                          createdAt: Timestamp())

        let store = TestStore(
            initialState: DiaryDetailState(diary: diary),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: .failureUpdate,
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
            )
        )

        // execute
        store.send(.save)

        // verify
        store.receive(.saveResponse(.failure(.init(message: "Failure update"))))
    }
}
