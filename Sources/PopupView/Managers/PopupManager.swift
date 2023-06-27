//
//  PopupManager.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public extension PopupManager {

    /// Displays the popup. Stacks previous one
    static func showAndStack(_ popup: some Popup) { performOperation(.insertAndStack(popup)) }

    /// Displays the popup. Closes previous one
    static func showAndReplace(_ popup: some Popup) { performOperation(.insertAndReplace(popup)) }

    /// Dismisses last popup on the stack
    static func dismiss() { performOperation(.removeLast) }

    /// Dismisses all popups of provided type on the stack.
    static func dismiss<P: Popup>(_ popup: P.Type) { performOperation(.remove(id: .init(describing: popup))) }

    /// Dismisses all the popups on the stack.
    static func dismissAll() { performOperation(.removeAll) }
}


// MARK: - Internal
public class PopupManager: ObservableObject {
    @Published private(set) var views: [any Popup] = []
    private(set) var presenting: Bool = true

    static let shared: PopupManager = .init()
    private init() {}
}
extension PopupManager {
    var top: [AnyPopup<TopPopupConfig>] { views.compactMap { $0 as? AnyPopup<TopPopupConfig> } }
    var centre: [AnyPopup<CentrePopupConfig>] { views.compactMap { $0 as? AnyPopup<CentrePopupConfig> } }
    var bottom: [AnyPopup<BottomPopupConfig>] { views.compactMap { $0 as? AnyPopup<BottomPopupConfig> } }
    var isEmpty: Bool { views.isEmpty }
}

// MARK: - Operations
fileprivate enum Operation {
    case insertAndReplace(any Popup), insertAndStack(any Popup)
    case removeLast, remove(id: String), removeAll
}
private extension PopupManager {
    static func performOperation(_ operation: Operation) { DispatchQueue.main.async {
        updateOperationType(operation)
        shared.views.perform(operation)
    }}
}
private extension PopupManager {
    static func updateOperationType(_ operation: Operation) {
        switch operation {
            case .insertAndReplace, .insertAndStack: shared.presenting = true
            case .removeLast, .remove, .removeAll: shared.presenting = false
        }
    }
}

fileprivate extension [any Popup] {
    mutating func perform(_ operation: Operation) {
        hideKeyboard()
        performOperation(operation)
    }
}
private extension [any Popup] {
    func hideKeyboard() {
        KeyboardManager.hideKeyboard()
    }
    mutating func performOperation(_ operation: Operation) {
        switch operation {
            case .insertAndReplace(let popup): replaceLast(popup, if: canBeInserted(popup))
            case .insertAndStack(let popup): append(popup, if: canBeInserted(popup))
            case .removeLast: removeLast()
            case .remove(let id): removeAll(where: { $0.id == id })
            case .removeAll: removeAll()
        }
    }
}
private extension [any Popup] {
    func canBeInserted(_ popup: some Popup) -> Bool { !contains(where: { $0.id == popup.id }) }
}
