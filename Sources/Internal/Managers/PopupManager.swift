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
    @Published private(set) var views: [AnyPopup] = [] { willSet { onViewsChanged(newValue) }}
    private(set) var popupTemp: AnyPopupTemp = .init()
    private(set) var popupsWithoutOverlay: [ID] = []
    private(set) var popupsToBeDismissed: [ID: DispatchSourceTimer] = [:]
    private(set) var popupActionsOnDismiss: [ID: () -> ()] = [:]

    static let shared: PopupManager = .init()
    private init() {}
}
private extension PopupManager {
    func onViewsChanged(_ newViews: [AnyPopup]) { newViews
        .difference(from: views, by: { $0.id == $1.id })
        .forEach { switch $0 {
            case .remove(_, let element, _): popupActionsOnDismiss[element.id]?(); popupActionsOnDismiss.removeValue(forKey: element.id)
            default: return
        }}
    }
}

// MARK: - Operations
enum StackOperation {
    case insertAndReplace(AnyPopup), insertAndStack(AnyPopup)
    case removeLast, remove(ID), removeAllUpTo(ID), removeAll
}
extension PopupManager {
    static func performOperation(_ operation: StackOperation) {
        removePopupFromStackToBeDismissed(operation)
        perform(operation)
    }
    static func setTempValue(environmentObject: (any ObservableObject)? = nil) {
        if let environmentObject { shared.popupTemp.environmentObject = environmentObject }
    }
    static func resetTempValues() {
        shared.popupTemp = .init()
    }
    static func dismissPopupAfter(_ popup: any Popup, _ seconds: Double) { shared.popupsToBeDismissed[popup.id] = DispatchSource.createAction(deadline: seconds) { performOperation(.remove(popup.id)) } }
    static func hideOverlay(_ popup: any Popup) { shared.popupsWithoutOverlay.append(popup.id) }
    static func onPopupDismiss(_ popup: any Popup, _ action: @escaping () -> ()) { shared.popupActionsOnDismiss[popup.id] = action }
}
private extension PopupManager {
    static func removePopupFromStackToBeDismissed(_ operation: StackOperation) { switch operation {
        case .removeLast: shared.popupsToBeDismissed.removeValue(forKey: shared.views.last?.id ?? .init())
        case .remove(let id): shared.popupsToBeDismissed.removeValue(forKey: id)
        case .removeAllUpTo, .removeAll: shared.popupsToBeDismissed.removeAll()
        default: break
    }}
    static func perform(_ operation: StackOperation) { Task { @MainActor in
        shared.views.perform(operation)
    }}
}

fileprivate extension [AnyPopup] {
    @MainActor mutating func perform(_ operation: StackOperation) {
        hideKeyboard()
        performOperation(operation)
    }
}
private extension [AnyPopup] {
    @MainActor func hideKeyboard() { KeyboardManager.hideKeyboard() }
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
private extension [AnyPopup] {
    func canBeInserted(_ popup: AnyPopup) -> Bool { !contains(where: { $0.id ~= popup.id }) }
}
