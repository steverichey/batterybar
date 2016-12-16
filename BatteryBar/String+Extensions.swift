//
//  String+Extensions.swift
//  BatteryBar
//
//  Created by ad laos on 12/15/16.
//  Copyright © 2016 adlaos. All rights reserved.
//

import Foundation

extension String {
    func toPositionOf(string substring: String) -> String? {
        guard let substringRange = self.range(of: substring) else {
            return nil
        }
        
        return self.substring(to: substringRange.lowerBound)
    }
}
