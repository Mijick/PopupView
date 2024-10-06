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
    private(set) var id: PopupID
    let config: LocalConfig

    private var dismissTimer: PopupActionScheduler? = nil


    var height: CGFloat? = nil
    var dragHeight: CGFloat? = nil


    private var _body: AnyView


    private let _onFocus: () -> ()
    private let _onDismiss: () -> ()
}

extension AnyPopup {
    init<P: Popup>(from popup: P, popupManager: PopupManager? = nil) {
        if let popup = popup as? AnyPopup { self = popup }
        else {
            self.id = .create(from: P.self)
            self.config = popup.configurePopup(popup: .init())
            self._body = AnyView(popup)
            self._onFocus = popup.onFocus
            self._onDismiss = popup.onDismiss
        }


        if let popupManager {
            dismissTimer?.schedule { [self] in
                popupManager.stack(.removePopupInstance(self))
            }
        }
    }
}

extension AnyPopup {
    func settingID(customID: String) -> AnyPopup { updatingPopup { $0.id = .create(from: customID) }}
    func settingTimer(secondsToDismiss: Double) -> AnyPopup { updatingPopup { $0.dismissTimer = .init(secondsToDismiss: secondsToDismiss) }}
    func settingHeight(newHeight: CGFloat?) -> AnyPopup { updatingPopup { $0.height = newHeight }}
    func settingDragHeight(newDragHeight: CGFloat?) -> AnyPopup { updatingPopup { $0.dragHeight = newDragHeight }}
    func settingEnvironmentObject(environmentObject: some ObservableObject) -> AnyPopup { updatingPopup { $0._body = AnyView(_body.environmentObject(environmentObject)) }}
}
private extension AnyPopup {
    func updatingPopup(_ customBuilder: (inout AnyPopup) -> ()) -> AnyPopup {
        var popup = self
        customBuilder(&popup)
        return popup
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
