//
//  ArrayOfStringTests.swift
//  DevHelperTests
//
//  Created by Alex Golovenkov on 20/03/2018.
//  Copyright © 2018 Alexey Golovenkov. All rights reserved.
//

import XCTest

class ArrayOfStringTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSubstringForward() {
        guard let source = String(testFileName:"UncommentSource.test") else {
            XCTFail("Source test file not found")
            return
        }
        let lines = source.lines()
        let startPosition = DHTextPosition(line: 29, column: 3)
        let endCommentPostion = lines.position(of: "*/", between: startPosition, and: nil, direction: [])
        let correctPosition = DHTextPosition(line: 31, column: 0)
        XCTAssertEqual(endCommentPostion, correctPosition, "Wrong position of */ symbol")
    }

    func testSubstringBackward() {
        guard let source = String(testFileName:"UncommentSource.test") else {
            XCTFail("Source test file not found")
            return
        }
        let lines = source.lines()
        let endPosition = DHTextPosition(line: 29, column: 3)
        let endCommentPostion = lines.position(of: "/*", between: nil, and: endPosition, direction: [.backwards])
        let correctPosition = DHTextPosition(line: 25, column: 0)
        XCTAssertEqual(endCommentPostion, correctPosition, "Wrong position of */ symbol")
    }
}
