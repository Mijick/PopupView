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

    override func calculateHeightForActivePopup() -> CGFloat? { _calculateHeightForActivePopup() }
    override func recalculateAndSave(height: CGFloat, for popup: AnyPopup) { _recalculateAndSave(height: height, for: popup) }
    override func calculateCornerRadius() -> [VerticalEdge : CGFloat] { _calculateCornerRadius() }
    override func calculatePopupPadding() -> EdgeInsets { _calculatePopupPadding() }
}}



private extension PopupCentreStackView.ViewModel {
    func _calculateCornerRadius() -> [VerticalEdge : CGFloat] {[
        .top: getActivePopupConfig().cornerRadius,
        .bottom: getActivePopupConfig().cornerRadius
    ]}


    func _calculateHeightForActivePopup() -> CGFloat? {
        popups.last?.height
    }



    func _recalculateAndSave(height: CGFloat, for popup: AnyPopup) {
        updateHeight(height, popup)
    }


    func _calculatePopupPadding() -> EdgeInsets { .init(
        top: calculateVerticalPopupPadding(for: .top),
        leading: calculateLeadingPopupPadding(),
        bottom: calculateVerticalPopupPadding(for: .bottom),
        trailing: calculateTrailingPopupPadding()
    )}
}
extension PopupCentreStackView.ViewModel {
    func calculateVerticalPopupPadding(for edge: VerticalEdge) -> CGFloat {

        let popupPaddingCandidate = getActivePopupConfig().popupPadding[edge]

        let add = isKeyboardActive && edge == .bottom ? screen.safeArea.bottom : 0
        return popupPaddingCandidate + add


        return max(popupPaddingCandidate, 0)
    }
    func calculateLeadingPopupPadding() -> CGFloat {
        getActivePopupConfig().popupPadding.leading
    }
    func calculateTrailingPopupPadding() -> CGFloat {
        getActivePopupConfig().popupPadding.trailing
    }




    func calculateOpacity(for popup: AnyPopup) -> CGFloat {
        popups.last == popup ? 1 : 0
    }
}


private extension PopupCentreStackView.ViewModel {
    func updateHeight(_ newHeight: CGFloat, _ popup: AnyPopup) { if popup.height != newHeight {
        updatePopup(popup) { $0.height = newHeight }
    }}
}
