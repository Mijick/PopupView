//
//  PopupStack.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

protocol PopupStack: View {
    associatedtype Config: Configurable

    var items: [AnyPopup<Config>] { get }
    var heights: [ID: CGFloat] { get }
    var globalConfig: GlobalConfig { get }
    var gestureTranslation: CGFloat { get }
    var isGestureActive: Bool { get }
    var translationProgress: CGFloat { get }
    var cornerRadius: CGFloat { get }

    var stackLimit: Int { get }
    var stackScaleFactor: CGFloat { get }
    var stackCornerRadiusMultiplier: CGFloat { get }
    var stackOffsetValue: CGFloat { get }

    var tapOutsideClosesPopup: Bool { get }
}
extension PopupStack {
    var heights: [ID: CGFloat] { [:] }
    var gestureTranslation: CGFloat { 0 }
    var isGestureActive: Bool { false }
    var translationProgress: CGFloat { 1 }

    var stackLimit: Int { 1 }
    var stackScaleFactor: CGFloat { 1 }
    var stackCornerRadiusMultiplier: CGFloat { 0 }
    var stackOffsetValue: CGFloat { 0 }
}


// MARK: - Tapable Area
extension PopupStack {
    @ViewBuilder func createTapArea() -> some View { if tapOutsideClosesPopup {
        Color.black.opacity(0.00000000001).onTapGesture(perform: items.last?.dismiss ?? {})
    }}
}


// MARK: - Corner Radius
extension PopupStack {
    func getCornerRadius(_ item: AnyPopup<Config>) -> CGFloat {
        if isLast(item) { return cornerRadius }
        if translationProgress.isZero || translationProgress.isNaN || !isNextToLast(item) { return stackedCornerRadius }

        let difference = cornerRadius - stackedCornerRadius
        let differenceProgress = difference * translationProgress
        return stackedCornerRadius + differenceProgress
    }
}
private extension PopupStack {
    var stackedCornerRadius: CGFloat { cornerRadius * stackCornerRadiusMultiplier }
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
    func getOffset(_ item: AnyPopup<Config>) -> CGFloat {
        if isLast(item) {
            return max(gestureTranslation, 0)
        }


        return invertedIndex(item).floatValue * stackOffsetValue

        //isLast(item) ? gestureTranslation : invertedIndex(item).floatValue * stackOffsetValue



    }
}

// MARK: - Initial Height
extension PopupStack {
    func getInitialHeight() -> CGFloat {
        guard let previousView = items.nextToLast else { return 30 }

        let height = heights.filter { $0.key == previousView.id }.first?.value ?? 30
        return height
    }
}

// MARK: - Item ZIndex
extension PopupStack {
    func getZIndex(_ item: AnyPopup<Config>) -> Double { .init(items.firstIndex(of: item) ?? 2137) }
}


// MARK: - Animations
extension PopupStack {
    func getHeightAnimation(isAnimationDisabled: Bool) -> Animation? { !isAnimationDisabled ? transitionEntryAnimation : nil }
}
extension PopupStack {
    var transitionEntryAnimation: Animation { globalConfig.common.animation.entry }
    var transitionRemovalAnimation: Animation { globalConfig.common.animation.removal }
    var dragGestureAnimation: Animation { globalConfig.common.animation.dragGesture }
}

// MARK: - Configurables
extension PopupStack {
    func getConfig(_ item: AnyPopup<Config>) -> Config { item.configurePopup(popup: .init()) }
    var lastPopupConfig: Config { items.last?.configurePopup(popup: .init()) ?? .init() }
}


// MARK: - Helpers
private extension PopupStack {
    func isLast(_ item: AnyPopup<Config>) -> Bool { items.last == item }
    func isNextToLast(_ item: AnyPopup<Config>) -> Bool { invertedIndex(item) == 1 }
    func invertedIndex(_ item: AnyPopup<Config>) -> Int { items.count - 1 - index(item) }
    func index(_ item: AnyPopup<Config>) -> Int { items.firstIndex(of: item) ?? 0 }
}
private extension PopupStack {
    var remainingTranslationProgress: CGFloat { 1 - translationProgress }
}
