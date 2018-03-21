//
//  StringTests.swift
//  DevHelperTests
//
//  Created by Alexey Golovenkov on 05/11/2017.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import XCTest

class StringTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPositionOfCommentStart() {
        let string = "@property /*(weak, nonatomic)*/ IBOutlet /*UITextField*/ *titleField;"
        let notFoundPosition = string.positionOfCommentStart(from: 3)
        XCTAssertNil(notFoundPosition, "Comment should not be found here")
        
        var firstFoundPosition = string.positionOfCommentStart(from: 13)
        XCTAssertEqual(firstFoundPosition, 10, "Wrong found position: \(firstFoundPosition!)")
        firstFoundPosition = string.positionOfCommentStart(from: 12)
        XCTAssertEqual(firstFoundPosition, 10, "Wrong found position: \(firstFoundPosition!)")
        firstFoundPosition = string.positionOfCommentStart(from: 11)
        XCTAssertNil(firstFoundPosition, "Comment should not be found at bound, but found at \(firstFoundPosition!)")
        
        var secondFoundPosition = string.positionOfCommentStart(from: 43)
        XCTAssertEqual(secondFoundPosition, 41, "Wrong found position: \(secondFoundPosition!)")
        
        var middlePosition = string.positionOfCommentStart(from: 35)
        XCTAssertNil(middlePosition, "Comment should not be found")
        
        let nestedCommentsString = "@/*property /*(weak, nonatomic)*/ IBOutlet /*UITextField*/ *titleField*/;"
        middlePosition = nestedCommentsString.positionOfCommentStart(from: 37)
        XCTAssertEqual(middlePosition, 1, "Comment start found in wrong position: \(middlePosition!)")
        
        firstFoundPosition = nestedCommentsString.positionOfCommentStart(from: 15)
        XCTAssertEqual(firstFoundPosition, 12, "Wrong found position: \(firstFoundPosition!)")
        firstFoundPosition = nestedCommentsString.positionOfCommentStart(from: 14)
        XCTAssertEqual(firstFoundPosition, 12, "Wrong found position: \(firstFoundPosition!)")
        firstFoundPosition = nestedCommentsString.positionOfCommentStart(from: 13)
        XCTAssertEqual(firstFoundPosition, 1, "Comment should not be found at bound, but found at \(firstFoundPosition!)")
        
        secondFoundPosition = nestedCommentsString.positionOfCommentStart(from: 45)
        XCTAssertEqual(secondFoundPosition, 43, "Wrong found position: \(secondFoundPosition!)")
    }
    
    func testPositionOfCommentEnd() {
        let string = "@property /*(weak, nonatomic)*/ IBOutlet /*UITextField*/ *titleField;"
        let notFoundPosition = string.positionOfCommentEnd(from: 63)
        XCTAssertNil(notFoundPosition, "Comment should not be found here")
        
        var firstFoundPosition = string.positionOfCommentEnd(from: 23)
        XCTAssertEqual(firstFoundPosition, 29, "Wrong found position: \(firstFoundPosition!)")
        firstFoundPosition = string.positionOfCommentEnd(from: 29)
        XCTAssertEqual(firstFoundPosition, 29, "Wrong found position: \(firstFoundPosition!)")
        
        var secondFoundPosition = string.positionOfCommentEnd(from: 43)
        XCTAssertEqual(secondFoundPosition, 54, "Wrong found position: \(secondFoundPosition!)")
        secondFoundPosition = string.positionOfCommentEnd(from: 54)
        XCTAssertEqual(secondFoundPosition, 54, "Wrong found position: \(secondFoundPosition!)")
        secondFoundPosition = string.positionOfCommentEnd(from: 55)
        XCTAssertNil(secondFoundPosition, "Comment should not be found at bound, but found at \(secondFoundPosition!)")
        
        var middlePosition = string.positionOfCommentEnd(from: 35)
        XCTAssertNil(middlePosition, "Comment should not be found")
        
        let nestedCommentsString = "@/*property /*(weak, nonatomic)*/ IBOutlet /*UITextField*/ *titleField*/;"
        middlePosition = nestedCommentsString.positionOfCommentEnd(from: 37)
        XCTAssertEqual(middlePosition, 70, "Comment start found in wrong position: \(middlePosition!)")
        
        firstFoundPosition = nestedCommentsString.positionOfCommentEnd(from: 15)
        XCTAssertEqual(firstFoundPosition, 31, "Wrong found position: \(firstFoundPosition!)")
        firstFoundPosition = nestedCommentsString.positionOfCommentEnd(from: 31)
        XCTAssertEqual(firstFoundPosition, 31, "Wrong found position: \(firstFoundPosition!)")
        firstFoundPosition = nestedCommentsString.positionOfCommentEnd(from: 32)
        XCTAssertEqual(firstFoundPosition, 70, "Comment should not be found at bound, but found at \(firstFoundPosition!)")
        
        secondFoundPosition = nestedCommentsString.positionOfCommentEnd(from: 45)
        XCTAssertEqual(secondFoundPosition, 56, "Wrong found position: \(secondFoundPosition!)")
    }
    
    func testCountOfInstances() {
        let string = "@property /*(weak, nonatomic)*/ IBOutlet /*UITextField*/ *titleField;"
        let instancesInWholeString = string.countInstances(of: "*/", in: (string.startIndex ..< string.endIndex))
        XCTAssertEqual(instancesInWholeString, 2, "Wrong number of instances in whole string: \(instancesInWholeString) instead of 2")
        let startIndex = string.index(string.startIndex, offsetBy: 15)
        let instancesInFirstComment = string.countInstances(of: "/*", in: (startIndex ..< string.endIndex))
        XCTAssertEqual(instancesInFirstComment, 1, "Wrong number of instances in whole string: \(instancesInFirstComment) instead of 1")
        let endIndex = string.index(startIndex, offsetBy: 4)
        let notFoundCount = string.countInstances(of: "*/", in: (startIndex ..< endIndex))
        XCTAssertEqual(notFoundCount, 0, "Found intances: \(notFoundCount) instead of 0")
    }
}
