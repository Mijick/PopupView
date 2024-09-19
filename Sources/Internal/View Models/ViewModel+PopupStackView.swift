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
    let items: [AnyPopup] = []
    let alignment: VerticalEdge

    @Published var gestureTranslation: CGFloat = 0
    var activePopupHeight: CGFloat? = nil
    var translationProgress: CGFloat = 0
}}
