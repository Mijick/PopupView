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
}

extension PopupID {
    static func create(from id: String) -> Self {
        let firstComponent = id,
            secondComponent = separator,
            thirdComponent = String(describing: Date())
        return .init(rawValue: firstComponent + secondComponent + thirdComponent)
    }
    static func create(from popupType: any Popup.Type) -> Self {
        create(from: .init(describing: popupType))
    }
}

// MARK: - Equatable
extension PopupID {
    func isSameType(as id: String) -> Bool { getFirstComponent(of: self) == id }
    func isSameType(as popupType: any Popup.Type) -> Bool { getFirstComponent(of: self) == String(describing: popupType) }
    func isSameType(as popupID: PopupID) -> Bool { getFirstComponent(of: self) == getFirstComponent(of: popupID) }
    func isSameInstance(as id: PopupID) -> Bool { rawValue == id.rawValue }
}

// MARK: - Hashing
extension PopupID: Hashable {
    public func hash(into hasher: inout Hasher) { hasher.combine(getFirstComponent(of: self)) }
}


// MARK: - Helpers
private extension PopupID {
    func getFirstComponent(of object: Self) -> String { object.rawValue.components(separatedBy: Self.separator).first ?? "" }
}
private extension PopupID {
    static var separator: String { "/{}/" }
}
