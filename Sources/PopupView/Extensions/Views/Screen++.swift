//
//  UIScreen++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

class Screen {
    static var safeArea: EdgeInsets = {
        #if os(iOS)
            .init(UIScreen.safeArea)
        #elseif os(macOS)
            .init(NSScreen.main?.safeAreaInsets)
        #endif
    }()
    static var cornerRadius: CGFloat? {
        #if os(iOS)
            UIScreen.cornerRadius
        #elseif os(macOS)
            0
        #endif
    }
    static var size: CGSize = {
        #if os(iOS)
            UIScreen.main.bounds.size
        #elseif os(macOS)
            NSScreen.main?.frame.size ?? .zero
        #endif
    }()
}

// MARK: - Edge Insets
extension Screen {
    struct EdgeInsets {
        var top: CGFloat
        var bottom: CGFloat
        var left: CGFloat
        var right: CGFloat
    }
}
private extension Screen.EdgeInsets {
    #if os(iOS)
    init(_ insets: UIEdgeInsets) {
        top = insets.top
        bottom = insets.bottom
        left = insets.left
        right = insets.right
    }
    #endif

    #if os(macOS)
    init(_ insets: NSEdgeInsets?) {
        top = insets?.top ?? 0
        bottom = insets?.bottom ?? 0
        left = insets?.left ?? 0
        right = insets?.right ?? 0
    }
    #endif
}


// MARK: - iOS Implementation
#if os(iOS)
fileprivate extension UIScreen {
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

fileprivate extension UIScreen {
    static var cornerRadius: CGFloat? = { main.value(forKey: cornerRadiusKey) as? CGFloat }()
}
fileprivate extension UIScreen {
    static let cornerRadiusKey: String = ["Radius", "Corner", "display", "_"].reversed().joined()
}
#endif
