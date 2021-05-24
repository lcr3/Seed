//
//  SeedTests.swift
//  SeedTests
//
//  Created by lcr on 2021/05/07.
//  
//

import ComposableArchitecture
import XCTest

@testable import Seed

class SeedTests: XCTestCase {

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
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
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
                mainQueue: DispatchQueue.immediate.eraseToAnyScheduler()
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
}
