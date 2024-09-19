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
    @Published var items: [AnyPopup] = []
    let alignment: VerticalEdge
    var updatePopup: ((AnyPopup) -> ())? = nil

    @Published var gestureTranslation: CGFloat = 0
    @Published var keyboardHeight: CGFloat = 0
    var activePopupHeight: CGFloat? = nil
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
