//
//  ViewModel+PopupStackView.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension PopupStackView { class ViewModel: ObservableObject { init(alignment: VerticalEdge) { self.alignment = alignment }
    var items: [AnyPopup] = [] { didSet {
        activePopupHeight = calculateHeightForActivePopup()
    }}
    let alignment: VerticalEdge
    var updatePopup: ((AnyPopup) -> ())? = nil

    @Published var gestureTranslation: CGFloat = 0
    @Published var keyboardHeight: CGFloat = 0
    @Published private(set) var activePopupHeight: CGFloat? = nil
    var translationProgress: CGFloat = 0
    @Published var screenSize: CGSize = .init()
    @Published var safeArea: EdgeInsets = .init()
}}

extension PopupStackView.ViewModel {
    func update(popup: AnyPopup, _ action: @escaping (inout AnyPopup) -> ()) { Task { @MainActor in
        var popup = popup
        action(&popup)
        updatePopup?(popup)
    }}
}



// MARK: - Calculating Height For Active Popup
private extension PopupStackView.ViewModel {
    func calculateHeightForActivePopup() -> CGFloat? {
        guard let activePopupHeight = items.last?.height else { return nil }

        let activePopupDragHeight = items.last?.dragHeight ?? 0
        let popupHeightFromGestureTranslation = activePopupHeight + activePopupDragHeight + gestureTranslation * getDragTranslationMultiplier()

        let newHeightCandidate1 = max(activePopupHeight, popupHeightFromGestureTranslation),
            newHeightCanditate2 = screenSize.height - keyboardHeight
        return min(newHeightCandidate1, newHeightCanditate2)
    }
}
private extension PopupStackView.ViewModel {
    func getDragTranslationMultiplier() -> CGFloat { switch alignment {
        case .top: 1
        case .bottom: -1
    }}
}
