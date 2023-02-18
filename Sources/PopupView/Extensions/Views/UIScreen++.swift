//
//  UIScreen++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: fulcrumone@icloud.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension UIScreen {
    static let width: CGFloat = main.bounds.size.width
    static let height: CGFloat = main.bounds.size.height
    static let safeArea: UIEdgeInsets = {
        UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow})
            .first?
            .safeAreaInsets ?? .zero
    }()
}
