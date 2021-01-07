//
//  Sequence-Sorting.swift
//  Portfolio
//
//  Created by Paul Jackson on 06/11/2020.
//

import Foundation

extension Sequence {
    /// Orders a sequence by using `NSSortDescriptor` instances.
    ///
    /// - Parameter sortDescriptor: `NSSortDescriptor` instance to order the sequence by.
    /// - Returns: Array of sorted elements based on the sort descriptor.
    func sorted(by sortDescriptor: NSSortDescriptor) -> [Element] {
        self.sorted {
            sortDescriptor.compare($0, to: $1) == .orderedAscending
        }
    }

    /// Orders a sequence by using an array of `NSSortDescriptor` instances.
    /// 
    /// - Parameter sortDescriptors: Array of `NSSortDescriptor` instances to order the sequence by.
    /// - Returns: Array or sorted elements based on the sort descriptors array.
    func sorted(by sortDescriptors: [NSSortDescriptor]) -> [Element] {
        self.sorted {
            for descriptor in sortDescriptors {
                switch descriptor.compare($0, to: $1) {
                case .orderedAscending:
                    return true
                case .orderedDescending:
                    return false
                case .orderedSame:
                    continue
                }
            }

            return false
        }
    }
}
