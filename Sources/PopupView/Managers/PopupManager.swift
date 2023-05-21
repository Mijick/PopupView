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
    fileprivate var operationRecentlyPerformed: Bool = false

    static let shared: PopupManager = .init()
    private init() {}
}

public extension PopupManager {
    static func dismiss() { shared.views.perform(.removeLast) }
    static func dismiss(id: String) { shared.views.perform(.remove(id: id)) }
    static func dismiss<P: Popup>(_ popup: P.Type) { shared.views.perform(.remove(id: .init(describing: popup))) }
    static func dismissAll() { shared.views.perform(.removeAll) }
}

extension PopupManager {
    static func present(_ popup: some Popup) { DispatchQueue.main.async { withAnimation(nil) { shared.views.perform(.insert(popup)) }}}
}

extension PopupManager {
    var top: [AnyPopup<TopPopupConfig>] { views.compactMap { $0 as? AnyPopup<TopPopupConfig> } }
    var centre: [AnyPopup<CentrePopupConfig>] { views.compactMap { $0 as? AnyPopup<CentrePopupConfig> } }
    var bottom: [AnyPopup<BottomPopupConfig>] { views.compactMap { $0 as? AnyPopup<BottomPopupConfig> } }
    var isEmpty: Bool { views.isEmpty }
}


// MARK: - Helpers
fileprivate extension [any Popup] {
    enum Operation {
        case insert(any Popup)
        case removeLast, remove(id: String), removeAll
    }
}
fileprivate extension [any Popup] {
    mutating func perform(_ operation: Operation) {
        guard !PopupManager.shared.operationRecentlyPerformed else { return }

        blockOtherOperations()
        hideKeyboard()
        performOperation(operation)
        liftBlockade()
    }
}
private extension [any Popup] {
    func blockOtherOperations() {
        PopupManager.shared.operationRecentlyPerformed = true
    }
    func hideKeyboard() {
        UIApplication.shared.hideKeyboard()
    }
    mutating func performOperation(_ operation: Operation) {
        switch operation {
            case .insert(let popup): append(popup, if: canBeInserted(popup))
            case .removeLast: removeLast()
            case .remove(let id): removeAll(where: { $0.id == id })
            case .removeAll: removeAll()
        }
    }
    func liftBlockade() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.44) { PopupManager.shared.operationRecentlyPerformed = false }
    }
}
private extension [any Popup] {
    func canBeInserted(_ popup: some Popup) -> Bool { !contains(where: { $0.id == popup.id }) }
}

fileprivate extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
