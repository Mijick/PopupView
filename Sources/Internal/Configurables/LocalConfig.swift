//
//  LocalConfig.swift of MijickPopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

public class LocalConfig: Configurable { required public init() {}
    var backgroundColour: Color? = nil
    var cornerRadius: CGFloat? = nil
    var tapOutsideClosesView: Bool? = nil
    var overlayColour: Color? = nil
}

// MARK: - Vertical
public extension LocalConfig { class Vertical: LocalConfig {
    var ignoredSafeAreaEdges: Edge.Set = []
    var contentFillsWholeHeight: Bool = false
    var contentFillsEntireScreen: Bool = false
    var distanceFromKeyboard: CGFloat? = nil
    var popupPadding: (top: CGFloat, bottom: CGFloat, horizontal: CGFloat) = (0, 0, 0)
    var dragGestureEnabled: Bool? = nil
    var dragDetents: [DragDetent] = []
}}
public extension LocalConfig.Vertical {
    class Top: LocalConfig.Vertical {}
    class Bottom: LocalConfig.Vertical {}
}

// MARK: - Centre
public extension LocalConfig { class Centre: LocalConfig {
    var horizontalPadding: CGFloat = 12
}}






public typealias TopPopupConfig = LocalConfig.Vertical.Top
public typealias CentrePopupConfig = LocalConfig.Centre
public typealias BottomPopupConfig = LocalConfig.Vertical.Bottom
