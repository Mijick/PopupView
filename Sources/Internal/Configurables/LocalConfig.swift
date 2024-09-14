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

// MARK: Available Subclasses
public class TopPopupConfig: LocalConfig {}
public class BottomPopupConfig: LocalConfig {}


// MARK: Internal
public class LocalConfig: Configurable { required public init() {}
    var ignoredSafeAreaEdges: Edge.Set = []
    var contentFillsWholeHeight: Bool = false
    var contentFillsEntireScreen: Bool = false
    var distanceFromKeyboard: CGFloat? = nil

    var backgroundColour: Color? = nil
    var cornerRadius: CGFloat? = nil
    var popupPadding: (top: CGFloat, bottom: CGFloat, horizontal: CGFloat) = (0, 0, 0)

    var tapOutsideClosesView: Bool? = nil
    var dragGestureEnabled: Bool? = nil
    var dragDetents: [DragDetent] = []
}
