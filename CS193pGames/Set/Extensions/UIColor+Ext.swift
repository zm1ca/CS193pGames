//
//  UIColor+Ext.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 14.12.20.
//

import UIKit

extension UIColor {
  static func appColor(_ name: AssetsColor) -> UIColor? {
     return UIColor(named: name.rawValue)
  }
}
