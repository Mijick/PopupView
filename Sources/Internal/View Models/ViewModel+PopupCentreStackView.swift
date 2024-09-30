//
//  ViewModel+PopupCentreStackView.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension PopupCentreStackView { class ViewModel: MijickPopups.ViewModel<LocalConfig.Centre> {
    override func recalculateAndSave(height: CGFloat, for popup: AnyPopup) { _recalculateAndSave(height: height, for: popup) }
    override func calculateHeightForActivePopup() -> CGFloat? { _calculateHeightForActivePopup() }
    override func calculatePopupPadding() -> EdgeInsets { _calculatePopupPadding() }
    override func calculateCornerRadius() -> [VerticalEdge : CGFloat] { _calculateCornerRadius() }
    override func calculateVerticalFixedSize(for popup: AnyPopup) -> Bool { _calculateVerticalFixedSize(for: popup) }
}}



// MARK: - VIEW METHODS



// MARK: Recalculate & Update Popup Height
private extension PopupCentreStackView.ViewModel {
    func _recalculateAndSave(height: CGFloat, for popup: AnyPopup) {
        let newHeight = calculateHeight(height)
        updateHeight(newHeight, popup)
    }
}
private extension PopupCentreStackView.ViewModel {
    func calculateHeight(_ height: CGFloat) -> CGFloat {
        min(height, calculateLargeScreenHeight())
    }
}
private extension PopupCentreStackView.ViewModel {
    func calculateLargeScreenHeight() -> CGFloat {
        let fullscreenHeight = screen.height,
            safeAreaHeight = screen.safeArea.top + screen.safeArea.bottom
        return fullscreenHeight - safeAreaHeight
    }
}

// MARK: Popup Padding
private extension PopupCentreStackView.ViewModel {
    func _calculatePopupPadding() -> EdgeInsets { .init(
        top: calculateVerticalPopupPadding(for: .top),
        leading: calculateLeadingPopupPadding(),
        bottom: calculateVerticalPopupPadding(for: .bottom),
        trailing: calculateTrailingPopupPadding()
    )}
}
private extension PopupCentreStackView.ViewModel {
    func calculateVerticalPopupPadding(for edge: VerticalEdge) -> CGFloat {
        guard let activePopupHeight,
              isKeyboardActive && edge == .bottom
        else { return 0 }

        let remainingHeight = screen.height - activePopupHeight
        let paddingCandidate = (remainingHeight / 2 - screen.safeArea.bottom) * 2
        return abs(paddingCandidate)
    }
    func calculateLeadingPopupPadding() -> CGFloat {
        getActivePopupConfig().popupPadding.leading
    }
    func calculateTrailingPopupPadding() -> CGFloat {
        getActivePopupConfig().popupPadding.trailing
    }
}

// MARK: Corner Radius
private extension PopupCentreStackView.ViewModel {
    func _calculateCornerRadius() -> [VerticalEdge : CGFloat] {[
        .top: getActivePopupConfig().cornerRadius,
        .bottom: getActivePopupConfig().cornerRadius
    ]}
}

// MARK: Opacity
extension PopupCentreStackView.ViewModel {
    func calculateOpacity(for popup: AnyPopup) -> CGFloat {
        popups.last == popup ? 1 : 0
    }
}

// MARK: Fixed Size
private extension PopupCentreStackView.ViewModel {
    func _calculateVerticalFixedSize(for popup: AnyPopup) -> Bool {
        activePopupHeight != calculateLargeScreenHeight()
    }
}



// MARK: - HELPERS



// MARK: Active Popup Height
private extension PopupCentreStackView.ViewModel {
    func _calculateHeightForActivePopup() -> CGFloat? {
        popups.last?.height
    }
}



// MARK: - TESTING
#if DEBUG



// MARK: Methods
extension PopupCentreStackView.ViewModel {
    @MainActor func t_calculatePopupPadding() -> EdgeInsets { calculatePopupPadding() }
    @MainActor func t_calculateCornerRadius() -> [VerticalEdge: CGFloat] { calculateCornerRadius() }
    @MainActor func t_calculateOpacity(for popup: AnyPopup) -> CGFloat { calculateOpacity(for: popup) }
    @MainActor func t_calculateVerticalFixedSize(for popup: AnyPopup) -> Bool { calculateVerticalFixedSize(for: popup) }
}
#endif
