//
//  PopupTopStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupTopStackView: View {
    let items: [AnyPopup<TopPopupConfig>]
    let globalConfig: GlobalConfig
    @ObservedObject private var screen: ScreenManager = .shared
    @State private var heights: [AnyPopup<TopPopupConfig>: CGFloat] = [:]
    @State private var gestureTranslation: CGFloat = 0

    
    var body: some View {
        ZStack(alignment: .bottom, content: createPopupStack)
            .ignoresSafeArea()
            .background(createTapArea())
            .animation(transitionAnimation, value: heights)
            .animation(dragGestureAnimation, value: gestureTranslation)
            .onDragGesture(onChanged: onPopupDragGestureChanged, onEnded: onPopupDragGestureEnded)
    }
}

private extension PopupTopStackView {
    func createPopupStack() -> some View {
        ForEach(items, id: \.self, content: createPopup)
    }
    func createTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismiss ?? {})
            .active(if: config.tapOutsideClosesView ?? globalConfig.top.tapOutsideClosesView)
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
            .background(getBackgroundColour(for: item), overlayColour: overlayColour.opacity(getOverlayOpacity(for: item)), radius: getCornerRadius(for: item), corners: getCorners())
            .padding(.horizontal, config.popupPadding.horizontal)
            .offset(y: getOffset(for: item))
            .scaleEffect(getScale(for: item), anchor: .bottom)
            .opacity(getOpacity(for: item))
            .compositingGroup()
            .focusSectionIfAvailable()
            .align(to: .top, topPadding)
            .transition(transition)
            .zIndex(getZIndex(for: item))
    }
}

// MARK: - Gesture Handler
private extension PopupTopStackView {
    func onPopupDragGestureChanged(_ value: CGFloat) {
        if config.dragGestureEnabled ?? globalConfig.top.dragGestureEnabled { gestureTranslation = min(0, value) }
    }
    func onPopupDragGestureEnded(_ value: CGFloat) {
        if translationProgress() >= gestureClosingThresholdFactor { items.last?.dismiss() }
        gestureTranslation = 0
    }
}

// MARK: - View Handlers
private extension PopupTopStackView {
    func getCornerRadius(for item: AnyPopup<TopPopupConfig>) -> CGFloat {
        if isLast(item) { return cornerRadius }
        if gestureTranslation.isZero || !isNextToLast(item) { return stackedCornerRadius }

        let difference = cornerRadius - stackedCornerRadius
        let differenceProgress = difference * translationProgress()
        return stackedCornerRadius + differenceProgress
    }
    func getCorners() -> RectCorner {
        switch topPadding {
            case 0: return [.bottomLeft, .bottomRight]
            default: return .allCorners
        }
    }
    func getScale(for item: AnyPopup<TopPopupConfig>) -> CGFloat {
        if isLast(item) { return 1 }
        if gestureTranslation.isZero { return  1 - invertedIndex(of: item).floatValue * scaleFactor }

        let scaleValue = invertedIndex(of: item).floatValue * scaleFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.7, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    func getOverlayOpacity(for item: AnyPopup<TopPopupConfig>) -> Double {
        if isLast(item) { return 0 }
        if gestureTranslation.isZero { return invertedIndex(of: item).doubleValue * overlayFactor }

        let scaleValue = invertedIndex(of: item).doubleValue * overlayFactor
        let translationProgress = 1 - translationProgress()
        let progressDifference = isNextToLast(item) ? translationProgress : max(0.6, translationProgress)
        return scaleValue * progressDifference
    }
    func getOpacity(for item: AnyPopup<TopPopupConfig>) -> Double { invertedIndex(of: item) <= globalConfig.top.stackLimit ? 1 : 0.000000001 }
    func getBackgroundColour(for item: AnyPopup<TopPopupConfig>) -> Color { item.configurePopup(popup: .init()).backgroundColour ?? globalConfig.top.backgroundColour }
    func getOffset(for item: AnyPopup<TopPopupConfig>) -> CGFloat { isLast(item) ? gestureTranslation : invertedIndex(of: item).floatValue * offsetFactor }
    func getZIndex(for item: AnyPopup<TopPopupConfig>) -> Double { (items.lastIndex(of: item)?.doubleValue ?? 0) + 1 }
    func saveHeight(_ height: CGFloat, for item: AnyPopup<TopPopupConfig>) { heights[item] = height }
}

private extension PopupTopStackView {
    func translationProgress() -> CGFloat { abs(gestureTranslation) / height }
    func isLast(_ item: AnyPopup<TopPopupConfig>) -> Bool { items.last == item }
    func isNextToLast(_ item: AnyPopup<TopPopupConfig>) -> Bool { index(of: item) == items.count - 2 }
    func invertedIndex(of item: AnyPopup<TopPopupConfig>) -> Int { items.count - 1 - index(of: item) }
    func index(of item: AnyPopup<TopPopupConfig>) -> Int { items.firstIndex(of: item) ?? 0 }
}

private extension PopupTopStackView {
    var contentTopPadding: CGFloat { config.contentIgnoresSafeArea ? 0 : max(screen.safeArea.top - topPadding, 0) }
    var topPadding: CGFloat { config.popupPadding.top }
    var height: CGFloat { heights.first { $0.key == items.last }?.value ?? 0 }
    var offsetFactor: CGFloat { globalConfig.top.stackOffset }
    var scaleFactor: CGFloat { globalConfig.top.stackScaleFactor }
    var cornerRadius: CGFloat { config.cornerRadius ?? globalConfig.top.cornerRadius }
    var stackedCornerRadius: CGFloat { cornerRadius * globalConfig.top.stackCornerRadiusMultiplier }
    var overlayColour: Color { .black }
    var overlayFactor: Double { 1 / globalConfig.top.stackLimit.doubleValue * 0.5 }
    var transitionAnimation: Animation { globalConfig.main.animation.entry }
    var dragGestureAnimation: Animation { globalConfig.main.animation.removal }
    var gestureClosingThresholdFactor: CGFloat { globalConfig.top.dragGestureProgressToClose }
    var transition: AnyTransition { .move(edge: .top) }
    var config: TopPopupConfig { items.last?.configurePopup(popup: .init()) ?? .init() }
}
