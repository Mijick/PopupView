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
    @State private var heights: [AnyPopup<TopPopupConfig>: CGFloat] = [:]
    @State private var gestureTranslation: CGFloat = 0
    @State private var cacheCleanerTrigger: Bool = false

    
    var body: some View {
        ZStack(alignment: .bottom, content: createPopupStack)
            .ignoresSafeArea()
            .animation(transitionAnimation, value: items)
            .animation(transitionAnimation, value: heights)
            .animation(dragGestureAnimation, value: gestureTranslation)
            .simultaneousGesture(popupDragGesture)
            .clearCacheObjects(shouldClear: items.isEmpty, trigger: $cacheCleanerTrigger)
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
            .readHeight { saveHeight($0, for: item) }
            .frame(width: width, height: height)
            .background(backgroundColour)
            .cornerRadius(getCornerRadius(for: item))
            .opacity(getOpacity(for: item))
            .offset(y: getOffset(for: item))
            .scaleEffect(getScale(for: item), anchor: .bottom)
            .alignToTop(topPadding)
            .transition(transition)
            .zIndex(isLast(item).doubleValue)
    }
}

// MARK: -Gesture Handler
private extension PopupTopStackView {
    var popupDragGesture: some Gesture {
        DragGesture()
            .onChanged(onPopupDragGestureChanged)
            .onEnded(onPopupDragGestureEnded)
    }
    func onPopupDragGestureChanged(_ value: DragGesture.Value) {
        if config.dragGestureEnabled { gestureTranslation = min(0, value.translation.height) }
    }
    func onPopupDragGestureEnded(_ value: DragGesture.Value) {
        if translationProgress() >= gestureClosingThresholdFactor { items.last?.dismiss() }
        gestureTranslation = 0
    }
}

// MARK: -View Handlers
private extension PopupTopStackView {
    func getCornerRadius(for item: AnyPopup<TopPopupConfig>) -> CGFloat {
        if isLast(item) { return cornerRadius.active }
        if gestureTranslation.isZero || !isNextToLast(item) { return cornerRadius.inactive }

        let difference = cornerRadius.active - cornerRadius.inactive
        let differenceProgress = difference * translationProgress()
        return cornerRadius.inactive + differenceProgress
    }
    func getOpacity(for item: AnyPopup<TopPopupConfig>) -> Double {
        if isLast(item) { return 1 }
        if gestureTranslation.isZero { return  1 - invertedIndex(of: item).doubleValue * opacityFactor }

        let scaleValue = invertedIndex(of: item).doubleValue * opacityFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.6, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    func getScale(for item: AnyPopup<TopPopupConfig>) -> CGFloat {
        if isLast(item) { return 1 }
        if gestureTranslation.isZero { return  1 - invertedIndex(of: item).floatValue * scaleFactor }

        let scaleValue = invertedIndex(of: item).floatValue * scaleFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.7, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    func getOffset(for item: AnyPopup<TopPopupConfig>) -> CGFloat { isLast(item) ? gestureTranslation : invertedIndex(of: item).floatValue * offsetFactor }
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
    var contentTopPadding: CGFloat { config.contentIgnoresSafeArea ? 0 : max(UIScreen.safeArea.top - config.topPadding, 0) }
    var topPadding: CGFloat { config.topPadding }
    var width: CGFloat { UIScreen.width - config.horizontalPadding * 2 }
    var height: CGFloat { heights.first { $0.key == items.last }?.value ?? 0 }
    var opacityFactor: Double { 1 / config.maxStackedElements.doubleValue }
    var offsetFactor: CGFloat { config.stackedViewsOffset }
    var scaleFactor: CGFloat { config.stackedViewsScale }
    var cornerRadius: (active: CGFloat, inactive: CGFloat) { (config.activeViewCornerRadius, config.stackedViewsCornerRadius) }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var dragGestureAnimation: Animation { config.dragGestureAnimation }
    var gestureClosingThresholdFactor: CGFloat { config.dragGestureProgressToClose }
    var transition: AnyTransition { .move(edge: .top) }
    var config: TopPopupConfig { items.last?.configurePopup(popup: .init()) ?? .init() }
}
