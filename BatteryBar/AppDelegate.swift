//
//  AppDelegate.swift
//  BatteryBar
//
//  Created by ad laos on 12/14/16.
//  Copyright © 2016 adlaos. All rights reserved.
//

import Cocoa
import IOKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var itemItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = statusMenu
        
        if let icon = NSImage(named: "statusIcon") {
            icon.isTemplate = true
            statusItem.image = icon
            statusItem.menu = statusMenu
        }
        
        let bleh = runCommand(cmd: "/usr/bin/pmset", args: "-g", "batt")
        print(bleh)
        let out = bleh.output[1]
        let split = out.components(separatedBy: ";")
        let ping = split[2].trimmingCharacters(in: .whitespacesAndNewlines)
        let presentRange = ping.range(of: "present")
        let substrinigngign = ping.substring(to: presentRange!.lowerBound).trimmingCharacters(in: .whitespaces)
        itemItem.title = substrinigngign
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func runCommand(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
        let task = Process()
        task.launchPath = cmd
        task.arguments = args
        
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe
        
        task.launch()
        
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        let outString = String(data: outdata, encoding: .utf8)
        let trimmedOutString = outString?.trimmingCharacters(in: .newlines)
        let output = trimmedOutString?.components(separatedBy: "\n")
        
        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        let errString = String(data: errdata, encoding: .utf8)
        let trimmedErrString = errString?.trimmingCharacters(in: .newlines)
        let error = trimmedErrString?.components(separatedBy: "\n")
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (output!, error!, status)
    }
}
