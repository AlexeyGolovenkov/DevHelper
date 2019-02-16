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
    
    func testClassName() {
        let codeString = "let startIndex = string.index(string.startIndex, offsetBy: 15)"
        let nonameString = codeString.className()
        XCTAssertNil(nonameString, "Noname string must be nil. Real result: \(String(describing: nonameString))")
        
        let classString = "class SourceEditorExtension: NSObject, XCSourceEditorExtension {"
        let className = classString.className()
        XCTAssertTrue(className == "SourceEditorExtension", "Wrong class name: \(String(describing: className))")
        
        let structString = "struct LiveChatToken {"
        let structName = structString.className()
        XCTAssertTrue(structName == "LiveChatToken", "Wrong struct name: \(String(describing: structName))")
        
        let enumString = "public enum Style: String {"
        let enumName = enumString.className()
        XCTAssertTrue(enumName == "Style", "Wrong enum name: \(String(describing: enumName))")
    }
}
