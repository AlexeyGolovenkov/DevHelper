//
//  XCSourceTextRange+DevHelper.swift
//  DevHelper
//
//  Created by Alexey Golovenkov on 11.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Foundation
import XcodeKit

extension DHTextRange {
	convenience init(textRange: XCSourceTextRange) {
		self.init()
		self.start = DHTextPosition(line: textRange.start.line, column: textRange.start.column)
		self.end = DHTextPosition(line: textRange.end.line, column: textRange.end.column)
	}
}
