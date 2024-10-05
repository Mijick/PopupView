//
//  Array++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


// MARK: Mutable
extension Array {
    @inlinable mutating func append(_ newElement: Element, if shouldAppend: Bool) { if shouldAppend { append(newElement) }}
    @inlinable mutating func safelyRemoveLast() { if !isEmpty { removeLast(1) }}
}

// MARK: Immutable
extension Array {
    @inlinable func appending(_ newElement: Element) -> Self { self + [newElement] }
}
