//
//  SeedFeatureTests.swift
//  Tests
//
//  Created by lcr on 2021/05/07.
//
//

import ComposableArchitecture
import FirebaseApiClient
import SeedFeature
import XCTest

class SeedFeatureTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChageSearchText() throws {
        // setup
        let store = TestStore(
            initialState: SeedState(),
            reducer: seedReducer,
            environment: SeedEnvironment(
                client: .mock,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )
        let text = "searchText"

        // execute
        store.send(.chageSearchText(text)) {
            // verify
            $0.searchText = text
            $0.isSearching = true
        }

        store.send(.chageSearchText("")) {
            // verify
            $0.searchText = ""
            $0.isSearching = false
        }
    }

    func testResetSearchText() throws {
        // setup
        let store = TestStore(
            initialState: SeedState(),
            reducer: seedReducer,
            environment: SeedEnvironment(
                client: .mock,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )
        store.send(.chageSearchText("test")) {
            $0.searchText = "test"
            $0.isSearching = true
        }

        // execute
        store.send(.resetSearchText) {
            // verify
            $0.searchText = ""
            $0.isSearching = false
        }
    }

//    func testSccuessStartObserve() throws {
//        // setup
//        let store = TestStore(
//            initialState: SeedState(),
//            reducer: seedReducer,
//            environment: SeedEnvironment(
//                client: .successSnapshot,
//                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
//            )
//        )
//        let diary = [Diary(title: "response",
//                          content: "response",
//                          userId: 1,
//                          createdAt: Timestamp(date: Date(timeIntervalSince1970: TimeInterval(1423053296))))]
//
//        store.send(.startObserve)
//
//        store.receive(.updateDiaries(.success(diary))) {
//            $0.diaries = diary
//        }
//    }
    func testStartObserve() throws {
        // setup
        let store = TestStore(
            initialState: SeedState(),
            reducer: seedReducer,
            environment: SeedEnvironment(
                client: .failureSnapshot,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )
        let error = FirebaseApiClient.ApiFailure(message: "mock error")

        // execute
        store.send(.startObserve)

        // verify
        store.receive(.updateDiaries(.failure(error))) {
            $0.diaries = []
        }
    }

    func testDeleteButtonTapped() throws {
        // setup
        let store = TestStore(
            initialState: SeedState(),
            reducer: seedReducer,
            environment: SeedEnvironment(
                client: .successDelete,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        let diaries = [
            Diary(id: "1",
                  title: "response",
                  content: "response",
                  userId: 1,
                  createdAt: Date(timeIntervalSince1970: 1_423_053_296)),
        ]

        store.send(.updateDiaries(.success(diaries))) {
            $0.diaries = diaries
        }
        // execute
        store.send(.deleteButtonTapped(0))
        // verify
        store.receive(.deleteResponse(.success("deleteDocumentId")))
    }

    func testFailureDelete() throws {
        // setup
        let store = TestStore(
            initialState: SeedState(),
            reducer: seedReducer,
            environment: SeedEnvironment(
                client: .failureDelete,
                mainQueue: .immediate.eraseToAnyScheduler()
            )
        )

        let diaries = [
            Diary(id: "1",
                  title: "response",
                  content: "response",
                  userId: 1,
                  createdAt: Date(timeIntervalSince1970: 1_423_053_296)),
        ]

        store.send(.updateDiaries(.success(diaries))) {
            $0.diaries = diaries
        }
        // execute
        store.send(.deleteButtonTapped(0))
        // verify
        store.receive(.deleteResponse(.failure(.init(message: "Failure delete"))))
    }
}
