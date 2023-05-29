//
//  UIScreen++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Reading Safe Area of the screen
extension UIScreen {
    static var safeArea: UIEdgeInsets = {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first?
            .safeAreaInsets ?? .zero
    }()
}

// MARK: - Reading Corner Radius of the screen
extension UIScreen {
    static var displayCornerRadius: CGFloat? = { main.value(forKey: cornerRadiusKey) as? CGFloat }()
}
private extension UIScreen {
    static let cornerRadiusKey: String = {
        ["Radius", "Corner", "display", "_"]
            .reversed().joined()
    }()
}
