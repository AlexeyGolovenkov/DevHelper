//
//  NSMutableArray+DevHelper.swift
//  DevHelper
//
//  Created by Alexey Golovenkov on 11.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Foundation

extension NSMutableArray {
	fileprivate func removeDoubledLines(from dirtyLines: [String]) -> [String] {
		var lines = dirtyLines
		var lineIndex = 1
		var line = lines.first!
		while lineIndex < lines.count {
			let currentLine = lines[lineIndex]
			if currentLine == line {
				lines.remove(at: lineIndex)
				continue
			}
			line = currentLine
			lineIndex += 1
		}
		return lines
	}
	
	func sort(range: DHTextRange) {
		if range.start.line == range.end.line {
			// nothing to do
			return
		}
		var selectedLines = [String]()
		for lineIndex in range.start.line ... range.end.line {
			guard let line = self[lineIndex] as? String else {
				continue
			}
			selectedLines.append(line)
		}
		let initialLinesCount = selectedLines.count
		selectedLines.sort()
		selectedLines = removeDoubledLines(from: selectedLines)
		
		// replace old lines with new ones
		var replaceLineIndex = range.start.line
		for line in selectedLines {
			self[replaceLineIndex] = line
			replaceLineIndex += 1
		}
		
		// remove extra lines
		if selectedLines.count < initialLinesCount {
			for _ in selectedLines.count ..< initialLinesCount {
				self.removeObject(at: range.start.line + selectedLines.count)
			}
		}
	}
	
	func copyLineAbove(position: DHTextPosition) -> DHTextPosition {
		if position.line == self.count {
			self.add("")
		}
		guard position.line > 0 && position.line < self.count && position.column >= 0 else {
			return position
		}
		guard let sourceLine = (self[position.line - 1] as? String) else {
			return position
		}
		guard position.column < sourceLine.count - 1 else {
			return position
		}
		guard var updatingLine = (self[position.line] as? String) else {
			return position
		}
		
		let startIndex = sourceLine.startIndex
		let changingIndex = sourceLine.index(startIndex, offsetBy: position.column)
		var substringToBeInserted = sourceLine[changingIndex...]
		substringToBeInserted = substringToBeInserted[..<substringToBeInserted.index(before: substringToBeInserted.endIndex)]
		
		let changingStringStartIndex = updatingLine.startIndex
		let changingStringChangingIndex = updatingLine.index(changingStringStartIndex, offsetBy: position.column)
		let prefix = updatingLine[..<changingStringChangingIndex]
		let suffix = updatingLine[changingStringChangingIndex...]
		
		let lineToBeInserted = String(substringToBeInserted)
		updatingLine = "\(String(prefix))\(lineToBeInserted)\(String(suffix))"
		self[position.line] = updatingLine
		
		return DHTextPosition(line: position.line, column: position.column + lineToBeInserted.count)
	}
	
	func comment(range: DHTextRange) -> DHTextRange {
		guard var endLine = self[range.end.line] as? String else {
			return range
		}
		let endLineIndex = endLine.index(endLine.startIndex, offsetBy: range.end.column)
		endLine.insert("/", at: endLineIndex)
		endLine.insert("*", at: endLineIndex)
		self[range.end.line] = endLine
		
		guard var firstLine = self[range.start.line] as? String else {
			return range
		}
		let firstLineIndex = firstLine.index(firstLine.startIndex, offsetBy: range.start.column)
		firstLine.insert("*", at: firstLineIndex)
		firstLine.insert("/", at: firstLineIndex)
		self[range.start.line] = firstLine
		
		if range.isCursorPosition() {
			range.end.column += 2
			range.start.column += 2
			return range
		}
		
		let offset = range.start.line == range.end.line ? 4 : 2
		range.end.column += offset
		return range
	}
	
	func wholeLines(range: DHTextRange) -> String {
		var string = ""
		for lineIndex in range.start.line ... range.end.line {
			guard let line = self[lineIndex] as? String else {
				continue
			}
			string.append(line)
		}
		return string
	}
}
