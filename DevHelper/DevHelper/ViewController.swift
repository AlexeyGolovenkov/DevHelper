//
//  ViewController.swift
//  DevHelper
//
//  Created by Alexey Golovenkov on 11.03.17.
//  Copyright © 2017 Alexey Golovenkov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		(NSApplication.shared.delegate as? AppDelegate)?.mainWindowIsClosed = false
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
    
    override func viewDidDisappear() {
        (NSApplication.shared.delegate as? AppDelegate)?.mainWindowIsClosed = true
    }
}
