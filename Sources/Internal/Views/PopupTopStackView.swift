//
//  PopupTopStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupTopStackView: PopupStack {
    let items: [AnyPopup<TopPopupConfig>]
    let globalConfig: GlobalConfig
    @State var gestureTranslation: CGFloat = 0
    @State var heights: [AnyPopup<TopPopupConfig>: CGFloat] = [:]
    @ObservedObject private var screen: ScreenManager = .shared

    
    var body: some View {
        ZStack(alignment: .bottom, content: createPopupStack)
            .ignoresSafeArea()
            .background(createTapArea())
            .animation(transitionEntryAnimation, value: heights)
            .animation(transitionRemovalAnimation, value: gestureTranslation)
            .onDragGesture(onChanged: onPopupDragGestureChanged, onEnded: onPopupDragGestureEnded)
    }
}

private extension PopupTopStackView {
    func createPopupStack() -> some View {
        ForEach(items, id: \.self, content: createPopup)
    }
}

private extension PopupTopStackView {
    func createPopup(_ item: AnyPopup<TopPopupConfig>) -> some View {
        item.body
            .padding(.top, contentTopPadding)
            .padding(.leading, screen.safeArea.left)
            .padding(.trailing, screen.safeArea.right)
            .readHeight { saveHeight($0, for: item) }
            .frame(height: height).frame(maxWidth: .infinity)
            .background(getBackgroundColour(for: item), overlayColour: getStackOverlayColour(item), radius: getCornerRadius(item), corners: getCorners())
            .padding(.horizontal, lastPopupConfig.popupPadding.horizontal)
            .offset(y: getOffset(item))
            .scaleEffect(getScale(item), anchor: .bottom)
            .opacity(getOpacity(item))
            .compositingGroup()
            .focusSectionIfAvailable()
            .align(to: .top, popupTopPadding)
            .transition(transition)
            .zIndex(getZIndex(item))
    }
}

// MARK: - Gestures
private extension PopupTopStackView {
    func onPopupDragGestureChanged(_ value: CGFloat) {
        if lastPopupConfig.dragGestureEnabled ?? globalConfig.top.dragGestureEnabled { gestureTranslation = min(0, value) }
    }
    func onPopupDragGestureEnded(_ value: CGFloat) {
        dismissLastItemIfNeeded()
        resetGestureTranslationOnEnd()
    }
}
private extension PopupTopStackView {
    func dismissLastItemIfNeeded() {
        if translationProgress >= gestureClosingThresholdFactor { items.last?.dismiss() }
    }
    func resetGestureTranslationOnEnd() {
        let resetAfter = items.count == 1 && translationProgress >= gestureClosingThresholdFactor ? 0.25 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + resetAfter) { gestureTranslation = 0 }
    }
}

// MARK: - View Modifiers
private extension PopupTopStackView {
    func getCorners() -> RectCorner {
        switch popupTopPadding {
            case 0: return [.bottomLeft, .bottomRight]
            default: return .allCorners
        }
    }
    func getBackgroundColour(for item: AnyPopup<TopPopupConfig>) -> Color { getConfig(item).backgroundColour ?? globalConfig.top.backgroundColour }
    func saveHeight(_ height: CGFloat, for item: AnyPopup<TopPopupConfig>) { heights[item] = height }
}

// MARK: - Flags & Values
extension PopupTopStackView {
    var contentTopPadding: CGFloat { lastPopupConfig.contentIgnoresSafeArea ? 0 : max(screen.safeArea.top - popupTopPadding, 0) }
    var popupTopPadding: CGFloat { lastPopupConfig.popupPadding.top }
    var height: CGFloat { heights.first { $0.key == items.last }?.value ?? getInitialHeight() }
    var cornerRadius: CGFloat { lastPopupConfig.cornerRadius ?? globalConfig.top.cornerRadius }

    var stackLimit: Int { globalConfig.top.stackLimit }
    var stackScaleFactor: CGFloat { globalConfig.top.stackScaleFactor }
    var stackOffsetValue: CGFloat { globalConfig.top.stackOffset }
    var stackCornerRadiusMultiplier: CGFloat { globalConfig.top.stackCornerRadiusMultiplier }

    var translationProgress: CGFloat { abs(gestureTranslation) / height }
    var gestureClosingThresholdFactor: CGFloat { globalConfig.top.dragGestureProgressToClose }
    var transition: AnyTransition { .move(edge: .top) }

    var tapOutsideClosesPopup: Bool { lastPopupConfig.tapOutsideClosesView ?? globalConfig.top.tapOutsideClosesView }
}
