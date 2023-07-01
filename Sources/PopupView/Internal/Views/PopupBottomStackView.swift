//
//  PopupBottomStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupBottomStackView: PopupStack {
    let items: [AnyPopup<BottomPopupConfig>]
    let globalConfig: GlobalConfig
    @State var gestureTranslation: CGFloat = 0
    @State var heights: [AnyPopup<BottomPopupConfig>: CGFloat] = [:]
    @ObservedObject private var screen: ScreenManager = .shared
    @ObservedObject private var keyboardManager: KeyboardManager = .shared

    
    var body: some View {
        ZStack(alignment: .top, content: createPopupStack)
            .ignoresSafeArea()
            .background(createTapArea())
            .animation(transitionRemovalAnimation, value: gestureTranslation)
            .onDragGesture(onChanged: onPopupDragGestureChanged, onEnded: onPopupDragGestureEnded)
            .onChange(of: screen.size, perform: onScreenChange)
    }
}

private extension PopupBottomStackView {
    func createPopupStack() -> some View {
        ForEach(items, id: \.self, content: createPopup)
    }
}

private extension PopupBottomStackView {
    func createPopup(_ item: AnyPopup<BottomPopupConfig>) -> some View {
        item.body
            .padding(.bottom, getContentBottomPadding())
            .padding(.leading, screen.safeArea.left)
            .padding(.trailing, screen.safeArea.right)
            .fixedSize(horizontal: false, vertical: getFixedSize(item))
            .readHeight { saveHeight($0, withAnimation: transitionEntryAnimation, for: item) }
            .frame(height: height, alignment: .top).frame(maxWidth: .infinity)
            .background(getBackgroundColour(for: item), overlayColour: getStackOverlayColour(item), radius: getCornerRadius(item), corners: getCorners())
            .padding(.horizontal, popupHorizontalPadding)
            .offset(y: getOffset(item))
            .scaleEffect(getScale(item), anchor: .top)
            .opacity(getOpacity(item))
            .compositingGroup()
            .focusSectionIfAvailable()
            .align(to: .bottom, lastPopupConfig.contentFillsEntireScreen ? nil : popupBottomPadding)
            .transition(transition)
            .zIndex(getZIndex(item))
    }
}

// MARK: - Gesture
private extension PopupBottomStackView {
    func onPopupDragGestureChanged(_ value: CGFloat) {
        if lastPopupConfig.dragGestureEnabled ?? globalConfig.bottom.dragGestureEnabled { gestureTranslation = max(0, value) }
    }
    func onPopupDragGestureEnded(_ value: CGFloat) {
        if translationProgress >= gestureClosingThresholdFactor { items.last?.dismiss() }
        gestureTranslation = 0
    }
}

// MARK: - Action Modifiers
private extension PopupBottomStackView {
    func onScreenChange(_ value: Any) { if let lastItem = items.last { saveHeight(heights[lastItem] ?? .infinity, withAnimation: nil, for: lastItem) }}
}

// MARK: - View Modifiers
private extension PopupBottomStackView {
    func getCorners() -> RectCorner {
        switch popupBottomPadding {
            case 0: return [.topLeft, .topRight]
            default: return .allCorners
        }
    }
    func saveHeight(_ height: CGFloat, withAnimation animation: Animation?, for item: AnyPopup<BottomPopupConfig>) { withAnimation(animation) {
        let config = item.configurePopup(popup: .init())

        if config.contentFillsEntireScreen { return heights[item] = screen.size.height }
        if config.contentFillsWholeHeight { return heights[item] = getMaxHeight() }
        return heights[item] = min(height, getMaxHeight() - popupBottomPadding)
    }}
    func getMaxHeight() -> CGFloat {
        let basicHeight = screen.size.height - screen.safeArea.top
        let stackedViewsCount = min(max(0, globalConfig.bottom.stackLimit - 1), items.count - 1)
        let stackedViewsHeight = globalConfig.bottom.stackOffset * .init(stackedViewsCount) * maxHeightStackedFactor
        return basicHeight - stackedViewsHeight
    }
    func getContentBottomPadding() -> CGFloat {
        if isKeyboardVisible { return keyboardManager.height + distanceFromKeyboard }
        if lastPopupConfig.contentIgnoresSafeArea { return 0 }

        return max(screen.safeArea.bottom - popupBottomPadding, 0)
    }
    func getFixedSize(_ item: AnyPopup<BottomPopupConfig>) -> Bool { !(getConfig(item).contentFillsEntireScreen || getConfig(item).contentFillsWholeHeight) }
    func getBackgroundColour(for item: AnyPopup<BottomPopupConfig>) -> Color { item.configurePopup(popup: .init()).backgroundColour ?? globalConfig.bottom.backgroundColour }
}

// MARK: - Flags & Values
extension PopupBottomStackView {
    var popupBottomPadding: CGFloat { lastPopupConfig.popupPadding.bottom }
    var popupHorizontalPadding: CGFloat { lastPopupConfig.popupPadding.horizontal }
    var height: CGFloat { heights.first { $0.key == items.last }?.value ?? (lastPopupConfig.contentFillsEntireScreen ? screen.size.height : getInitialHeight()) }
    var distanceFromKeyboard: CGFloat { lastPopupConfig.distanceFromKeyboard ?? globalConfig.bottom.distanceFromKeyboard }
    var cornerRadius: CGFloat { let cornerRadius = lastPopupConfig.cornerRadius ?? globalConfig.bottom.cornerRadius; return lastPopupConfig.contentFillsEntireScreen ? min(cornerRadius, screen.cornerRadius ?? 0) : cornerRadius }
    var maxHeightStackedFactor: CGFloat { 0.85 }
    var isKeyboardVisible: Bool { keyboardManager.height > 0 }

    var stackLimit: Int { globalConfig.bottom.stackLimit }
    var stackScaleFactor: CGFloat { globalConfig.bottom.stackScaleFactor }
    var stackOffsetValue: CGFloat { -globalConfig.bottom.stackOffset }
    var stackCornerRadiusMultiplier: CGFloat { globalConfig.bottom.stackCornerRadiusMultiplier }

    var translationProgress: CGFloat { abs(gestureTranslation) / height }
    var gestureClosingThresholdFactor: CGFloat { globalConfig.bottom.dragGestureProgressToClose }
    var transition: AnyTransition { .move(edge: .bottom) }

    var tapOutsideClosesPopup: Bool { lastPopupConfig.tapOutsideClosesView ?? globalConfig.bottom.tapOutsideClosesView }
}
