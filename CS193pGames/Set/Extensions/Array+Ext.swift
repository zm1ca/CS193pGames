//
//  Array+Ext.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 9.12.20.
//

import Foundation

extension Array {
    mutating func remove(at indices: [Int]) {
        let sortedIndices = indices.sorted(by: <)
        self.remove(at: sortedIndices[2])
        self.remove(at: sortedIndices[1])
        self.remove(at: sortedIndices[0])
    }
}
