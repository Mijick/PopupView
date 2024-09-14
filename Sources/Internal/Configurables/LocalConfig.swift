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

public class LocalConfig { required init() {}
    var backgroundColour: Color = .clear
    var cornerRadius: CGFloat = 0
    var tapOutsideClosesView: Bool = false
    var overlayColour: Color = .clear
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


    required init() {
        super.init()

        self.backgroundColour = ConfigContainer.centre.backgroundColour
        self.cornerRadius = ConfigContainer.centre.cornerRadius
        self.tapOutsideClosesView = ConfigContainer.centre.tapOutsideClosesView
        self.overlayColour = ConfigContainer.centre.overlayColour
    }
}}






public typealias TopPopupConfig = LocalConfig.Vertical.Top
public typealias CentrePopupConfig = LocalConfig.Centre
public typealias BottomPopupConfig = LocalConfig.Vertical.Bottom
