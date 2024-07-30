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
    @Published private(set) var views: [any Popup] = []
    private(set) var presenting: Bool = true
    private(set) var popupsWithoutOverlay: [ID] = []
    private(set) var popupsToBeDismissed: [ID: DispatchSourceTimer] = [:]

    static let shared: PopupManager = .init()
    private init() {}
}

// MARK: - Operations
enum StackOperation {
    case insertAndReplace(any Popup), insertAndStack(any Popup)
    case removeLast, remove(ID), removeAllUpTo(ID), removeAll
}
extension PopupManager {
    static func performOperation(_ operation: StackOperation) { DispatchQueue.main.async {
        removePopupFromStackToBeDismissed(operation)
        updateOperationType(operation)
        shared.views.perform(operation)
    }}
    static func dismissPopupAfter(_ popup: any Popup, _ seconds: Double) { shared.popupsToBeDismissed[popup.id] = DispatchSource.createAction(deadline: seconds) { performOperation(.remove(popup.id)) } }
    static func hideOverlay(_ popup: any Popup) { shared.popupsWithoutOverlay.append(popup.id) }
}
private extension PopupManager {
    static func removePopupFromStackToBeDismissed(_ operation: StackOperation) { switch operation {
        case .removeLast: shared.popupsToBeDismissed.removeValue(forKey: shared.views.last?.id ?? .init())
        case .remove(let id): shared.popupsToBeDismissed.removeValue(forKey: id)
        case .removeAllUpTo, .removeAll: shared.popupsToBeDismissed.removeAll()
        default: break
    }}
    static func updateOperationType(_ operation: StackOperation) { switch operation {
        case .insertAndReplace, .insertAndStack: shared.presenting = true
        case .removeLast, .remove, .removeAllUpTo, .removeAll: shared.presenting = false
    }}
}

fileprivate extension [any Popup] {
    mutating func perform(_ operation: StackOperation) {
        hideKeyboard()
        performOperation(operation)
    }
}
private extension [any Popup] {
    func hideKeyboard() { KeyboardManager.hideKeyboard() }
    mutating func performOperation(_ operation: StackOperation) {
        switch operation {
            case .insertAndReplace(let popup): replaceLast(popup, if: canBeInserted(popup))
            case .insertAndStack(let popup): append(popup, if: canBeInserted(popup))
            case .removeLast: removeLast()
            case .remove(let id): removeAll(where: { $0.id ~= id })
            case .removeAllUpTo(let id): removeAllUpToElement(where: { $0.id ~= id })
            case .removeAll: removeAll()
        }
    }
}
private extension [any Popup] {
    func canBeInserted(_ popup: some Popup) -> Bool { !contains(where: { $0.id ~= popup.id }) }
}
