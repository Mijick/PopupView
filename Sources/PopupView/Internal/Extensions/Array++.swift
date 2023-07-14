//
//  Array++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import Foundation

extension Array {
    @inlinable mutating func append(_ newElement: Element, if prerequisite: Bool) {
        if prerequisite { append(newElement) }
        
    }
    
    @discardableResult
    @inlinable mutating func removeAllUpToElement(where predicate: (Element) -> Bool) -> [Element] {
        var removeItems: [Element] = []
        if let index = lastIndex(where: predicate) {
            removeItems = Array(self[index...])
            removeLast(count - index - 1)
        }
        return removeItems
    }
    
    @discardableResult
    @inlinable mutating func removeLast() -> Element? {
        let e = self.last
        if !isEmpty { removeLast(1) }
        return e
    }
    
    @inlinable mutating func replaceLast(_ newElement: Element, if prerequisite: Bool) {
        if prerequisite {
            switch isEmpty {
            case true: append(newElement)
            case false: self[count - 1] = newElement
            }
        }
    }
}
extension Array {
    var nextToLast: Element? { count >= 2 ? self[count - 2] : nil }
}

