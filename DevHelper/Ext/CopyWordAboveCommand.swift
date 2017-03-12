//
//  CopyWordAboveCommand.swift
//  DevHelper
//
//  Created by Alexey Golovenkov on 12.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Cocoa
import XcodeKit

class CopyWordAboveCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
		for selection in invocation.buffer.selections {
			guard let range = DHTextRange(textRange: selection as? XCSourceTextRange) else {
				continue
			}
			guard range.isCursorPosition() else {
				continue
			}
			let newPosition = invocation.buffer.lines.copyWordFromLineAbove(position: range.start)
			let position = selection as! XCSourceTextRange
			position.start.column = newPosition.column
			position.start.line = newPosition.line
			position.end.column = newPosition.column
			position.end.line = newPosition.line
		}
		
		completionHandler(nil)
	}
}
