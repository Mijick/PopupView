//
//  PopupManager.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public class PopupManager: ObservableObject {
    @Published private var views: [any Popup] = []

    static let shared: PopupManager = .init()
    private init() {}
}

public extension PopupManager {
    static func dismissLast() { shared.views.removeLast() }
    static func dismiss(id: String) { shared.views.removeAll(where: { $0.id == id }) }
    static func dismissAll() { shared.views.removeAll() }
}

extension PopupManager {
    func present(_ popup: some Popup) {
        views.append(popup, if: canBeInserted(popup))
    }
}

extension PopupManager {
    var top: [AnyTopPopup] { views.compactMap { $0 as? AnyTopPopup } }
    var centre: [AnyCentrePopup] { views.compactMap { $0 as? AnyCentrePopup } }
    var bottom: [AnyBottomPopup] { views.compactMap { $0 as? AnyBottomPopup } }
    var isEmpty: Bool { views.isEmpty }
}

private extension PopupManager {
    func canBeInserted(_ popup: some Popup) -> Bool { !views.contains(where: { $0.id == popup.id }) }
}
