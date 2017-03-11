//
//  NSMutableArray+DevHelper.swift
//  DevHelper
//
//  Created by Alexey Golovenkov on 11.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Foundation

struct DHTextPosition {
	var line = 0
	var column = 0
}

class DHTextRange: NSObject {
	var start = DHTextPosition(line: 0, column: 0)
	var end = DHTextPosition(line: 0, column: 0)
}

extension NSMutableArray {
	func sort(range: DHTextRange) {
		if range.start.line == range.end.line {
			// nothing to do
			return
		}
		var selectedLines = [String]()
		for lineIndex in range.start.line ... range.end.line {
			selectedLines.append(self[lineIndex] as! String)
		}
		let initialLinesCount = selectedLines.count
		selectedLines.sort()
		var lineIndex = 1
		
		// delete doubled lines
		var line = selectedLines.first!
		while lineIndex < selectedLines.count {
			let currentLine = selectedLines[lineIndex]
			if currentLine == line {
				selectedLines.remove(at: lineIndex)
				continue
			}
			line = currentLine
			lineIndex += 1
		}
		
		// replace old lines with new ones
		lineIndex = range.start.line
		for line in selectedLines {
			self[lineIndex] = line
			lineIndex += 1
		}
		
		// remove extra lines
		if selectedLines.count < initialLinesCount {
			for _ in selectedLines.count ..< initialLinesCount {
				self.removeObject(at: range.start.line + selectedLines.count)
			}
		}
	}
}
