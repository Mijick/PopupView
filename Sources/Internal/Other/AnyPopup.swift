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
    let isOverlayHidden: Bool
    let onDismiss: () -> ()
    private let _body: AnyView

    
    init(_ popup: some Popup) { let temp = PopupManager.readAndResetTempValues()
        self.id = popup.id
        self.config = popup.configurePopup(popup: .init())
        self.isOverlayHidden = temp.isOverlayHidden
        self.onDismiss = temp.onDismiss
        self._body = popup.erased(with: temp.environmentObject)
    }
    var body: some View { _body }
}

// MARK: - Hashable
extension AnyPopup {
    static func == (lhs: AnyPopup, rhs: AnyPopup) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}


// MARK: - Temporary Values
extension AnyPopup { struct Temp {
    var environmentObject: (any ObservableObject)? = nil
    var isOverlayHidden: Bool = false
    var onDismiss: () -> () = {}
}}
