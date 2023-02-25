//
//  BottomPopupConfig.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public extension BottomPopupConfig {
    func backgroundColour(_ value: Color) -> Self { changing(path: \.backgroundColour, to: value) }
    func contentIgnoresSafeArea(_ value: Bool) -> Self { changing(path: \.contentIgnoresSafeArea, to: value) }
    func horizontalPadding(_ value: CGFloat) -> Self { changing(path: \.horizontalPadding, to: value) }
    func bottomPadding(_ value: CGFloat) -> Self { changing(path: \.bottomPadding, to: value) }
    func stackedPopupsOffset(_ value: CGFloat) -> Self { changing(path: \.stackedViewsOffset, to: value) }
    func stackedPopupsScale(_ value: CGFloat) -> Self { changing(path: \.stackedViewsScale, to: value) }
    func stackedPopupsCornerRadius(_ value: CGFloat) -> Self { changing(path: \.stackedViewsCornerRadius, to: value) }
    func stackedElementsLimit(_ value: Int) -> Self { changing(path: \.maxStackedElements, to: value) }
    func activePopupCornerRadius(_ value: CGFloat) -> Self { changing(path: \.activeViewCornerRadius, to: value) }
    func dragGestureProgressToClose(_ value: CGFloat) -> Self { changing(path: \.dragGestureProgressToClose, to: value) }
    func dragGestureAnimation(_ value: Animation) -> Self { changing(path: \.dragGestureAnimation, to: value) }
    func transitionAnimation(_ value: Animation) -> Self { changing(path: \.transitionAnimation, to: value) }
}
public struct BottomPopupConfig: Configurable {
    var backgroundColour: Color = .white
    var contentIgnoresSafeArea: Bool = false
    var horizontalPadding: CGFloat = 0
    var bottomPadding: CGFloat = 0
    var stackedViewsOffset: CGFloat = 12
    var stackedViewsScale: CGFloat = 0.09
    var stackedViewsCornerRadius: CGFloat = 10
    var maxStackedElements: Int = 4
    var activeViewCornerRadius: CGFloat = 32
    var dragGestureProgressToClose: CGFloat = 1/3
    var dragGestureAnimation: Animation = .interactiveSpring()
    var transitionAnimation: Animation = .spring(response: 0.44, dampingFraction: 1, blendDuration: 0.4)
}
