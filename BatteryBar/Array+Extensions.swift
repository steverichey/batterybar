//
//  Array+Extensions.swift
//  BatteryBar
//
//  Created by ad laos on 12/15/16.
//  Copyright © 2016 adlaos. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
