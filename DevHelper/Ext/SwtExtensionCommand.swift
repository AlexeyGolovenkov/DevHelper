//
//  SwiftExtensionCommand.swift
//  DevHelperContainer
//
//  Created by Alex Golovenkov on 05/02/2019.
//  Copyright © 2019 Alexey Golovenkov. All rights reserved.
//

import Cocoa
import XcodeKit

class SwtExtensionCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) {
        guard invocation.buffer.selections.count > 0 else {
            completionHandler(nil)
            return
        }
        let selection = invocation.buffer.selections[0] as? XCSourceTextRange
        guard let range = DHTextRange(textRange: selection) else {
            completionHandler(nil)
            return
        }
        let newSelection = invocation.buffer.lines.addSwiftExtension(for: range.start)
        
        if let textSelection = selection {
            textSelection.start.column = newSelection.start.column
            textSelection.start.line = newSelection.start.line
            textSelection.end.column = newSelection.end.column
            textSelection.end.line = newSelection.end.line
        }
        
        completionHandler(nil)
    }
}
