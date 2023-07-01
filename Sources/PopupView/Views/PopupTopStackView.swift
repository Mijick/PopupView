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
            .animation(transitionAnimation, value: heights)
            .animation(dragGestureAnimation, value: gestureTranslation)
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
        if translationProgress >= gestureClosingThresholdFactor { items.last?.dismiss() }
        gestureTranslation = 0
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
    var height: CGFloat { heights.first { $0.key == items.last }?.value ?? 0 }
    var cornerRadius: CGFloat { lastPopupConfig.cornerRadius ?? globalConfig.top.cornerRadius }

    var stackLimit: Int { globalConfig.top.stackLimit }
    var stackScaleFactor: CGFloat { globalConfig.top.stackScaleFactor }
    var stackOffsetValue: CGFloat { globalConfig.top.stackOffset }
    var stackedCornerRadius: CGFloat { cornerRadius * globalConfig.top.stackCornerRadiusMultiplier }

    var translationProgress: CGFloat { abs(gestureTranslation) / height }
    var gestureClosingThresholdFactor: CGFloat { globalConfig.top.dragGestureProgressToClose }

    var transitionAnimation: Animation { globalConfig.main.animation.entry }
    var dragGestureAnimation: Animation { globalConfig.main.animation.removal }
    var transition: AnyTransition { .move(edge: .top) }

    var tapOutsideClosesPopup: Bool { lastPopupConfig.tapOutsideClosesView ?? globalConfig.top.tapOutsideClosesView }
}






















protocol PopupStack: View {
    var items: [AnyPopup<Config>] { get }


    var stackLimit: Int { get }
    var translationProgress: CGFloat { get }
    var stackScaleFactor: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var stackedCornerRadius: CGFloat { get }
    var tapOutsideClosesPopup: Bool { get }
    var stackOffsetValue: CGFloat { get }


    var gestureTranslation: CGFloat { get }


    associatedtype Config: Configurable

}
extension PopupStack {
    var lastPopupConfig: Config { items.last?.configurePopup(popup: .init()) ?? .init() }
}


extension PopupStack {
    func getConfig(_ item: AnyPopup<Config>) -> Config { item.configurePopup(popup: .init()) }
}



extension PopupStack {
    func isLast(_ item: AnyPopup<Config>) -> Bool { items.last == item }
    func isNextToLast(_ item: AnyPopup<Config>) -> Bool { invertedIndex(item) == 1 }
    func invertedIndex(_ item: AnyPopup<Config>) -> Int { items.count - 1 - index(item) }
    func index(_ item: AnyPopup<Config>) -> Int { items.firstIndex(of: item) ?? 0 }
}


extension PopupStack {
    var stackLimit: Int { 1 }
    var translationProgress: CGFloat { 1 }
    var stackScaleFactor: CGFloat { 1 }
    var stackedCornerRadius: CGFloat { 0 }
    var stackOffsetValue: CGFloat { 0 }
}


// MARK: - Corner Radius
extension PopupStack {
    func getCornerRadius(_ item: AnyPopup<Config>) -> CGFloat {
        if isLast(item) { return cornerRadius }
        if translationProgress.isZero || !isNextToLast(item) { return stackedCornerRadius }

        let difference = cornerRadius - stackedCornerRadius
        let differenceProgress = difference * translationProgress
        return stackedCornerRadius + differenceProgress
    }
}

// MARK: - Scale
extension PopupStack {
    func getScale(_ item: AnyPopup<Config>) -> CGFloat {
        let scaleValue = invertedIndex(item).floatValue * stackScaleFactor
        let progressDifference = isNextToLast(item) ? remainingTranslationProgress : max(0.7, remainingTranslationProgress)
        let scale = 1 - scaleValue * progressDifference
        return min(1, scale)
    }
}

// MARK: - Stack Overlay Colour
extension PopupStack {
    func getStackOverlayColour(_ item: AnyPopup<Config>) -> Color {
        let opacity = calculateStackOverlayOpacity(item)
        return stackOverlayColour.opacity(opacity)
    }
}
private extension PopupStack {
    func calculateStackOverlayOpacity(_ item: AnyPopup<Config>) -> Double {
        let overlayValue = invertedIndex(item).doubleValue * stackOverlayFactor
        let remainingTranslationProgressValue = isNextToLast(item) ? remainingTranslationProgress : max(0.6, remainingTranslationProgress)
        let opacity = overlayValue * remainingTranslationProgressValue
        return max(0, opacity)
    }
}
private extension PopupStack {
    var stackOverlayColour: Color { .black }
    var stackOverlayFactor: CGFloat { 1 / stackLimit.doubleValue * 0.5 }
}

// MARK: - Stack Opacity
extension PopupStack {
    func getOpacity(_ item: AnyPopup<Config>) -> Double { invertedIndex(item) <= stackLimit ? 1 : 0.000000001 }
}

// MARK: - Stack Offset
extension PopupStack {
    func getOffset(_ item: AnyPopup<Config>) -> CGFloat { isLast(item) ? gestureTranslation : invertedIndex(item).floatValue * stackOffsetValue }
}

// MARK: - Z Index
extension PopupStack {
    func getZIndex(_ item: AnyPopup<Config>) -> Double { index(item).doubleValue + 1 }
}






private extension PopupStack {
    var remainingTranslationProgress: CGFloat { 1 - translationProgress }
}



extension PopupStack {
    @ViewBuilder func createTapArea() -> some View { if tapOutsideClosesPopup {
        Color.black.opacity(0.00000000001).onTapGesture(perform: items.last?.dismiss ?? {})
    }}
}
