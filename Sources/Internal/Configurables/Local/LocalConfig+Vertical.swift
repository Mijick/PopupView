//
//  LocalConfig+Vertical.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

public extension LocalConfig { class Vertical: LocalConfig {
    var ignoredSafeAreaEdges: Edge.Set = []
    var heightMode: HeightMode = .auto
    var dragDetents: [DragDetent] = []
    var isDragGestureEnabled: Bool = ConfigContainer.vertical.isDragGestureEnabled


    required init() { super.init()
        self.popupPadding = ConfigContainer.vertical.popupPadding
        self.cornerRadius = ConfigContainer.vertical.cornerRadius
        self.backgroundColor = ConfigContainer.vertical.backgroundColor
        self.overlayColor = ConfigContainer.vertical.overlayColor
        self.isTapOutsideToDismissEnabled = ConfigContainer.vertical.isTapOutsideToDismissEnabled
    }
}}

// MARK: Subclasses & Typealiases
public typealias TopPopupConfig = LocalConfig.Vertical.Top
public typealias BottomPopupConfig = LocalConfig.Vertical.Bottom
public extension LocalConfig.Vertical {
    class Top: LocalConfig.Vertical {}
    class Bottom: LocalConfig.Vertical {}
}



// MARK: - TESTS
#if DEBUG



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
#endif
