//
//  RemoveSpacesCommandTests.swift
//  DevHelperTests
//
//  Created by Alexey Golovenkov on 27.03.2023.
//  Copyright © 2023 Alexey Golovenkov. All rights reserved.
//

import XCTest

final class RemoveSpacesCommandTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSpacesRemover() throws {
        guard let source = String(testFileName:"ClassWithSpaces.test") else {
            XCTFail("Source test file not found")
            return
        }
        
        guard let corrected = String(testFileName:"ClassWithoutSpaces.test") else {
            XCTFail("corrected test file not found")
            return
        }
        
        let sourceLines = source.lines()
        sourceLines.removeSpaces()
        let correctLines = corrected.lines()
        
        guard correctLines.count == sourceLines.count else {
            XCTFail("Lines count not equal")
            return
        }
        
        for index in 0 ..< correctLines.count {
            guard let line = sourceLines[index] as? String,
                  let correctLine = correctLines[index] as? String else {
                XCTFail("Some lines are not strings. For example #\(index)")
                return
            }
            XCTAssertEqual(line, correctLine, "Lines #\(index) are not equal")
        }
        
    }

}
