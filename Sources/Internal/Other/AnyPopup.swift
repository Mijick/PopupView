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

    var dismissTimer: PopupActionScheduler? = nil

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
            dismissTimer?.startTimer { [self] in
                print(self.id.value)
                PopupManager.getInstance(id).dismissPopup(id: self.id.value)
            }
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



class PopupActionScheduler {
    private var secondsToDismiss: Double
    private var action: DispatchSourceTimer?

    init(secondsToDismiss: Double) { self.secondsToDismiss = secondsToDismiss }
}

extension PopupActionScheduler {
    func startTimer(action: @escaping () -> ()) {
        self.action = DispatchSource.makeTimerSource(queue: .main)
        self.action?.schedule(deadline: .now() + max(0.6, secondsToDismiss))
        self.action?.setEventHandler(handler: action)
        self.action?.resume()
    }
}
