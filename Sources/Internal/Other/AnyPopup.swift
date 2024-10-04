//
//  AnyPopup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct AnyPopup: Popup, Hashable {
    func createContent() -> AnyView { fatalError() }

    typealias Config = LocalConfig
    
    let id: PopupID
    let config: LocalConfig

    var dismissTimer: PopupDismisser? = nil

    var onDismiss: (() -> ())? = nil
    var height: CGFloat? = nil
    var dragHeight: CGFloat? = nil
    var _body: AnyView


    init(_ popup: some Popup, id: PopupManagerID?) {
        if let popup = popup as? AnyPopup {
            self = popup
            
        } else {


            self.id = popup.id
            self.config = popup.configurePopup(popup: .init())
            self._body = AnyView(popup)
        }


        if let id {
            dismissTimer?.startTimer(on: PopupManager.getInstance(id), for: self)
        }
    }
    var body: some View { _body }
}

// MARK: - Hashable
extension AnyPopup {
    static func == (lhs: AnyPopup, rhs: AnyPopup) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}


// MARK: - Testing
#if DEBUG
extension AnyPopup {
    init(config: LocalConfig) {
        self.id = .init(value: UUID().uuidString)
        self.config = config
        self.dismissTimer = nil
        self.onDismiss = {}
        self.height = nil
        self.dragHeight = nil
        self._body = .init(erasing: EmptyView())
    }
}
#endif



class PopupDismisser {
    private var secondsToDismiss: Double
    private var action: DispatchSourceTimer? = nil

    init(secondsToDismiss: Double) { self.secondsToDismiss = secondsToDismiss }
}

extension PopupDismisser {
    func startTimer(on popupManager: PopupManager, for popup: some Popup) {
        action = DispatchSource.createAction(deadline: secondsToDismiss) { popupManager.dismissPopup(id: popup.id.value) }
    }
}



extension DispatchSource {
    static func createAction(deadline seconds: Double, event: @escaping () -> ()) -> DispatchSourceTimer {
        let action = DispatchSource.makeTimerSource(queue: .main)
        action.schedule(deadline: .now() + max(0.6, seconds))
        action.setEventHandler(handler: event)
        action.resume()
        return action
    }
}
