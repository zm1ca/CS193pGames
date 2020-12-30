//
//  GlowType.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 29.12.20.
//

import UIKit

enum GlowType {
    case selected
    case matched
    case mismatched
    case usual
    
    var color: UIColor {
        switch self {
        case .selected:
            return UIColor.appColor(.glowSelected)!
        case .matched:
            return UIColor.appColor(.glowMatched)!
        case .mismatched:
            return UIColor.appColor(.glowMismatched)!
        case .usual:
            return UIColor.appColor(.glowUsual)!
        }
    }
}
