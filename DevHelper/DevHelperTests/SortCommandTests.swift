//
//  DevHelperTests.swift
//  DevHelperTests
//
//  Created by Alexey Golovenkov on 11.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import XCTest

class SortCommandTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSingleSort() {
		guard let source = String(testFileName:"SingleSortSource.test") else {
			XCTFail("Source test file not found")
			return
		}
		
		guard let corrected = String(testFileName:"SingleSortCorrected.test") else {
			XCTFail("corrected test file not found")
			return
		}
	
        let lines = source.lines()
        let range = DHTextRange()
		range.start = DHTextPosition(line: 7, column: 1)
		range.end = DHTextPosition(line: 11, column: 1)
		lines.sort(range: range)
		let correctedText = lines.componentsJoined(by: "\n")
		XCTAssertEqual(correctedText, corrected, "Text handled with errors")
	}
	
	func testSortAndUniq() {
		guard let source = String(testFileName:"SortAndUniqSource.test") else {
			XCTFail("Source test file not found")
			return
		}
		
		guard let corrected = String(testFileName:"SortAndUniqCorrected.test") else {
			XCTFail("corrected test file not found")
			return
		}
		
		let lines = source.lines()
		let range = DHTextRange()
		range.start = DHTextPosition(line: 7, column: 1)
		range.end = DHTextPosition(line: 13, column: 1)
		lines.sort(range: range)
		let correctedText = lines.componentsJoined(by: "\n")
		XCTAssertEqual(correctedText, corrected, "Text handled with errors")
	}
    
	
}
