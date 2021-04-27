//
//  AppDelegate.swift
//  Pitch
//
//  Created by Keeper on 17/05/2018.
//  Copyright © 2018 Keeper. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    let windowController = NSWindowController(windowNibName: "MainWindow")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        windowController.showWindow(self)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
