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
        range.start.column += 2
        if range.start.line == range.end.line {
            range.end.column += 2
        }
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
    
    // MARK: Remove comments
    func removeComments(around position: DHTextPosition) -> DHTextRange {
        guard let commentRange = self.commentBounds(around: position) else {
            return DHTextRange(start: position, end: position)
        }
        
        guard var endLine = self[commentRange.end.line] as? String else {
            return DHTextRange(start: position, end: position)
        }
        var removingInsdexStart = endLine.index(endLine.startIndex, offsetBy: commentRange.end.column)
        var removingIndexEnd = endLine.index(removingInsdexStart, offsetBy: 1);
        var removingRange = removingInsdexStart...removingIndexEnd
        endLine.removeSubrange(removingRange)
        self[commentRange.end.line] = endLine
        
        guard var beginLine = self[commentRange.start.line] as? String else {
            return DHTextRange(start: position, end: position)
        }
        removingInsdexStart = beginLine.index(beginLine.startIndex, offsetBy: commentRange.start.column)
        removingIndexEnd = beginLine.index(removingInsdexStart, offsetBy: 1);
        removingRange = removingInsdexStart...removingIndexEnd
        beginLine.removeSubrange(removingRange)
        self[commentRange.start.line] = beginLine
        
        var cursorPosition = position
        if commentRange.start.line == position.line {
            cursorPosition.column -= 2
        }
        let range = DHTextRange(start: cursorPosition, end: cursorPosition)
        
        return range
    }
    
    func commentBounds(around position: DHTextPosition) -> DHTextRange? {
        guard let positionOfCommentStart = self.positionOfBlockStart(from: position) else {
            return nil
        }
        
        guard let positionOfCommentEnd = self.positionOfBlockEnd(from: position) else {
            return nil
        }
        
        return DHTextRange(start: positionOfCommentStart, end: positionOfCommentEnd)
    }
    
    func positionOfBlockStart(from position: DHTextPosition, startBlockMarker: String = "/*", endBlockMarker: String = "*/") -> DHTextPosition? {
        var numberOfStartComments = 1
        var positionOfStartComment = self.position(of: startBlockMarker, between: nil, and: position, direction: [.backwards])
        if positionOfStartComment == nil {
            return nil
        }
        var numberOfCloseComment = self.number(of: endBlockMarker, between: positionOfStartComment!, and: position)
        while numberOfCloseComment >= numberOfStartComments {
            numberOfStartComments += 1
            var previousPoint = positionOfStartComment!
            previousPoint.column -= 1
            if previousPoint.column < 0 {
                previousPoint.line -= 1
                if previousPoint.line < 0 {
                    return nil
                }
                previousPoint.column = (self[previousPoint.line] as? String)?.count ?? 0
            }
            
            positionOfStartComment = self.position(of: startBlockMarker, between: nil, and: previousPoint, direction: [.backwards])
            if positionOfStartComment == nil {
                return nil
            }
            numberOfCloseComment = self.number(of: endBlockMarker, between: positionOfStartComment!, and: position)
        }
        return positionOfStartComment
    }
    
    func positionOfBlockEnd(from position: DHTextPosition, startBlockMarker: String = "/*", endBlockMarker: String = "*/") -> DHTextPosition? {
        var numberOfEndComments = 1
        var positionOfEndComment = self.position(of: endBlockMarker, between: position, and:nil, direction: [])
        if positionOfEndComment == nil {
            return nil
        }
        var numberOfOpenComments = self.number(of: startBlockMarker, between: position, and: positionOfEndComment!)
        while numberOfOpenComments >= numberOfEndComments {
            numberOfEndComments += 1
            let nextPoint = DHTextPosition(line: positionOfEndComment!.line, column: positionOfEndComment!.column + 1)
            positionOfEndComment = self.position(of: endBlockMarker, between: nextPoint, and:nil, direction: [])
            if positionOfEndComment == nil {
                return nil
            }
            numberOfOpenComments = self.number(of: startBlockMarker, between: position, and: positionOfEndComment!)
        }
        return positionOfEndComment
    }
    
    func number(of substring: String, between startPosition: DHTextPosition, and endPosition: DHTextPosition) -> Int {
        var instancesCount = 0
        for lineIndex in startPosition.line ... endPosition.line {
            guard let line = self[lineIndex] as? String else {
                continue
            }
            guard let startIndex = self.startIndex(from: startPosition, ofLineAt: lineIndex) else {
                continue
            }
            guard let endIndex = self.endIndex(to: endPosition, ofLineAt: lineIndex) else {
                continue
            }
            
            instancesCount += line.countInstances(of: substring, in: (startIndex ..< endIndex))
        }
        
        return instancesCount
    }
    
    func position(of string: String, between startPosition: DHTextPosition?, and endPosition: DHTextPosition?, direction: NSString.CompareOptions) -> DHTextPosition? {
        let startPosition = startPosition ?? DHTextPosition(line: 0, column: 0)
        let endPosition = endPosition ?? DHTextPosition(line: self.count - 1, column: ((self.lastObject as? String)?.count ?? 0))
        
        if direction.contains(.backwards) {
            return straitPosition(of: string, between: startPosition, and: endPosition, direction: [.backwards])
        } else {
            return straitPosition(of: string, between: startPosition, and: endPosition, direction: [])
        }
    }
    
    func straitPosition(of string: String, between startPosition: DHTextPosition!, and endPosition: DHTextPosition!, direction: NSString.CompareOptions) -> DHTextPosition? {
        let lookingRange: StrideThrough<Int>
        if direction.contains(.backwards) {
            lookingRange = stride(from:endPosition.line, through:startPosition.line, by:-1)
        } else {
            lookingRange = stride(from:startPosition.line, through:endPosition.line, by:1)
        }
        
        for lineIndex in lookingRange {
            guard let line = self[lineIndex] as? String else {
                continue
            }
            guard let startIndex = self.startIndex(from: startPosition, ofLineAt: lineIndex) else {
                continue
            }
            guard let endIndex = self.endIndex(to: endPosition, ofLineAt: lineIndex) else {
                continue
            }
            let checkingRange = startIndex ..< endIndex
            if let foundIndex = line.range(of: string, options: direction, range: checkingRange) {
                let column = line.distance(from: line.startIndex, to: foundIndex.lowerBound)
                return DHTextPosition(line: lineIndex, column: column)
            }
        }
        
        return nil
    }
    
    func startIndex(from position: DHTextPosition, ofLineAt lineIndex: Int) -> String.Index? {
        if position.line == lineIndex {
            guard let line = self[position.line] as? String else {
                return nil
            }
            let offset = Swift.min(position.column, line.count)
            return line.index(line.startIndex, offsetBy: offset)
        }
        if lineIndex < position.line {
            return nil
        } else {
            guard let line = self[lineIndex] as? String else {
                return nil
            }
            return line.startIndex
        }
    }
    
    func endIndex(to position: DHTextPosition, ofLineAt lineIndex: Int) -> String.Index? {
        if position.line == lineIndex {
            guard let line = self[position.line] as? String else {
                return nil
            }
            let offset = Swift.min(position.column, line.count)
            return line.index(line.startIndex, offsetBy: offset)
        }
        if lineIndex < position.line {
            guard let line = self[lineIndex] as? String else {
                return nil
            }
            return line.endIndex
        } else {
            return nil
        }
    }
    
    func positionOfClass(over line: Int) -> (lineIndex: Int, className: String)? {
        for index in (0 ... line).reversed() {
            guard index < self.count else {
                continue
            }
            guard let line = self[index] as? String else {
                continue
            }
            guard let className = line.className() else {
                continue
            }
            return (lineIndex: index, className: className)
        }
        
        return nil
    }
    
    func addSwiftExtension(for position: DHTextPosition) -> DHTextRange {
        let errorRange = DHTextRange(start: position, end: position)
        guard let classInfo = positionOfClass(over: position.line) else {
            return errorRange
        }
        let nextLineIndex = classInfo.lineIndex + 1
        guard nextLineIndex < self.count else {
            return errorRange
        }
        let nextLinePosition = DHTextPosition(line: nextLineIndex, column: 2)
        guard let classEndPosition = self.positionOfBlockEnd(from: nextLinePosition, startBlockMarker: "{", endBlockMarker: "}") else {
            return errorRange
        }
        
        let extensionBegin = "extension \(classInfo.className): "
        let protocolName = "<#Protocol#>"
        var insertPosition = classEndPosition.line + 1
        self.insert("", at: insertPosition)
        insertPosition += 1
        self.insert("\(extensionBegin)\(protocolName) {", at: insertPosition)
        insertPosition += 1
        self.insert("    ", at: insertPosition)
        insertPosition += 1
        self.insert("}", at: insertPosition)
        
        let selectionStart = DHTextPosition(line: insertPosition - 2, column: extensionBegin.count)
        let selectionEnd = DHTextPosition(line: insertPosition - 2, column: extensionBegin.count + protocolName.count)
        return DHTextRange(start: selectionStart, end: selectionEnd)
    }
    
    func removeSpaces() {
        let regex = try! NSRegularExpression(pattern: " +$")
        for lineIndex in 0 ..< count {
            guard let sourceLine = (self[lineIndex]) as? String else {
                continue
            }
            let range = NSMakeRange(0, sourceLine.count)
            let fixedLine = regex.stringByReplacingMatches(in: sourceLine, options: [], range: range, withTemplate: "")
            self[lineIndex] = fixedLine
        }
    }
}
