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

extension PopupStackView { @MainActor class ViewModel: ObservableObject {
    let alignment: VerticalEdge

    var items: [AnyPopup] = [] { didSet { onItemsChanged() }}
    var gestureTranslation: CGFloat = 0 { didSet { onGestureTranslationChanged() }}
    var screen: ScreenProperties = .init() { didSet { onScreenChanged() }}

    var updatePopup: ((AnyPopup) -> ())? = nil
    @Published var isKeyboardActive: Bool = false
    @Published private(set) var activePopupHeight: CGFloat? = nil

    
    private(set) var translationProgress: CGFloat = 0


    // MARK: Initialiser
    init(alignment: VerticalEdge) { self.alignment = alignment }
}}
private extension PopupStackView.ViewModel {
    func onItemsChanged() {
        let activePopupHeightCandidate = calculateHeightForActivePopup()

        Task { @MainActor in withAnimation(.transition) {
            activePopupHeight = activePopupHeightCandidate
        }}
    }
    func onScreenChanged() {
        Task { @MainActor in
            objectWillChange.send()
        }
    }
    func onGestureTranslationChanged() {
        let translationProgressCandidate = calculateTranslationProgress()
        let activePopupHeightCandidate = calculateHeightForActivePopup()

        Task { @MainActor in withAnimation(gestureTranslation == 0 ? .transition : nil) {
            translationProgress = translationProgressCandidate
            activePopupHeight = activePopupHeightCandidate
        }}
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
            newHeightCanditate2 = screen.height
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

// MARK: - Calculating Paddings For Popup Body
extension PopupStackView.ViewModel {
    func calculateBodyPadding(popupConfig: Config) -> EdgeInsets { let activePopupHeight = activePopupHeight ?? 0; return .init(
        top: calculateTopBodyPadding(activePopupHeight: activePopupHeight, popupConfig: popupConfig),
        leading: calculateLeadingBodyPadding(),
        bottom: calculateBottomBodyPadding(activePopupHeight: activePopupHeight, popupConfig: popupConfig),
        trailing: calculateTrailingBodyPadding()
    )}
}
private extension PopupStackView.ViewModel {
    func calculateTopBodyPadding(activePopupHeight: CGFloat, popupConfig: Config) -> CGFloat {
        if popupConfig.ignoredSafeAreaEdges.contains(.top) { return 0 }

        return switch alignment {
            case .top: calculateVerticalPaddingAdhereEdge(safeAreaHeight: screen.safeArea.top, popupPadding: calculatePopupPadding().top)
            case .bottom: calculateVerticalPaddingCounterEdge(popupHeight: activePopupHeight, safeArea: screen.safeArea.top)
        }
    }
    func calculateBottomBodyPadding(activePopupHeight: CGFloat, popupConfig: Config) -> CGFloat {
        if popupConfig.ignoredSafeAreaEdges.contains(.bottom) && !isKeyboardActive { return 0 }

        return switch alignment {
            case .top: calculateVerticalPaddingCounterEdge(popupHeight: activePopupHeight, safeArea: screen.safeArea.bottom)
            case .bottom: calculateVerticalPaddingAdhereEdge(safeAreaHeight: screen.safeArea.bottom, popupPadding: calculatePopupPadding().bottom)
        }
    }
    func calculateLeadingBodyPadding() -> CGFloat {
        screen.safeArea.leading
    }
    func calculateTrailingBodyPadding() -> CGFloat {
        screen.safeArea.trailing
    }
}
private extension PopupStackView.ViewModel {
    func calculateVerticalPaddingCounterEdge(popupHeight: CGFloat, safeArea: CGFloat) -> CGFloat {
        let paddingValueCandidate = safeArea + popupHeight - screen.height
        return max(paddingValueCandidate, 0)
    }
    func calculateVerticalPaddingAdhereEdge(safeAreaHeight: CGFloat, popupPadding: CGFloat) -> CGFloat {
        let paddingValueCandidate = safeAreaHeight - popupPadding
        return max(paddingValueCandidate, 0)
    }
}

// MARK: - Popup Padding
extension PopupStackView.ViewModel {
    func calculatePopupPadding() -> EdgeInsets { guard activePopupConfig.heightMode != .fullscreen else { return .init() }; return .init(
        top: activePopupConfig.popupPadding.top,
        leading: activePopupConfig.popupPadding.horizontal,
        bottom: activePopupConfig.popupPadding.bottom,
        trailing: activePopupConfig.popupPadding.horizontal
    )}
}



// MARK: - Helpers
private extension PopupStackView.ViewModel {
    var activePopupConfig: Config {
        let config = items.last?.config as? Config
        return config ?? .init()
    }
}


// MARK: - Calculating Corner Radius
extension PopupStackView.ViewModel {
    func calculateCornerRadius() -> [VerticalEdge: CGFloat] {
        let cornerRadiusValue = calculateCornerRadiusValue(activePopupConfig)
        return [
            .top: calculateTopCornerRadius(cornerRadiusValue),
            .bottom: calculateBottomCornerRadius(cornerRadiusValue)
        ]
    }
}
private extension PopupStackView.ViewModel {
    func calculateCornerRadiusValue(_ activePopupConfig: Config) -> CGFloat { switch activePopupConfig.heightMode {
        case .auto, .large: activePopupConfig.cornerRadius
        case .fullscreen: 0
    }}
    func calculateTopCornerRadius(_ cornerRadiusValue: CGFloat) -> CGFloat { switch alignment {
        case .top: calculatePopupPadding().top != 0 ? cornerRadiusValue : 0
        case .bottom: cornerRadiusValue
    }}
    func calculateBottomCornerRadius(_ cornerRadiusValue: CGFloat) -> CGFloat { switch alignment {
        case .top: cornerRadiusValue
        case .bottom: calculatePopupPadding().bottom != 0 ? cornerRadiusValue : 0
    }}
}
