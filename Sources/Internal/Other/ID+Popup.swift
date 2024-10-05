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
    let rawValue: String

    // MARK: Initialiser
    init(rawValue: String) { self.rawValue = rawValue + Self.separator + .init(describing: Date()) }
    init<P: Popup>(_ type: P.Type) { self.rawValue = .init(describing: P.self) + Self.separator + .init(describing: Date()) }
    init<P: Popup>(_ object: P) { self.init(P.self) }
}

// MARK: - Equatable
extension PopupID: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool { lhs.rawValue == rhs.rawValue }
    public static func ~=(lhs: Self, rhs: Self) -> Bool { getComponent(lhs) == getComponent(rhs) }
}

// MARK: - Hashing
extension PopupID: Hashable {
    public func hash(into hasher: inout Hasher) { hasher.combine(Self.getComponent(self)) }
}


// MARK: - Helpers
private extension PopupID {
    static func getComponent(_ object: Self) -> String { object.rawValue.components(separatedBy: separator).first ?? "" }
}
private extension PopupID {
    static var separator: String { "/{}/" }
}
