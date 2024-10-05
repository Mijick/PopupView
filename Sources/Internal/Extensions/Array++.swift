//
//  Array++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import Foundation

// MARK: Mutable
extension Array {
    @inlinable mutating func append(_ newElement: Element, if prerequisite: Bool) { if prerequisite { append(newElement) } }
    @inlinable mutating func removeLast() { if !isEmpty { removeLast(1) } }
}

// MARK: Immutable
extension Array {
    @inlinable func appending(_ newElement: Element) -> Self { self + [newElement] }
}

// MARK: Others
extension Array {
    var nextToLast: Element? { count >= 2 ? self[count - 2] : nil }
}
