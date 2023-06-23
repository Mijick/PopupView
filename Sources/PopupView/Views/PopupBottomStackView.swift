//
//  PopupBottomStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupBottomStackView: View {
    let items: [AnyPopup<BottomPopupConfig>]
    let keyboardHeight: CGFloat
    @ObservedObject private var screen: ScreenManager = .shared
    @State private var heights: [AnyPopup<BottomPopupConfig>: CGFloat] = [:]
    @State private var gestureTranslation: CGFloat = 0
    @State private var cacheCleanerTrigger: Bool = false

    
    var body: some View {
        ZStack(alignment: .top, content: createPopupStack)
            .ignoresSafeArea()
            .background(createTapArea())
            .animation(transitionAnimation, value: items)
            .animation(dragGestureAnimation, value: gestureTranslation)
            .onDragGesture(onChanged: onPopupDragGestureChanged, onEnded: onPopupDragGestureEnded)
            .onChange(of: items, perform: onItemsChange)
            .onChange(of: screen.size, perform: onScreenChange)
            .clearCacheObjects(shouldClear: items.isEmpty, trigger: $cacheCleanerTrigger)
    }
}

private extension PopupBottomStackView {
    func createPopupStack() -> some View {
        ForEach(items, id: \.self, content: createPopup)
    }
    func createTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismiss ?? {})
            .active(if: config.tapOutsideClosesView)
    }
}

private extension PopupBottomStackView {
    func createPopup(_ item: AnyPopup<BottomPopupConfig>) -> some View {
        item.body
            .padding(.bottom, getContentBottomPadding())
            .padding(.leading, screen.safeArea.left)
            .padding(.trailing, screen.safeArea.right)
            .readHeight { saveHeight($0, withAnimation: transitionAnimation, for: item) }
            .frame(height: height, alignment: .top).frame(maxWidth: .infinity)
            .background(backgroundColour, radius: getCornerRadius(for: item), corners: getCorners())
            .padding(.horizontal, config.popupPadding.horizontal)
            .opacity(getOpacity(for: item))
            .offset(y: getOffset(for: item))
            .scaleEffect(getScale(for: item), anchor: .top)
            .compositingGroup()
            .focusSectionIfAvailable()
            .alignToBottom(if: !config.contentFillsEntireScreen, popupBottomPadding)
            .transition(transition)
            .zIndex(isLast(item).doubleValue)
    }
}

// MARK: - Gesture Handler
private extension PopupBottomStackView {
    func onPopupDragGestureChanged(_ value: CGFloat) {
        if config.dragGestureEnabled { gestureTranslation = max(0, value) }
    }
    func onPopupDragGestureEnded(_ value: CGFloat) {
        if translationProgress() >= gestureClosingThresholdFactor { items.last?.dismiss() }
        gestureTranslation = 0
    }
}

// MARK: - Action Modifiers
private extension PopupBottomStackView {
    func onItemsChange(_ items: [AnyPopup<BottomPopupConfig>]) { items.last?.configurePopup(popup: .init()).onFocus() }
    func onScreenChange(_ value: Any) { if let lastItem = items.last { saveHeight(heights[lastItem] ?? .infinity, withAnimation: nil, for: lastItem) }}
}

// MARK: - View Handlers
private extension PopupBottomStackView {
    func getCornerRadius(for item: AnyPopup<BottomPopupConfig>) -> CGFloat {
        if isLast(item) { return min(config.contentFillsEntireScreen ? screen.cornerRadius ?? 32 : .infinity, cornerRadius.active) }
        if gestureTranslation.isZero || !isNextToLast(item) { return cornerRadius.inactive }

        let difference = cornerRadius.active - cornerRadius.inactive
        let differenceProgress = difference * translationProgress()
        return cornerRadius.inactive + differenceProgress
    }
    func getCorners() -> RectCorner {
        switch popupBottomPadding {
            case 0: return [.topLeft, .topRight]
            default: return .allCorners
        }
    }
    func getOpacity(for item: AnyPopup<BottomPopupConfig>) -> Double {
        if isLast(item) { return 1 }
        if gestureTranslation.isZero { return  1 - invertedIndex(of: item).doubleValue * opacityFactor }

        let scaleValue = invertedIndex(of: item).doubleValue * opacityFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.6, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    func getScale(for item: AnyPopup<BottomPopupConfig>) -> CGFloat {
        if isLast(item) { return 1 }
        if gestureTranslation.isZero { return  1 - invertedIndex(of: item).floatValue * scaleFactor }

        let scaleValue = invertedIndex(of: item).floatValue * scaleFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.7, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    func saveHeight(_ height: CGFloat, withAnimation animation: Animation?, for item: AnyPopup<BottomPopupConfig>) { withAnimation(animation) {
        let config = item.configurePopup(popup: .init())

        if config.contentFillsEntireScreen { return heights[item] = screen.size.height }
        if config.contentFillsWholeHeight { return heights[item] = getMaxHeight() }
        return heights[item] = min(height, getMaxHeight() - popupBottomPadding)
    }}
    func getMaxHeight() -> CGFloat {
        let basicHeight = screen.size.height - screen.safeArea.top
        let stackedViewsCount = min(max(0, config.stackLimit - 1), items.count - 1)
        let stackedViewsHeight = config.stackOffset * .init(stackedViewsCount) * maxHeightStackedFactor
        return basicHeight - stackedViewsHeight
    }
    func getContentBottomPadding() -> CGFloat {
        if isKeyboardVisible { return keyboardHeight + config.distanceFromKeyboard }
        if config.contentIgnoresSafeArea { return 0 }

        return max(screen.safeArea.bottom - popupBottomPadding, 0)
    }
    func getOffset(for item: AnyPopup<BottomPopupConfig>) -> CGFloat { isLast(item) ? gestureTranslation : invertedIndex(of: item).floatValue * offsetFactor }
}

private extension PopupBottomStackView {
    func translationProgress() -> CGFloat { abs(gestureTranslation) / height }
    func isLast(_ item: AnyPopup<BottomPopupConfig>) -> Bool { items.last == item }
    func isNextToLast(_ item: AnyPopup<BottomPopupConfig>) -> Bool { index(of: item) == items.count - 2 }
    func invertedIndex(of item: AnyPopup<BottomPopupConfig>) -> Int { items.count - 1 - index(of: item) }
    func index(of item: AnyPopup<BottomPopupConfig>) -> Int { items.firstIndex(of: item) ?? 0 }
}

private extension PopupBottomStackView {
    var popupBottomPadding: CGFloat { config.popupPadding.bottom }
    var height: CGFloat { heights.first { $0.key == items.last }?.value ?? defaultHeight }
    var defaultHeight: CGFloat { config.contentFillsEntireScreen ? screen.size.height : 0 }
    var maxHeightStackedFactor: CGFloat { 0.85 }
    var opacityFactor: Double { 1 / config.stackLimit.doubleValue }
    var offsetFactor: CGFloat { -config.stackOffset }
    var scaleFactor: CGFloat { config.stackScaleFactor }
    var cornerRadius: (active: CGFloat, inactive: CGFloat) { (config.activePopupCornerRadius, config.stackCornerRadius) }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var dragGestureAnimation: Animation { config.dragGestureAnimation }
    var gestureClosingThresholdFactor: CGFloat { config.dragGestureProgressToClose }
    var transition: AnyTransition { .move(edge: .bottom) }
    var isKeyboardVisible: Bool { keyboardHeight > 0 }
    var config: BottomPopupConfig { items.last?.configurePopup(popup: .init()) ?? .init() }
}
