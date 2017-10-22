//
//  CopyLineCommand.swift
//  DevHelperContainer
//
//  Created by Alexey Golovenkov on 22/10/2017.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Cocoa
import XcodeKit

class CopyLineCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
		guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
			// Nothing selected
			completionHandler(nil)
			return
		}
		
		guard let textRange = DHTextRange(textRange: selection) else {
			completionHandler(nil)
			return
		}
		let textToBeCopied = invocation.buffer.lines.wholeLines(range: textRange)
		NSPasteboard.general.clearContents()
		NSPasteboard.general.writeObjects([textToBeCopied as NSString])
		
		completionHandler(nil)
	}
}
