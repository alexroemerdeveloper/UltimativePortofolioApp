//
//  Sequence-Sorting.swift
//  UltimativePortofolioApp
//
//  Created by Alexander Römer on 07.11.20.
//

import Foundation

extension Sequence {
    
    func sorted<Value>(by keyPath: KeyPath<Element, Value>, using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Element] {
        try self.sorted {
            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }
    
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        self.sorted(by: keyPath, using: <)
    }
    
    //    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
    //        self.sorted(by: keyPath, using: <)
    //    }
    //
    //    func sorted<Value>(by keyPath: KeyPath<Element, Value>, using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Element] {
    //        try self.sorted {
    //            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
    //        }
    //    }
    //
    //    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
    //        self.sorted {
    //            $0[keyPath: keyPath] < $1[keyPath: keyPath]
    //        }
    //    }
    
    //    func sorted(by keyPath: PartialKeyPath<Element>) -> [Element] {
    //        guard let keyPathString = keyPath._kvcKeyPathString else { return Array(self) }
    //        let sortDescriptor = NSSortDescriptor(key: keyPathString, ascending: true)
    //        return self.sorted(by: sortDescriptor)
    //    }
    //
    //    func sorted<Value>(by keyPath: PartialKeyPath<Element>, using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Element] {
    //        try self.sorted {
    //            guard let value1 = $0[keyPath: keyPath] as? Value else { return false }
    //            guard let value2 = $1[keyPath: keyPath] as? Value else { return false }
    //            return try areInIncreasingOrder(value1, value2)
    //        }
    //    }
    //
    //    func sorted<Value: Comparable>(by keyPath: PartialKeyPath<Element>, as: Value.Type? = nil) -> [Element] {
    //        let function: (Value, Value) -> Bool = (<)
    //        return self.sorted(by: keyPath, using: function)
    //    }
    //
    //    func sorted(by sortDescriptor: NSSortDescriptor) -> [Element] {
    //        self.sorted {
    //            sortDescriptor.compare($0, to: $1) == .orderedAscending
    //        }
    //    }
    //
    //    func sorted(by sortDescriptors: [NSSortDescriptor]) -> [Element] {
    //        self.sorted {
    //            for descriptor in sortDescriptors {
    //                switch descriptor.compare($0, to: $1) {
    //                case .orderedAscending:
    //                    return true
    //                case .orderedDescending:
    //                    return false
    //                case .orderedSame:
    //                    continue
    //                }
    //            }
    //
    //            return false
    //        }
    //    }
}

