//
//  String+Test.swift
//  DevHelper
//
//  Created by Alexey Golovenkov on 11.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Foundation

extension String {
	
	init?(testFileName: String) {
		let bundle = Bundle(for: SortCommandTests.self)
		guard let path = bundle.path(forResource: testFileName, ofType: nil) else {
			return nil
		}
		
		do {
			self = try String(contentsOfFile: path)
		} catch {
			return nil
		}
	}
	
	func lines() -> NSMutableArray {
		let components = self.components(separatedBy: "\n")
		return NSMutableArray(array: components)
	}
}
