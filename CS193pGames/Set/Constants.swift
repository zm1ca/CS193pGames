//
//  Constants.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 29.12.20.
//

import UIKit


enum AssetsColor : String {
    case shapeRed
    case shapeGreen
    case shapeBlue
    case cardFaceUp
    case cardFaceDown
    case glowSelected
    case glowMatched
    case glowMismatched
    case glowUsual
}


struct AnimationConstants {
    static let numberOfSpins:       Double = 3.0
    static let singleSpinTime:      Double = 0.6
    static let cardFlipOverTime:    Double = 0.7
    static let chaoticBouncingTime: Double = totalSpinningTime
    static let cardEscapeTime:      Double = 1.0
    static let rearrangementTime:   Double = 0.7
    
    static var totalSpinningTime:       Double { numberOfSpins * singleSpinTime }
    static var dealingDelayMultiplier:  Double { totalSpinningTime / 4 }
}
