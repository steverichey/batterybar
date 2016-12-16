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
    @IBOutlet weak var timeRemainingItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    var showTimeInMenuBar = false
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = statusMenu
        
        resetMenuBarIcon()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if let result = self.getTimeRemaining() {
                if self.showTimeInMenuBar {
                    self.statusItem.title = result
                    self.statusItem.image = nil
                } else {
                    self.timeRemainingItem.title = result
                }
            }
        }
    }
    
    func resetMenuBarIcon() {
        if let icon = NSImage(named: "statusIcon") {
            icon.isTemplate = true
            statusItem.image = icon
            statusItem.title = nil
        }
    }
    
    func getTimeRemaining() -> String? {
        guard let commandResult = runCommand(cmd: "/usr/bin/pmset", args: "-g", "batt") else {
            return nil
        }
        
        guard let remainingComponent = commandResult.output[safe: 1] else {
            return nil
        }
        
        let remainingSplit = remainingComponent.components(separatedBy: ";")
        
        guard let untrimmedTitle = remainingSplit[safe: 2]?.toPositionOf(string: "present") else {
            return nil
        }
        
        return untrimmedTitle.trimmingCharacters(in: .whitespaces)
    }
    
    func runCommand(cmd: String, args: String...) -> CommandResult? {
        let task = Process()
        task.launchPath = cmd
        task.arguments = args
        
        let outPipe = Pipe()
        task.standardOutput = outPipe
        let errorPipe = Pipe()
        task.standardError = errorPipe
        
        task.launch()
        
        guard let output = readResultLines(fromPipe: outPipe) else {
            return nil
        }
        
        guard let error = readResultLines(fromPipe: errorPipe) else {
            return nil
        }
        
        task.waitUntilExit()
        
        return CommandResult(exitCode: task.terminationStatus, output: output, error: error)
    }
    
    func readResultLines(fromPipe pipe: Pipe) -> [String]? {
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let dataString = String(data: data, encoding: .utf8)
        let trimmedDataString = dataString?.trimmingCharacters(in: .newlines)
        return trimmedDataString?.components(separatedBy: "\n")
    }
    
    @IBAction func onShowTimeInMenuBarSelected(_ sender: NSMenuItem) {
        showTimeInMenuBar = !showTimeInMenuBar
        sender.state = showTimeInMenuBar ? NSOnState : NSOffState
        
        if !showTimeInMenuBar {
            resetMenuBarIcon()
        }
    }
    
    @IBAction func onQuitSelected(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
}
