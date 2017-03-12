//
//  DHTextRangeTests.swift
//  DevHelper
//
//  Created by Alexey Golovenkov on 12.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import XCTest

class DHTextRangeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIsCursorPosition() {
        let range = DHTextRange()
		range.start = DHTextPosition(line: 4, column: 5)
		range.end = DHTextPosition(line: 4, column: 5)
		XCTAssertTrue(range.isCursorPosition(), "The range should be a cursor position")
		
		range.end = DHTextPosition(line: 4, column: 2)
		XCTAssertFalse(range.isCursorPosition(), "The range should NOT be a cursor position")
		range.end = DHTextPosition(line: 1, column: 5)
		XCTAssertFalse(range.isCursorPosition(), "The range should NOT be a cursor position")
		range.end = DHTextPosition(line: 1, column: 4)
		XCTAssertFalse(range.isCursorPosition(), "The range should NOT be a cursor position")
		range.end = DHTextPosition(line: 5, column: 4)
		XCTAssertFalse(range.isCursorPosition(), "The range should NOT be a cursor position")
    }

}
