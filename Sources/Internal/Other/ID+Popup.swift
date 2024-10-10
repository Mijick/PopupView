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

struct PopupID {
    let rawValue: String
}

// MARK: Create
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

// MARK: Comparison
extension PopupID {
    func isSameType(as id: String) -> Bool { getFirstComponent(of: self) == id }
    func isSameType(as popupType: any Popup.Type) -> Bool { getFirstComponent(of: self) == String(describing: popupType) }
    func isSameType(as popupID: PopupID) -> Bool { getFirstComponent(of: self) == getFirstComponent(of: popupID) }
    func isSameInstance(as popup: AnyPopup) -> Bool { rawValue == popup.id.rawValue }
}



// MARK: - HELPERS



// MARK: Methods
private extension PopupID {
    func getFirstComponent(of object: Self) -> String { object.rawValue.components(separatedBy: Self.separator).first ?? "" }
}

// MARK: Variables
private extension PopupID {
    static var separator: String { "/{}/" }
}
