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
}
