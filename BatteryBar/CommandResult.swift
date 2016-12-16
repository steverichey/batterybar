//
//  CommandResult.swift
//  BatteryBar
//
//  Created by ad laos on 12/15/16.
//  Copyright © 2016 adlaos. All rights reserved.
//

import Foundation

struct CommandResult : CustomStringConvertible {
    let exitCode: Int32
    let output: [String]
    let error: [String]
    
    var description: String {
        return String(exitCode) + output.joined() + error.joined()
    }
}
