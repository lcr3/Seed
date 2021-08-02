//
//  DiaryTests.swift
//  
//
//  Created by lcr on 2021/08/02.
//  
//

import ComposableArchitecture
import FirebaseApiClient
import SeedFeature
import XCTest

class DiaryTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testContentType() throws {
        // setup
        let memoDiary = Diary(type: 0)
        let epDiary = Diary(type: 1)
        let unknownDiary = Diary(type: 2)

        // // verify
        XCTAssertEqual(memoDiary.contentType(), .memo)
        XCTAssertEqual(epDiary.contentType(), .ep)
        XCTAssertEqual(unknownDiary.contentType(), .memo)
    }

    func testIsMemo() throws {
        // setup
        let memoDiary = Diary(type: 0)
        let epDiary = Diary(type: 1)
        let unknownDiary = Diary(type: 2)

        // // verify
        XCTAssertEqual(memoDiary.contentType().isMemo(), true)
        XCTAssertEqual(epDiary.contentType().isMemo(), false)
        XCTAssertEqual(unknownDiary.contentType().isMemo(), true)
    }

    func testImageName() throws {
        // setup
        let memoDiary = Diary(type: 0)
        let epDiary = Diary(type: 1)
        let unknownDiary = Diary(type: 2)

        // // verify
        XCTAssertEqual(memoDiary.imageName, DiaryImageName.memo)
        XCTAssertEqual(epDiary.imageName, DiaryImageName.ep)
        XCTAssertEqual(unknownDiary.imageName,DiaryImageName.memo)
    }
}
