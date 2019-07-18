//
//  BrightLevel.swift
//  AppleBrightControl
//
//  Created by Victor Magalhaes on 18/07/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

enum BrightLevel {
    case low
    case mid
    case high
    case max
    
    var value: CGFloat {
        switch self {
        case .low: return 0.5
        case .mid: return 1.0
        default: return 1.4
        }
    }
}
