//
//  UncommentTests.swift
//  DevHelperTests
//
//  Created by Alexey Golovenkov on 05/11/2017.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import XCTest

class UncommentTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNotInCommentedBlock() {
        guard let source = String(testFileName:"UncommentSource.test") else {
            XCTFail("Source test file not found")
            return
        }
        
        let lines = source.lines()
        let range = DHTextRange()
        range.start = DHTextPosition(line: 7, column: 1)
        range.end = DHTextPosition(line: 7, column: 1)
        let _ = lines.removeComments(around: range.start)
        let correctedText = lines.componentsJoined(by: "\n")
        XCTAssertEqual(source, correctedText, "Source text should not be changed")
    }
    
    func testInFirstCommentedBlock() {
        guard let source = String(testFileName:"UncommentSource.test") else {
            XCTFail("Source test file not found")
            return
        }
        guard let correctedText = String(testFileName:"UncommentInline1.test") else {
            XCTFail("Source test file not found")
            return
        }
        
        let lines = source.lines()
        let range = DHTextRange()
        range.start = DHTextPosition(line: 17, column: 20)
        range.end = DHTextPosition(line: 17, column: 20)
        let _ = lines.removeComments(around: range.start)
        let textWithoutComments = lines.componentsJoined(by: "\n")
        XCTAssertEqual(textWithoutComments, correctedText, "Source text should not be changed")
    }
    
    func testInSecondCommentedBlock() {
        guard let source = String(testFileName:"UncommentSource.test") else {
            XCTFail("Source test file not found")
            return
        }
        guard let correctedText = String(testFileName:"UncommentInline2.test") else {
            XCTFail("Source test file not found")
            return
        }
        
        let lines = source.lines()
        let range = DHTextRange()
        range.start = DHTextPosition(line: 17, column: 46)
        range.end = DHTextPosition(line: 17, column: 46)
        let _ = lines.removeComments(around: range.start)
        let textWithoutComments = lines.componentsJoined(by: "\n")
        XCTAssertEqual(textWithoutComments, correctedText, "Source text should not be changed")
    }
    
    func testOutNestedCommentedBlock() {
        guard let source = String(testFileName:"UncommentSource.test") else {
            XCTFail("Source test file not found")
            return
        }
        guard let correctedText = String(testFileName:"UncommentNestedOutside.test") else {
            XCTFail("Source test file not found")
            return
        }
        
        let lines = source.lines()
        let range = DHTextRange()
        range.start = DHTextPosition(line: 19, column: 11)
        range.end = DHTextPosition(line: 19, column: 11)
        let _ = lines.removeComments(around: range.start)
        let textWithoutComments = lines.componentsJoined(by: "\n")
        XCTAssertEqual(textWithoutComments, correctedText, "Source text should not be changed")
    }
    
    func testInNestedCommentedBlock() {
        guard let source = String(testFileName:"UncommentSource.test") else {
            XCTFail("Source test file not found")
            return
        }
        guard let correctedText = String(testFileName:"UncommentNestedInside.test") else {
            XCTFail("Source test file not found")
            return
        }
        
        let lines = source.lines()
        let range = DHTextRange()
        range.start = DHTextPosition(line: 19, column: 30)
        range.end = DHTextPosition(line: 19, column: 30)
        let _ = lines.removeComments(around: range.start)
        let textWithoutComments = lines.componentsJoined(by: "\n")
        XCTAssertEqual(textWithoutComments, correctedText, "Source text should not be changed")
    }
    
    func testInMutilineCommentedBlock() {
        guard let source = String(testFileName:"UncommentSource.test") else {
            XCTFail("Source test file not found")
            return
        }
        guard let correctedText = String(testFileName:"UncommentMultilineInside.test") else {
            XCTFail("Source test file not found")
            return
        }
        
        let lines = source.lines()
        let range = DHTextRange()
        range.start = DHTextPosition(line: 29, column: 3)
        range.end = DHTextPosition(line: 29, column: 3)
        let _ = lines.removeComments(around: range.start)
        let textWithoutComments = lines.componentsJoined(by: "\n")
        XCTAssertEqual(textWithoutComments, correctedText, "Source text should not be changed")
    }
    
    func testOutMutilineCommentedBlock() {
        guard let source = String(testFileName:"UncommentSource.test") else {
            XCTFail("Source test file not found")
            return
        }
        guard let correctedText = String(testFileName:"UncommentMultilineOutside.test") else {
            XCTFail("Source test file not found")
            return
        }
        
        let lines = source.lines()
        let range = DHTextRange()
        range.start = DHTextPosition(line: 24, column: 3)
        range.end = DHTextPosition(line: 24, column: 3)
        let _ = lines.removeComments(around: range.start)
        let textWithoutComments = lines.componentsJoined(by: "\n")
        XCTAssertEqual(textWithoutComments, correctedText, "Source text should not be changed")
    }
}
