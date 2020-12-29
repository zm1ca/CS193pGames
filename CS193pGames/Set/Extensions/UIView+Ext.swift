//
//  UIView+Ext.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 11.12.20.
//

import UIKit

extension UIView {
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
