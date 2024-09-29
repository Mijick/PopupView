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
    var popupPadding: EdgeInsets = .init()
}

// MARK: - Vertical
public extension LocalConfig { class Vertical: LocalConfig {
    var ignoredSafeAreaEdges: Edge.Set = []
    var heightMode: HeightMode = .auto
    var dragGestureEnabled: Bool = false
    var dragDetents: [DragDetent] = []


    required init() {
        super.init()

        self.backgroundColour = ConfigContainer.vertical.backgroundColour
        self.cornerRadius = ConfigContainer.vertical.cornerRadius
        self.tapOutsideClosesView = ConfigContainer.vertical.tapOutsideClosesView
        self.overlayColour = ConfigContainer.vertical.overlayColour
        self.dragGestureEnabled = ConfigContainer.vertical.dragGestureEnabled
        self.popupPadding = .init()
    }
}}
public extension LocalConfig.Vertical {
    class Top: LocalConfig.Vertical {}
    class Bottom: LocalConfig.Vertical {}
}

// MARK: - Centre
public extension LocalConfig { class Centre: LocalConfig {
    required init() {
        super.init()

        self.backgroundColour = ConfigContainer.centre.backgroundColour
        self.cornerRadius = ConfigContainer.centre.cornerRadius
        self.tapOutsideClosesView = ConfigContainer.centre.tapOutsideClosesView
        self.overlayColour = ConfigContainer.centre.overlayColour
        self.popupPadding = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
}}






public typealias TopPopupConfig = LocalConfig.Vertical.Top
public typealias CentrePopupConfig = LocalConfig.Centre
public typealias BottomPopupConfig = LocalConfig.Vertical.Bottom





#if DEBUG
extension LocalConfig.Vertical {
    convenience init(cornerRadius: CGFloat, ignoredSafeAreaEdges: Edge.Set, heightMode: HeightMode, popupPadding: EdgeInsets, dragGestureEnabled: Bool, dragDetents: [DragDetent]) {
        self.init()

        self.cornerRadius = cornerRadius
        self.ignoredSafeAreaEdges = ignoredSafeAreaEdges
        self.heightMode = heightMode
        self.popupPadding = popupPadding
        self.dragGestureEnabled = dragGestureEnabled
        self.dragDetents = dragDetents
    }
}
#endif
