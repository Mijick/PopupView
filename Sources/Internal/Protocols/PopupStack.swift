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

    var items: [AnyPopup] { get }
    var dragHeights: [ID: CGFloat] { get }
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
    var dragHeights: [ID: CGFloat] { [:] }
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
    func getCornerRadius(_ item: AnyPopup) -> CGFloat {
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
    func getScale(_ item: AnyPopup) -> CGFloat {
        let scaleValue = invertedIndex(item).floatValue * stackScaleFactor
        let progressDifference = isNextToLast(item) ? remainingTranslationProgress : max(0.7, remainingTranslationProgress)
        let scale = 1 - scaleValue * progressDifference
        return min(1, scale)
    }
}

// MARK: - Stack Overlay Colour
extension PopupStack {
    func getStackOverlayColour(_ item: AnyPopup) -> Color {
        let opacity = calculateStackOverlayOpacity(item)
        return stackOverlayColour.opacity(opacity)
    }
}
private extension PopupStack {
    func calculateStackOverlayOpacity(_ item: AnyPopup) -> Double {
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
    func getOpacity(_ item: AnyPopup) -> Double { invertedIndex(item) <= stackLimit ? 1 : 0.000000001 }
}

// MARK: - Stack Offset
extension PopupStack {
    func getOffset(_ item: AnyPopup) -> CGFloat { switch isLast(item) {
        case true: calculateOffsetForLastItem()
        case false: calculateOffsetForOtherItems(item)
    }}
}
private extension PopupStack {
    func calculateOffsetForLastItem() -> CGFloat { switch Config.self {
        case is BottomPopupConfig.Type: max(gestureTranslation - getLastDragHeight(), 0)
        case is TopPopupConfig.Type: min(gestureTranslation + getLastDragHeight(), 0)
        default: 0
    }}
    func calculateOffsetForOtherItems(_ item: AnyPopup) -> CGFloat {
        invertedIndex(item).floatValue * stackOffsetValue
    }
}

// MARK: - Last Popup Height
extension PopupStack {
    func getLastPopupHeight() -> CGFloat? { items.last?.height }
}

// MARK: - Drag Height Value
extension PopupStack {
    func getLastDragHeight() -> CGFloat { dragHeights[items.last?.id ?? .init()] ?? 0 }
}

// MARK: - Item ZIndex
extension PopupStack {
    func getZIndex(_ item: AnyPopup) -> Double { .init(items.firstIndex(of: item) ?? 2137) }
}


// MARK: - Animations
extension PopupStack {
    func getHeightAnimation(isAnimationDisabled: Bool) -> Animation? { !isAnimationDisabled ? .transition : nil }
}

// MARK: - Configurables
extension PopupStack {
    func getConfig(_ item: AnyPopup) -> Config { (item.config as? Config) ?? .init() }
    var lastPopupConfig: Config { (items.last?.config as? Config) ?? .init() }
}


// MARK: - Helpers
private extension PopupStack {
    func isLast(_ item: AnyPopup) -> Bool { items.last == item }
    func isNextToLast(_ item: AnyPopup) -> Bool { invertedIndex(item) == 1 }
    func invertedIndex(_ item: AnyPopup) -> Int { items.count - 1 - index(item) }
    func index(_ item: AnyPopup) -> Int { items.firstIndex(of: item) ?? 0 }
}
private extension PopupStack {
    var remainingTranslationProgress: CGFloat { 1 - translationProgress }
}
