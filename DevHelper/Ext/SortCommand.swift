//
//  SourceEditorCommand.swift
//  Ext
//
//  Created by Alexey Golovenkov on 11.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Foundation
import XcodeKit


/// Sorts selected lines and deletes duplicates
class SortCommand: NSObject, XCSourceEditorCommand {
    
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
		// Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
		for selection in invocation.buffer.selections {
			let range = DHTextRange(textRange: selection as! XCSourceTextRange)
			invocation.buffer.lines.sort(range: range)
//			self.sort(range: selection as! XCSourceTextRange, in: invocation.buffer.lines)
		}
		
		completionHandler(nil)
	}
	
//	func sort(range: XCSourceTextRange, in lines: NSMutableArray) {
//		if range.start.line == range.end.line {
//			// nothing to do
//			return
//		}
//		var selectedLines = [String]()
//		for lineIndex in range.start.line ... range.end.line {
//			selectedLines.append(lines[lineIndex] as! String)
//		}
//		let initialLinesCount = selectedLines.count
//		selectedLines.sort()
//		var lineIndex = 1
//		
//		// delete doubled lines
//		var line = selectedLines.first!
//		while lineIndex < selectedLines.count {
//			let currentLine = selectedLines[lineIndex]
//			if currentLine == line {
//				selectedLines.remove(at: lineIndex)
//				continue
//			}
//			line = currentLine
//			lineIndex += 1
//		}
//		
//		// replace old lines with new ones
//		lineIndex = range.start.line
//		for line in selectedLines {
//			lines[lineIndex] = line
//			lineIndex += 1
//		}
//		
//		// remove extra lines
//		if selectedLines.count < initialLinesCount {
//			for _ in selectedLines.count ..< initialLinesCount {
//				lines.removeObject(at: range.start.line + selectedLines.count)
//			}
//		}
//	}
	
}
