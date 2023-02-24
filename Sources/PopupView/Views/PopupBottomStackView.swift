//
//  PopupBottomStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public extension PopupBottomStackView {
    struct Config {
        public var contentIgnoresSafeArea: Bool = false

        public var horizontalPadding: CGFloat = 0
        public var bottomPadding: CGFloat = 0
        public var stackedViewsOffset: CGFloat = 12
        public var stackedViewsScale: CGFloat = 0.09
        public var stackedViewsCornerRadius: CGFloat = 10
        public var activeViewCornerRadius: CGFloat = 32
        public var maxStackedElements: Int = 4
        public var dragGestureProgressToClose: CGFloat = 1/3

        public var viewOverlayColour: Color = .black.opacity(0.6)
        public var backgroundColour: Color = .white

        public var transitionAnimation: Animation { .spring(response: 0.44, dampingFraction: 1, blendDuration: 0.4) }
        public var dragGestureAnimation: Animation { .interactiveSpring() }
    }
}


public struct PopupBottomStackView: View {
    let items: [AnyBottomPopup]
    let closingAction: () -> ()
    var config: Config = .init()
    @State private var heights: [String: CGFloat] = [:]
    @State private var gestureTranslation: CGFloat = 0


    public init(items: [AnyBottomPopup], closingAction: @escaping () -> (), configBuilder: (inout Config) -> ()) {
        self.items = items
        self.closingAction = closingAction
        configBuilder(&config)
    }
    public var body: some View {
        ZStack(alignment: .top, content: createPopupStack)
            .ignoresSafeArea()
            .animation(transitionAnimation, value: items.map(\.id))
            .animation(transitionAnimation, value: heights)
            .animation(dragGestureAnimation, value: gestureTranslation)
            .simultaneousGesture(popupDragGesture)
    }
}

private extension PopupBottomStackView {
    func createPopupStack() -> some View {
        ForEach(0..<items.count, id: \.self, content: createPopup)
    }
}

private extension PopupBottomStackView {
    func createPopup(_ index: Int) -> some View {
        items[index]
            .padding(.bottom, contentBottomPadding)
            .readHeight { saveHeight($0, for: index) }
            .frame(width: width, height: height)
            .background(backgroundColour)
            .cornerRadius(getCornerRadius(for: index))
            .opacity(getOpacity(for: index))
            .offset(y: getOffset(for: index))
            .scaleEffect(getScale(for: index), anchor: .top)
            .alignToBottom(config.bottomPadding)
            .transition(transition)
            .zIndex(isLast(index).doubleValue)
    }
    func createViewOverlay() -> some View {
        viewOverlayColour.active(if: !items.isEmpty)
    }
}

// MARK: -Gesture Handler
private extension PopupBottomStackView {
    var popupDragGesture: some Gesture {
        DragGesture()
            .onChanged(onPopupDragGestureChanged)
            .onEnded(onPopupDragGestureEnded)
    }
    func onPopupDragGestureChanged(_ value: DragGesture.Value) {
        gestureTranslation = max(0, value.translation.height)
    }
    func onPopupDragGestureEnded(_ value: DragGesture.Value) {
        if translationProgress() >= gestureClosingThresholdFactor { closingAction() }
        gestureTranslation = 0
    }
}

// MARK: -View Handlers
private extension PopupBottomStackView {
    func getCornerRadius(for index: Int) -> CGFloat {
        if isLast(index) { return cornerRadius.active }
        if gestureTranslation.isZero || !isNextToLast(index) { return cornerRadius.inactive }

        let difference = cornerRadius.active - cornerRadius.inactive
        let differenceProgress = difference * translationProgress()
        return cornerRadius.inactive + differenceProgress
    }
    func getOpacity(for index: Int) -> Double {
        if isLast(index) { return 1 }
        if gestureTranslation.isZero { return  1 - inverted(index: index).doubleValue * opacityFactor }

        let scaleValue = inverted(index: index).doubleValue * opacityFactor
        let progressDifference = isNextToLast(index) ? 1 - translationProgress() : max(0.6, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    func getScale(for index: Int) -> CGFloat {
        if isLast(index) { return 1 }
        if gestureTranslation.isZero { return  1 - inverted(index: index).floatValue * scaleFactor }

        let scaleValue = inverted(index: index).floatValue * scaleFactor
        let progressDifference = isNextToLast(index) ? 1 - translationProgress() : max(0.7, 1 - translationProgress())
        return 1 - scaleValue * progressDifference
    }
    func getOffset(for index: Int) -> CGFloat { isLast(index) ? gestureTranslation : inverted(index: index).floatValue * offsetFactor }
    func saveHeight(_ height: CGFloat, for index: Int) { heights[items[index].id] = height }
}

private extension PopupBottomStackView {
    func translationProgress() -> CGFloat { abs(gestureTranslation) / height }
    func isLast(_ index: Int) -> Bool { index == items.count - 1 }
    func isNextToLast(_ index: Int) -> Bool { index == items.count - 2 }
    func inverted(index: Int) -> Int { items.count - 1 - index }
}

private extension PopupBottomStackView {
    var contentBottomPadding: CGFloat { config.contentIgnoresSafeArea ? 0 : max(UIScreen.safeArea.bottom - config.bottomPadding, 0) }
    var width: CGFloat { UIScreen.width - config.horizontalPadding * 2 }
    var height: CGFloat { heights.first { $0.key == items.last?.id }?.value ?? 0 }
    var opacityFactor: Double { 1 / config.maxStackedElements.doubleValue }
    var offsetFactor: CGFloat { -config.stackedViewsOffset }
    var scaleFactor: CGFloat { config.stackedViewsScale }
    var cornerRadius: (active: CGFloat, inactive: CGFloat) { (config.activeViewCornerRadius, config.stackedViewsCornerRadius) }
    var viewOverlayColour: Color { config.viewOverlayColour }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var dragGestureAnimation: Animation { config.dragGestureAnimation }
    var gestureClosingThresholdFactor: CGFloat { config.dragGestureProgressToClose }
    var transition: AnyTransition { .move(edge: .bottom) }
}
