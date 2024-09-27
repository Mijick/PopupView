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

extension PopupCentreStackView { class ViewModel: MijickPopups.ViewModel {

    override func calculateHeightForActivePopup() -> CGFloat? {
        popups.last?.height
    }
    override func recalculateAndSave(height: CGFloat, for popup: AnyPopup) {
        updateHeight(height, popup)
    }
}}

extension PopupCentreStackView {

}
