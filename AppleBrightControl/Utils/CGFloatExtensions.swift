//
//  CGFloatExtensions.swift
//  AppleBrightControl
//
//  Created by Victor Magalhaes on 18/07/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

extension CGFloat {
    var brightLevel: BrightLevel {
        switch self {
        case (0..<0.33): return .low
        case (0.33..<0.66): return .mid
        case (0.66..<0.99): return .high
        default: return .max
        }
    }
    
    var limited: CGFloat {
        return CGFloat(Swift.min(1, Swift.max(self, 0)))
    }
}
