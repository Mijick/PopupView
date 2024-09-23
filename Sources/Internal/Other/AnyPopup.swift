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
    let config: LocalConfig
    let dismissTimer: DispatchSourceTimer?
    let onDismiss: () -> ()
    var height: CGFloat?
    var dragHeight: CGFloat?
    private let _body: AnyView



    init(_ popup: some Popup) { let temp = PopupManager.readAndResetTempValues()
        self.id = popup.id
        self.config = popup.configurePopup(popup: .init())
        self.dismissTimer = temp.dismissTimer
        self.onDismiss = temp.onDismiss
        self.height = nil
        self.dragHeight = nil
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
    var dismissTimer: DispatchSourceTimer? = nil
    var onDismiss: () -> () = {}
}}


// MARK: - Testing
#if DEBUG
extension AnyPopup {
    init(config: LocalConfig) {
        self.id = .init(value: "")
        self.config = config
        self.dismissTimer = nil
        self.onDismiss = {}
        self.height = nil
        self.dragHeight = nil
        self._body = .init(erasing: EmptyView())
    }
}
#endif
