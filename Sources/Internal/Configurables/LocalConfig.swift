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

@MainActor public class LocalConfig { required init() {}
    var backgroundColour: Color = .clear
    var cornerRadius: CGFloat = 0
    var tapOutsideClosesView: Bool = false
    var overlayColour: Color = .clear
    var popupPadding: EdgeInsets = .init()
}

// MARK: - Vertical
public extension LocalConfig { class Vertical: LocalConfig {
    var ignoredSafeAreaEdges: Edge.Set = []
    var heightMode: HeightMode = .auto
    var dragGestureEnabled: Bool = false
    var dragDetents: [DragDetent] = []


    required init(backgroundColour: Color, cornerRadius: CGFloat, tapOutsideClosesView: Bool, overlayColour: Color, popupPadding: EdgeInsets, ignoredSafeAreaEdges: Edge.Set, heightMode: HeightMode, dragGestureEnabled: Bool, dragDetents: [DragDetent]) {
        super.init()

        self.backgroundColour = backgroundColour
        self.cornerRadius = cornerRadius
        self.tapOutsideClosesView = tapOutsideClosesView
        self.overlayColour = overlayColour
        self.popupPadding = popupPadding
        self.ignoredSafeAreaEdges = ignoredSafeAreaEdges
        self.heightMode = heightMode
        self.dragGestureEnabled = dragGestureEnabled
        self.dragDetents = dragDetents
    }
    required convenience init() { self.init(
        backgroundColour: ConfigContainer.vertical.backgroundColour,
        cornerRadius: ConfigContainer.vertical.cornerRadius,
        tapOutsideClosesView: ConfigContainer.vertical.isTapOutsideToDismissEnabled,
        overlayColour: ConfigContainer.vertical.overlayColour,
        popupPadding: .init(),
        ignoredSafeAreaEdges: [],
        heightMode: .auto,
        dragGestureEnabled: ConfigContainer.vertical.isDragGestureEnabled,
        dragDetents: []
    )}
}}
public extension LocalConfig.Vertical {
    class Top: LocalConfig.Vertical {}
    class Bottom: LocalConfig.Vertical {}
}

// MARK: - Centre
public extension LocalConfig { class Centre: LocalConfig {
    required init(backgroundColour: Color, cornerRadius: CGFloat, tapOutsideClosesView: Bool, overlayColour: Color, popupPadding: EdgeInsets) {
        super.init()

        self.backgroundColour = backgroundColour
        self.cornerRadius = cornerRadius
        self.tapOutsideClosesView = tapOutsideClosesView
        self.overlayColour = overlayColour
        self.popupPadding = popupPadding
    }
    required convenience init() { self.init(
        backgroundColour: ConfigContainer.centre.backgroundColour,
        cornerRadius: ConfigContainer.centre.cornerRadius,
        tapOutsideClosesView: ConfigContainer.centre.isTapOutsideToDismissEnabled,
        overlayColour: ConfigContainer.centre.overlayColour,
        popupPadding: .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    )}
}}




public typealias TopPopupConfig = LocalConfig.Vertical.Top
public typealias CentrePopupConfig = LocalConfig.Centre
public typealias BottomPopupConfig = LocalConfig.Vertical.Bottom
