//
//  UncommentCommand.swift
//  DevHelperContainer
//
//  Created by Alexey Golovenkov on 04/11/2017.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Cocoa
import XcodeKit

class UncommentCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) {
        for selection in invocation.buffer.selections {
            guard let range = DHTextRange(textRange: selection as? XCSourceTextRange) else {
                continue
            }
            let newSelection = invocation.buffer.lines.removeComments(around: range.start)
            guard let textSelection = selection as? XCSourceTextRange else {
                continue
            }
            
            textSelection.start.column = newSelection.start.column
            textSelection.start.line = newSelection.start.line
            textSelection.end.column = newSelection.end.column
            textSelection.end.line = newSelection.end.line
        }
        
        completionHandler(nil)
    }
}
