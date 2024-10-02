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
    
    let id: ID
    let config: LocalConfig
    var dismissTimer: DispatchSourceTimer? = nil
    var onDismiss: (() -> ())? = nil
    var height: CGFloat? = nil
    var dragHeight: CGFloat? = nil
    private let _body: AnyView



    init(_ popup: some Popup, environmentObject: (any ObservableObject)? = nil) {
        if let popup = popup as? AnyPopup {
            self = popup
            return
        }

        self.id = popup.id
        self.config = popup.configurePopup(popup: .init())
        self._body = popup.erased(with: environmentObject)
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
