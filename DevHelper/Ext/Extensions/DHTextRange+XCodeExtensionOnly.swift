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
	convenience init?(textRange: XCSourceTextRange?) {
		guard let textRange = textRange else {
			return nil
		}
		self.init()
		self.start = DHTextPosition(line: textRange.start.line, column: textRange.start.column)
		self.end = DHTextPosition(line: textRange.end.line, column: textRange.end.column)
	}
	
	override var debugDescription: String {
		get {
			return "DHTextRange. Start: line - \(self.start.line), column - \(self.start.column). End: line - \(self.end.line), column - \(self.end.column)."
		}
	}
}
