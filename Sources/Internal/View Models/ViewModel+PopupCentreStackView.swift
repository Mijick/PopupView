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
}}


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
        let popupPaddingCandidate = getActivePopupConfig().popupPadding[edge]


        let padding = (screen.height - (activePopupHeight ?? 0))


        let activePopupHeight = activePopupHeight ?? 0
        let halfHeight = activePopupHeight / 2

        if isKeyboardActive {
            if edge == .top { return 0 }



            let alfPopH = activePopupHeight / 2

            let ab = screen.height / 2 - halfHeight - screen.safeArea.bottom

            let cd = abs(ab) * 2
            print(cd)


            print(screen.height, halfHeight, screen.safeArea.bottom)



            // 196

            let a = (screen.height - activePopupHeight - screen.safeArea.bottom) / 2
            //print(screen.safeArea.bottom - a)
            return cd
        }






        if isKeyboardActive && edge == .bottom {
            return padding + screen.safeArea.bottom / 2


        }

        else {
            return padding + screen.safeArea.bottom / 2
        }




        let a = (screen.height - screen.safeArea.bottom - (activePopupHeight ?? 0)) / 2
        if isKeyboardActive && edge == .bottom { return a }
        return 0



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
}

// MARK: Corner Radius
private extension PopupCentreStackView.ViewModel {
    func _calculateCornerRadius() -> [VerticalEdge : CGFloat] {[
        .top: getActivePopupConfig().cornerRadius,
        .bottom: getActivePopupConfig().cornerRadius
    ]}
}




private extension PopupCentreStackView.ViewModel {



    func _calculateHeightForActivePopup() -> CGFloat? {
        popups.last?.height
    }



    func _recalculateAndSave(height: CGFloat, for popup: AnyPopup) {
        updateHeight(height, popup)
    }



}
extension PopupCentreStackView.ViewModel {





    func calculateOpacity(for popup: AnyPopup) -> CGFloat {
        popups.last == popup ? 1 : 0
    }
}


private extension PopupCentreStackView.ViewModel {
    func updateHeight(_ newHeight: CGFloat, _ popup: AnyPopup) { if popup.height != newHeight {
        updatePopup(popup) { $0.height = newHeight }
    }}
}
