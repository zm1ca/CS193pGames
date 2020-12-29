//
//  CGPoint+Ext.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 11.12.20.
//

import CoreGraphics

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
