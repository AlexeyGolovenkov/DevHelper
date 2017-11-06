//
//  String+DevHelper.swift
//  DevHelperTests
//
//  Created by Alexey Golovenkov on 05/11/2017.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Foundation

extension String {
    func positionOfCommentStart(from column: Int) -> Int? {
        let finishIndex = self.index(self.startIndex, offsetBy: column)
        let startIndex = self.startIndex
        let range = startIndex..<finishIndex
        guard let foundIndex = self.range(of: "/*", options: .backwards, range: range) else {
            return nil
        }
        let foundPosition = self.distance(from: self.startIndex, to: foundIndex.lowerBound)
        
        let checkingRange = foundIndex.upperBound..<finishIndex
        if let _ = self.range(of: "*/", options: [], range: checkingRange) {
            if foundPosition < 2 {
                return nil
            }
            return self.positionOfCommentStart(from:foundPosition - 1)
        }
        return foundPosition
    }
    
    func positionOfCommentEnd(from column: Int) -> Int? {
        let startIndex = self.index(self.startIndex, offsetBy: column)
        let endIndex = self.endIndex
        let range = startIndex..<endIndex
        guard let foundIndex = self.range(of: "*/", options: [], range: range) else {
            return nil
        }
        let foundPosition = self.distance(from: self.startIndex, to: foundIndex.lowerBound)
        
        let checkingRange = startIndex..<foundIndex.upperBound
        if let _ = self.range(of: "/*", options: [], range: checkingRange) {
            if foundPosition > self.count - 2 {
                return nil
            }
            return self.positionOfCommentEnd(from:foundPosition + 1)
        }
        return foundPosition
    }
}
