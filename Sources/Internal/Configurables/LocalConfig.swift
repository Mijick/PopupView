//
//  LocalConfig.swift of MijickPopups
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
    var distanceFromKeyboard: CGFloat = 0
    var popupPadding: (top: CGFloat, bottom: CGFloat, horizontal: CGFloat) = (0, 0, 0)
    var dragGestureEnabled: Bool = false
    var dragDetents: [DragDetent] = []


    required init() {
        super.init()

        self.backgroundColour = ConfigContainer.vertical.backgroundColour
        self.cornerRadius = ConfigContainer.vertical.cornerRadius
        self.tapOutsideClosesView = ConfigContainer.vertical.tapOutsideClosesView
        self.overlayColour = ConfigContainer.vertical.overlayColour
        self.distanceFromKeyboard = ConfigContainer.vertical.distanceFromKeyboard
        self.dragGestureEnabled = ConfigContainer.vertical.dragGestureEnabled
    }
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
