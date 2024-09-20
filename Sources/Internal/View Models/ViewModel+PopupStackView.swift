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
    var items: [AnyPopup] = [] { didSet { onItemsChanged() }}
    var gestureTranslation: CGFloat = 0 { didSet { onGestureTranslationChanged() }}
    let alignment: VerticalEdge
    var updatePopup: ((AnyPopup) -> ())? = nil
    @Published var isKeyboardActive: Bool = false
    @Published private(set) var activePopupHeight: CGFloat? = nil
    private(set) var translationProgress: CGFloat = 0
    @Published var screenSize: CGSize = .init()
    @Published var safeArea: EdgeInsets = .init()
}}
private extension PopupStackView.ViewModel {
    func onItemsChanged() {
        let activePopupHeightCandidate = calculateHeightForActivePopup()

        Task { @MainActor in
            activePopupHeight = activePopupHeightCandidate
        }
    }
    func onGestureTranslationChanged() {
        let translationProgressCandidate = calculateTranslationProgress()
        let activePopupHeightCandidate = calculateHeightForActivePopup()

        Task { @MainActor in
            translationProgress = translationProgressCandidate
            activePopupHeight = activePopupHeightCandidate
        }
    }
}

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
            newHeightCanditate2 = screenSize.height
        return min(newHeightCandidate1, newHeightCanditate2)
    }
}
private extension PopupStackView.ViewModel {
    func getDragTranslationMultiplier() -> CGFloat { switch alignment {
        case .top: 1
        case .bottom: -1
    }}
}

// MARK: - Translation Progress
private extension PopupStackView.ViewModel {
    func calculateTranslationProgress() -> CGFloat { guard let activePopupHeight = items.last?.height else { return 0 }; return switch alignment {
        case .top: abs(min(gestureTranslation + (items.last?.dragHeight ?? 0), 0)) / activePopupHeight
        case .bottom: max(gestureTranslation - (items.last?.dragHeight ?? 0), 0) / activePopupHeight
    }}
}
