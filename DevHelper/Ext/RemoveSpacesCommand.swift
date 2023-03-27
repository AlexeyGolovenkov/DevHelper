//
//  RemoveSpacesCommand.swift
//  DevHelperCore
//
//  Created by Alexey Golovenkov on 27.03.2023.
//  Copyright © 2023 Alexey Golovenkov. All rights reserved.
//

import Cocoa
import XcodeKit

class RemoveSpacesCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) {
        invocation.buffer.lines.removeSpaces()
        completionHandler(nil)
    }
}
