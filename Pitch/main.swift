//
//  main.swift
//  Pitch
//
//  Created by Keeper on 16/04/2019.
//  Copyright © 2019 Keeper. All rights reserved.
//

import Cocoa

let app = NSApplication.shared
NSApp.setActivationPolicy(.regular)
NSApp.activate(ignoringOtherApps: true)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
