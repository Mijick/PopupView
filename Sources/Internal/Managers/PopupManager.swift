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
    @Published var views: [AnyPopup] = [] { willSet { onViewsChanged(newValue) }}
    private var popupTemp: AnyPopup.Temp = .init()

    static let shared: PopupManager = .init()
    private init() {}
}
private extension PopupManager {
    func onViewsChanged(_ newViews: [AnyPopup]) { newViews
        .difference(from: views)
        .forEach { switch $0 {
            case .remove(_, let element, _): element.onDismiss()
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
    static func performOperation(_ operation: StackOperation) { Task { @MainActor in
        shared.views.perform(operation)
    }}
    static func setTempValue(environmentObject: (any ObservableObject)? = nil, dismissProperties: (popup: any Popup, seconds: Double)? = nil, onDismiss: (() -> ())? = nil) {
        if let environmentObject { shared.popupTemp.environmentObject = environmentObject }
        if let dismissProperties { shared.popupTemp.dismissTimer = DispatchSource.createAction(deadline: dismissProperties.seconds) { performOperation(.remove(dismissProperties.popup.id)) } }
        if let onDismiss { shared.popupTemp.onDismiss = onDismiss }
    }
    static func readAndResetTempValues() -> AnyPopup.Temp {
        let temp = shared.popupTemp
        shared.popupTemp = .init()
        return temp
    }
}

fileprivate extension [AnyPopup] {
    @MainActor mutating func perform(_ operation: StackOperation) {
        hideKeyboard()
        performOperation(operation)
    }
}
private extension [AnyPopup] {
    @MainActor func hideKeyboard() { KeyboardManager.hideKeyboard() }
    @MainActor mutating func performOperation(_ operation: StackOperation) {
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
