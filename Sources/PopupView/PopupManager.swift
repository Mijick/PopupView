//
//  PopupManager.swift of PopupView
//
//  Created by Alina Petrovskaya
//    - Linkedin: https://www.linkedin.com/in/alina-petrovkaya-69617a10b
//    - Mail: alina.petrovskaya.12@icloud.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.

import SwiftUI

public class PopupManager: ObservableObject {
    @Published var popUpStack: (any PopUpViewProtocol)? = nil 
    public static let shared = PopupManager()
    
    
    private init() { }
}

public extension PopupManager {
    func close() { popUpStack = popUpStack?.close() }
    func closAll() { popUpStack = nil }
}

extension PopupManager {
    func openFromBottom(view: AnyPopup, configBuilder: (inout PopupBottomStackView.Config) -> ()) {
        guard let items = try? getItems(view) else { return }
        popUpStack = PopupBottomStackView(items: items, closingAction: { [weak self] in self?.close() }, configBuilder: configBuilder)
    }
}

private extension PopupManager {
    func getItems(_ view: AnyPopup? = nil) throws -> [AnyPopup] {
        switch view {
            case .some(let view):
            guard popUpStack == nil || popUpStack?.items.contains(view) == false else { throw ErrorType.repetitiveElement }
                return (popUpStack?.items ?? []) + [view]
                
            case .none:
                var items = popUpStack?.items ?? []
                items.removeLast()
                return items
            }
    }
}


private extension PopupManager {
    enum ErrorType: Error { case repetitiveElement }
}
