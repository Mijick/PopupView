//
//  AnyPopup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct AnyPopup: Popup {
    var id: PopupID
    let config: LocalConfig

    var dismissTimer: PopupActionScheduler? = nil


    var height: CGFloat? = nil
    var dragHeight: CGFloat? = nil
    var _body: AnyView


    private let _onFocus: () -> ()
    private let _onDismiss: () -> ()
}

extension AnyPopup {
    init<P: Popup>(from popup: P, popupManager: PopupManager? = nil, customBuilder: (inout AnyPopup) -> () = { _ in }) {
        if let popup = popup as? AnyPopup {
            self = popup
        } else {
            self.id = .create(from: P.self)
            self.config = popup.configurePopup(popup: .init())
            self._body = AnyView(popup)
            self._onFocus = popup.onFocus
            self._onDismiss = popup.onDismiss
        }

        customBuilder(&self)

        if let popupManager {
            dismissTimer?.schedule { [self] in
                popupManager.stack(.removePopupInstance(self))
            }
        }
    }
}

// MARK: Popup
extension AnyPopup {
    var body: some View { _body }
    func onFocus() { _onFocus() }
    func onDismiss() { _onDismiss() }

    typealias Config = LocalConfig
}




// MARK: Hashable
extension AnyPopup: Hashable {
    nonisolated static func == (lhs: AnyPopup, rhs: AnyPopup) -> Bool { lhs.id.isSameInstance(as: rhs) }
    nonisolated func hash(into hasher: inout Hasher) { hasher.combine(id.rawValue) }
}






// MARK: - Testing
#if DEBUG
extension AnyPopup {
    init(id: String = UUID().uuidString, config: LocalConfig) {
        self.id = .create(from: id)
        self.config = config
        self.dismissTimer = nil
        self.height = nil
        self.dragHeight = nil
        self._onFocus = {}
        self._onDismiss = {}
        self._body = .init(erasing: EmptyView())
    }
}
#endif
