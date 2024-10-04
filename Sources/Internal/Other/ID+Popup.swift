//
//  ID+Popup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

public struct PopupID {
    let value: String
}

// MARK: - Initialisers
extension PopupID {
    init<P: Popup>(_ object: P) { self.init(P.self) }
    init<P: Popup>(_ type: P.Type) { self.value = .init(describing: P.self) + Self.separator + .init(describing: Date()) }
    init() { self.value = "" }
}

// MARK: - Equatable
extension PopupID: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool { lhs.value == rhs.value }
    public static func ~=(lhs: Self, rhs: Self) -> Bool { getComponent(lhs) == getComponent(rhs) }
}

// MARK: - Hashing
extension PopupID: Hashable {
    public func hash(into hasher: inout Hasher) { hasher.combine(Self.getComponent(self)) }
}


// MARK: - Helpers
private extension PopupID {
    static func getComponent(_ object: Self) -> String { object.value.components(separatedBy: separator).first ?? "" }
}
private extension PopupID {
    static var separator: String { "/{}/" }
}
