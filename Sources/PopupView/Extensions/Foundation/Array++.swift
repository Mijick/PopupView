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
    @inlinable mutating func append(_ newElement: Element, if prerequisite: Bool) { if prerequisite { append(newElement) } }
    @inlinable mutating func removeAllUpToElement(where predicate: (Element) -> Bool) { if let index = lastIndex(where: predicate) { removeLast(count - index - 1) } }
    @inlinable mutating func removeLast() { if !isEmpty { removeLast(1) } }
    @inlinable mutating func replaceLast(_ newElement: Element, if prerequisite: Bool) { if prerequisite {
        switch isEmpty {
            case true: append(newElement)
            case false: self[count - 1] = newElement
        }
    }}
}
