//
//  DHTextRange.swift
//  DevHelper
//
//  Created by Alexey Golovenkov on 12.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Cocoa

struct DHTextPosition: Equatable {
    var line = 0
    var column = 0
	
	public static func ==(lhs: DHTextPosition, rhs: DHTextPosition) -> Bool {
		return lhs.column == rhs.column && lhs.line == rhs.line
	}
}

class DHTextRange: NSObject {
	var start = DHTextPosition(line: 0, column: 0)
	var end = DHTextPosition(line: 0, column: 0)
    
    convenience init(start: DHTextPosition, end: DHTextPosition) {
        self.init()
        self.start = start
        self.end = end
    }
	
	func isCursorPosition() -> Bool {
		return self.start == self.end
	}
}
