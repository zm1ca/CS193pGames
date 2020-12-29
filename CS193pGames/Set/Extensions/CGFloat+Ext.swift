//
//  CGFloat+Ext.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 28.12.20.
//

import CoreGraphics

extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
