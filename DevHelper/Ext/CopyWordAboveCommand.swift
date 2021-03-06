//
//  CopyWordAboveCommand.swift
//  DevHelper
//
//  Created by Alexey Golovenkov on 12.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Cocoa
import XcodeKit

class CopyLineAboveCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) {
		for selection in invocation.buffer.selections {
            guard let position = selection as? XCSourceTextRange else {
                continue;
            }            
			guard let range = DHTextRange(textRange: position) else {
				continue
			}
			guard range.isCursorPosition() else {
				continue
			}
			let newPosition = invocation.buffer.lines.copyLineAbove(position: range.start)
			position.start.column = newPosition.column
			position.start.line = newPosition.line
			position.end.column = newPosition.column
			position.end.line = newPosition.line
		}
		
		completionHandler(nil)
	}
}
