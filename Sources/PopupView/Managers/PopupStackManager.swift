//
//  PopupStackManager.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

class PopupStackManager: ObservableObject {
    @Published private var views: [any Popup] = []

    static let shared: PopupStackManager = .init()
    private init() {}
}

extension PopupStackManager {
    func present(_ popup: some Popup) {
        views.append(popup, if: canBeInserted(popup))
    }
    func dismiss() {
        views.removeLast()
    }
}

extension PopupStackManager {
    var top: [AnyTopPopup] { views.compactMap { $0 as? AnyTopPopup } }
    var centre: [AnyCentrePopup] { views.compactMap { $0 as? AnyCentrePopup } }
    var bottom: [AnyBottomPopup] { views.compactMap { $0 as? AnyBottomPopup } }
    var isEmpty: Bool { views.isEmpty }
}

extension PopupStackManager {
    func canBeInserted(_ popup: some Popup) -> Bool { !views.contains(where: { $0.id == popup.id }) }
    func canBeDismissed() -> Bool { !views.isEmpty }
}
