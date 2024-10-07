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
    var popupPadding: EdgeInsets = .init()
    var cornerRadius: CGFloat = 0
    var backgroundColour: Color = .clear
    var overlayColour: Color = .clear
    var isTapOutsideToDismissEnabled: Bool = false
}



// MARK: - AVAILABLE TYPES



// MARK: Vertical
public extension LocalConfig { class Vertical: LocalConfig {
    var ignoredSafeAreaEdges: Edge.Set = []
    var heightMode: HeightMode = .auto
    var dragDetents: [DragDetent] = []
    var isDragGestureEnabled: Bool = ConfigContainer.vertical.isDragGestureEnabled

    required init() { super.init()
        self.popupPadding = .init()
        self.cornerRadius = ConfigContainer.vertical.cornerRadius
        self.backgroundColour = ConfigContainer.vertical.backgroundColour
        self.overlayColour = ConfigContainer.vertical.overlayColour
        self.isTapOutsideToDismissEnabled = ConfigContainer.vertical.isTapOutsideToDismissEnabled
    }
}}



public extension LocalConfig.Vertical {
    class Top: LocalConfig.Vertical {}
    class Bottom: LocalConfig.Vertical {}
}


extension LocalConfig.Vertical {
    static func t_createNew<C: LocalConfig.Vertical>(popupPadding: EdgeInsets, cornerRadius: CGFloat, ignoredSafeAreaEdges: Edge.Set, heightMode: HeightMode, dragDetents: [DragDetent], isDragGestureEnabled: Bool) -> C {
        let config = C()
        config.popupPadding = popupPadding
        config.cornerRadius = cornerRadius
        config.ignoredSafeAreaEdges = ignoredSafeAreaEdges
        config.heightMode = heightMode
        config.dragDetents = dragDetents
        config.isDragGestureEnabled = isDragGestureEnabled
        return config
    }
}








// MARK: Centre
public extension LocalConfig { class Centre: LocalConfig {
    required init(backgroundColour: Color, cornerRadius: CGFloat, tapOutsideClosesView: Bool, overlayColour: Color, popupPadding: EdgeInsets) {
        super.init()

        self.backgroundColour = backgroundColour
        self.cornerRadius = cornerRadius
        self.isTapOutsideToDismissEnabled = tapOutsideClosesView
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
