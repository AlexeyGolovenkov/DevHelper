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
    
    func testPositionOfCommentEnd() {
        guard let source = String(testFileName:"UncommentSource.test") else {
            XCTFail("Source test file not found")
            return
        }
        let lines = source.lines()
        let startPosition = DHTextPosition(line: 24, column: 3)
        let positionOfCommentEnd = lines.positionOfBlockEnd(from: startPosition)
        let correctPosition = DHTextPosition(line: 33, column: 0)
        XCTAssertEqual(positionOfCommentEnd, correctPosition, "Wrong position: \(String(describing: positionOfCommentEnd))")
    }
    
    func testClassBracketsStart() {
        guard let source = String(testFileName:"SwiftClass.test") else {
            XCTFail("Source test file not found")
            return
        }
        let lines = source.lines()
        let startPosition = DHTextPosition(line: 11, column: 22)
        let classStartPosition = lines.positionOfBlockStart(from: startPosition, startBlockMarker: "{", endBlockMarker: "}")
        let correctPosition = DHTextPosition(line: 10, column: 19)
        XCTAssertEqual(classStartPosition, correctPosition, "Wrong position: \(String(describing: classStartPosition))")
    }
    
    func testClassBracketsEnd() {
        guard let source = String(testFileName:"SwiftClass.test") else {
            XCTFail("Source test file not found")
            return
        }
        let lines = source.lines()
        let startPosition = DHTextPosition(line: 11, column: 22)
        let classEndPosition = lines.positionOfBlockEnd(from: startPosition, startBlockMarker: "{", endBlockMarker: "}")
        let correctPosition = DHTextPosition(line: 46, column: 0)
        XCTAssertEqual(classEndPosition, correctPosition, "Wrong position: \(String(describing: classEndPosition))")
    }
    
    func testClassName() {
        guard let source = String(testFileName:"SwiftClass.test") else {
            XCTFail("Source test file not found")
            return
        }
        let lines = source.lines()
        let noClassLocation = lines.positionOfClass(over: 9)
        XCTAssertNil(noClassLocation, "No class over line 9")
        
        let classNameLocation = lines.positionOfClass(over: 12)
        XCTAssertNotNil(classNameLocation, "Class name not found")
        XCTAssertTrue(classNameLocation?.lineIndex == 10, "Wrong line of class declare: \(String(describing: classNameLocation?.lineIndex))")
        XCTAssertTrue(classNameLocation?.className == "StringHelper", "Wrong class name: \(String(describing: classNameLocation?.className))")
        
        let classNameLocationAboveClassFunc = lines.positionOfClass(over: 45)
        XCTAssertTrue(classNameLocationAboveClassFunc?.lineIndex == 10, "Wrong line of class declare: \(String(describing: classNameLocationAboveClassFunc?.lineIndex))")
        XCTAssertTrue(classNameLocationAboveClassFunc?.className == "StringHelper", "Wrong class name: \(String(describing: classNameLocationAboveClassFunc?.className))")
    }
}
