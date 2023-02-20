//
//  PopupTopStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public extension PopupTopStackView {
    struct Config {
        public var contentIgnoresSafeArea: Bool = false

        public var horizontalPadding: CGFloat = 0
        public var topPadding: CGFloat = 0
        public var stackedViewsOffset: CGFloat = 6
        public var stackedViewsScale: CGFloat = 0.06
        public var stackedViewsCornerRadius: CGFloat = 10
        public var activeViewCornerRadius: CGFloat = 24
        public var maxStackedElements: Int = 4
        public var dragGestureProgressToClose: CGFloat = 1/3

        public var viewOverlayColour: Color = .black.opacity(0.6)
        public var backgroundColour: Color = .white

        public var transitionAnimation: Animation { .spring(response: 0.32, dampingFraction: 1, blendDuration: 0.32) }
        public var dragGestureAnimation: Animation { .interactiveSpring() }
    }
}


public struct PopupTopStackView: View {
    let items: [AnyPopup]
    let closingAction: () -> ()
    var config: Config = .init()
    @State private var heights: [AnyPopup: CGFloat] = [:]
    @State private var gestureTranslation: CGFloat = 0


    public init(items: [AnyPopup], closingAction: @escaping () -> (), configBuilder: (inout Config) -> ()) {
        self.items = items
        self.closingAction = closingAction
        configBuilder(&config)
    }
    public var body: some View {
        ZStack(alignment: .bottom, content: createPopupStack)
            .frame(width: UIScreen.width, height: UIScreen.height)
            .ignoresSafeArea()
            .background(createViewOverlay())
            .animation(transitionAnimation, value: items)
            .animation(transitionAnimation, value: heights)
            .animation(dragGestureAnimation, value: gestureTranslation)
            .simultaneousGesture(popupDragGesture)
    }
}

private extension PopupTopStackView {
    func createPopupStack() -> some View {
        ForEach(items, id: \.self, content: createPopup)
    }
}

private extension PopupTopStackView {
    func createPopup(_ item: AnyPopup) -> some View {
        item.view
            .padding(.top, contentTopPadding)
            .readHeight { getHeight($0, for: item) }
            .frame(width: width, height: height)
            .background(backgroundColour)
            .cornerRadius(getCornerRadius(for: item))
            .opacity(getOpacity(for: item))
            .offset(y: getOffset(for: item))
            .scaleEffect(getScale(for: item), anchor: .bottom)
            .alignToTop(config.topPadding)
            .transition(transition)
            .zIndex(isLast(item).doubleValue)
    }
    func createViewOverlay() -> some View {
        viewOverlayColour.active(if: !items.isEmpty)
    }
}

private extension PopupTopStackView {
    var popupDragGesture: some Gesture {
        DragGesture()
            .onChanged(onPopupDragGestureChanged)
            .onEnded(onPopupDragGestureEnded)
    }
    func onPopupDragGestureChanged(_ value: DragGesture.Value) {
        gestureTranslation = min(0, value.translation.height)
    }
    func onPopupDragGestureEnded(_ value: DragGesture.Value) {
        if translationProgress() >= gestureClosingThresholdFactor { closingAction() }
        gestureTranslation = 0
    }
}

private extension PopupTopStackView {
    func getCornerRadius(for item: AnyPopup) -> CGFloat {
        if isLast(item) { return cornerRadius.active }
        if gestureTranslation.isZero || !isNextToLast(item) { return cornerRadius.inactive }

        let difference = cornerRadius.active - cornerRadius.inactive
        let differenceProgress = difference * translationProgress()
        return cornerRadius.inactive + differenceProgress
    }
    func getOpacity(for item: AnyPopup) -> Double {
        if isLast(item) { return 1 }
        if gestureTranslation.isZero { return  1 - invertedIndex(of: item).doubleValue * opacityFactor }

        let scaleValue = invertedIndex(of: item).doubleValue * opacityFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.6, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    func getScale(for item: AnyPopup) -> CGFloat {
        if isLast(item) { return 1 }
        if gestureTranslation.isZero { return  1 - invertedIndex(of: item).floatValue * scaleFactor }

        let scaleValue = invertedIndex(of: item).floatValue * scaleFactor
        let progressDifference = isNextToLast(item) ? 1 - translationProgress() : max(0.7, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    func getOffset(for item: AnyPopup) -> CGFloat { isLast(item) ? gestureTranslation : invertedIndex(of: item).floatValue * offsetFactor }
    func getHeight(_ height: CGFloat, for item: AnyPopup) { heights[item] = height }
}

private extension PopupTopStackView {
    func translationProgress() -> CGFloat { abs(gestureTranslation) / height }
    func isLast(_ item: AnyPopup) -> Bool { items.last == item }
    func isNextToLast(_ item: AnyPopup) -> Bool { index(of: item) == items.count - 2 }
    func invertedIndex(of item: AnyPopup) -> Int { items.count - 1 - index(of: item) }
    func index(of item: AnyPopup) -> Int { items.firstIndex(of: item) ?? 0 }
}

private extension PopupTopStackView {
    var contentTopPadding: CGFloat { config.contentIgnoresSafeArea ? 0 : max(UIScreen.safeArea.top - config.topPadding, 0) }
    var width: CGFloat { UIScreen.width - config.horizontalPadding * 2 }
    var height: CGFloat { heights.first { $0.key == items.last }?.value ?? 0 }
    var opacityFactor: Double { 1 / config.maxStackedElements.doubleValue }
    var offsetFactor: CGFloat { config.stackedViewsOffset }
    var scaleFactor: CGFloat { config.stackedViewsScale }
    var cornerRadius: (active: CGFloat, inactive: CGFloat) { (config.activeViewCornerRadius, config.stackedViewsCornerRadius) }
    var viewOverlayColour: Color { config.viewOverlayColour }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var dragGestureAnimation: Animation { config.dragGestureAnimation }
    var gestureClosingThresholdFactor: CGFloat { config.dragGestureProgressToClose }
    var transition: AnyTransition { .move(edge: .top) }
}
