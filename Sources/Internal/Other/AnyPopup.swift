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
    private(set) var config: LocalConfig
    private(set) var height: CGFloat? = nil
    private(set) var dragHeight: CGFloat? = nil

    private var dismissTimer: PopupActionScheduler? = nil
    private var _body: AnyView
    private let _onFocus: () -> ()
    private let _onDismiss: () -> ()
}



// MARK: - INITIALISE & UPDATE



// MARK: Initialise
extension AnyPopup {
    init<P: Popup>(_ popup: P) {
        if let popup = popup as? AnyPopup { self = popup }
        else {
            self.id = .create(from: P.self)
            self.config = popup.configurePopup(popup: .init())
            self._body = AnyView(popup)
            self._onFocus = popup.onFocus
            self._onDismiss = popup.onDismiss
        }
    }
}

// MARK: Update
extension AnyPopup {
    func settingCustomID(_ customID: String) -> AnyPopup { updatingPopup { $0.id = .create(from: customID) }}
    func settingDismissTimer(_ secondsToDismiss: Double) -> AnyPopup { updatingPopup { $0.dismissTimer = .prepare(time: secondsToDismiss) }}
    func startingDismissTimerIfNeeded(_ popupManager: PopupManager) -> AnyPopup { updatingPopup { $0.dismissTimer?.schedule { popupManager.stack(.removePopupInstance(self)) }}}
    func settingHeight(_ newHeight: CGFloat?) -> AnyPopup { updatingPopup { $0.height = newHeight }}
    func settingDragHeight(_ newDragHeight: CGFloat?) -> AnyPopup { updatingPopup { $0.dragHeight = newDragHeight }}
    func settingEnvironmentObject(_ environmentObject: some ObservableObject) -> AnyPopup { updatingPopup { $0._body = AnyView(_body.environmentObject(environmentObject)) }}
}
private extension AnyPopup {
    func updatingPopup(_ customBuilder: (inout AnyPopup) -> ()) -> AnyPopup {
        var popup = self
        customBuilder(&popup)
        return popup
    }
}



// MARK: - PROTOCOLS CONFORMANCE



// MARK: Popup
extension AnyPopup { typealias Config = LocalConfig
    var body: some View { _body }

    func onFocus() { _onFocus() }
    func onDismiss() { _onDismiss() }
}

// MARK: Hashable
extension AnyPopup: Hashable {
    nonisolated static func ==(lhs: AnyPopup, rhs: AnyPopup) -> Bool { lhs.id.isSameInstance(as: rhs) }
    nonisolated func hash(into hasher: inout Hasher) { hasher.combine(id.rawValue) }
}



// MARK: - TESTS
#if DEBUG



// MARK: New Object
extension AnyPopup {
    static func t_createNew(id: String = UUID().uuidString, config: LocalConfig) -> AnyPopup { .init(
        id: .create(from: id),
        config: config,
        height: nil,
        dragHeight: nil,
        dismissTimer: nil,
        _body: .init(EmptyView()),
        _onFocus: {},
        _onDismiss: {}
    )}
}
#endif
