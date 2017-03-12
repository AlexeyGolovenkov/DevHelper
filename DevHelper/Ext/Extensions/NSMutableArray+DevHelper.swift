//
//  NSMutableArray+DevHelper.swift
//  DevHelper
//
//  Created by Alexey Golovenkov on 11.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Foundation

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
	func copyWordFromLineAbove(position: DHTextPosition) -> DHTextPosition {
		guard position.line > 0 && position.line < self.count && position.column >= 0 else {
			return position
		}
		guard let sourceLine = (self[position.line - 1] as? String) else {
			return position
		}
		guard position.column < sourceLine.characters.count - 1 else {
			return position
		}
		guard var updatingLine = (self[position.line] as? String) else {
			return position
		}
		
		let startIndex = sourceLine.startIndex
		let changingIndex = sourceLine.index(startIndex, offsetBy: position.column)
		var char = String(sourceLine[changingIndex]).unicodeScalars
		
		var lineToBeInserted = String(sourceLine[changingIndex])
		let lineLength = sourceLine.characters.count - 1
		var index = position.column + 1
		
		if CharacterSet.alphanumerics.contains(char[char.startIndex]) {
			while index < lineLength {
				let lineIndex = sourceLine.index(startIndex, offsetBy: index)
				char = String(sourceLine[lineIndex]).unicodeScalars
				guard CharacterSet.alphanumerics.contains(char[char.startIndex]) else {
					break
				}
				lineToBeInserted.append(sourceLine[lineIndex])
				index += 1
			}
			
		} else {
			while index < lineLength {
				let lineIndex = sourceLine.index(startIndex, offsetBy: index)
				char = String(sourceLine[lineIndex]).unicodeScalars
				guard !CharacterSet.alphanumerics.contains(char[char.startIndex]) else {
					break
				}
				lineToBeInserted.append(sourceLine[lineIndex])
				index += 1
			}
		}
		
		
		
//		var stringToBeInserted = sourceLine.substring(from: changingIndex)
//		if let i = stringToBeInserted.characters.index(of: "\n") {
//			stringToBeInserted.remove(at: i)
//		}
		
		let changingStringStartIndex = updatingLine.startIndex
		let changingStringChangingIndex = updatingLine.index(changingStringStartIndex, offsetBy: position.column)
		let prefix = updatingLine.substring(to: changingStringChangingIndex)
		let suffix = updatingLine.substring(from: changingStringChangingIndex)
		
		updatingLine = "\(prefix)\(lineToBeInserted)\(suffix)"
		self[position.line] = updatingLine
		
		return DHTextPosition(line: position.line, column: position.column + lineToBeInserted.characters.count)
	}
}
