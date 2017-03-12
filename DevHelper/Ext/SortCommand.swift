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
		for selection in invocation.buffer.selections {
			guard let range = DHTextRange(textRange: selection as? XCSourceTextRange) else {
				continue
			}
			invocation.buffer.lines.sort(range: range)
		}
		
		completionHandler(nil)
	}
}
