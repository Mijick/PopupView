//
//  AnyPopup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct AnyPopup: View, Hashable {
    let id: ID
    let config: any Configurable
    private let _body: AnyView

    
    init(_ popup: some Popup) {
        self.id = popup.id
        self.config = popup.configurePopup(popup: .init())
        self._body = popup.erased(with: PopupManager.shared.popupTemp.environmentObject)
    }
    var body: some View { _body }
}

// MARK: - Hashable
extension AnyPopup {
    static func == (lhs: AnyPopup, rhs: AnyPopup) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
