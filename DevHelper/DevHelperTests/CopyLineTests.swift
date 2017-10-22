//
//  CopyLineTests.swift
//  DevHelperTests
//
//  Created by Alexey Golovenkov on 22/10/2017.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import XCTest

class CopyLineTests: XCTestCase {
	
	func testSingleCursorPosition() {
		guard let source = String(testFileName:"CopyLine.test") else {
			XCTFail("Source test file not found")
			return
		}
		let lines = source.lines()
		let range = DHTextRange()
		range.start = DHTextPosition(line: 24, column: 5)
		range.end = DHTextPosition(line: 24, column: 5)
		
		let textToByCopied = lines.wholeLines(range: range)
		let correctLine = "    [super viewDidLoad];"
		XCTAssertEqual(correctLine, textToByCopied, "@Wrong text: \(textToByCopied)");
	}
	
	func testMultiSelection() {
		guard let source = String(testFileName:"CopyLine.test") else {
			XCTFail("Source test file not found")
			return
		}
		let lines = source.lines()
		let range = DHTextRange()
		range.start = DHTextPosition(line: 24, column: 5)
		range.end = DHTextPosition(line: 26, column: 5)
		
		let textToByCopied = lines.wholeLines(range: range)
		let correctLine = "    [super viewDidLoad];    // Do any additional setup after loading the view.    [self makeRoundCornersForView:self.notesView];"
		XCTAssertEqual(correctLine, textToByCopied, "@Wrong text: \(textToByCopied)");
	}
}
