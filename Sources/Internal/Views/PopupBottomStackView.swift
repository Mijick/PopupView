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
    @State var heights: [ID: CGFloat] = [:]
    @State var dragHeights: [ID: CGFloat] = [:]
    @GestureState var isGestureActive: Bool = false
    @ObservedObject private var screenManager: ScreenManager = .shared
    @ObservedObject private var keyboardManager: KeyboardManager = .shared

    
    var body: some View {
        ZStack(alignment: .top, content: createPopupStack)
            .background(createTapArea())
            .animation(getHeightAnimation(isAnimationDisabled: screenManager.animationsDisabled), value: heights)
            .animation(isGestureActive ? dragGestureAnimation : transitionRemovalAnimation, value: gestureTranslation)
            .animation(.keyboard, value: isKeyboardVisible)
            .onDragGesture($isGestureActive, onChanged: onPopupDragGestureChanged, onEnded: onPopupDragGestureEnded)
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
            .padding(.top, getContentTopPadding())
            .padding(.bottom, getContentBottomPadding())
            .padding(.leading, screenManager.safeArea.left)
            .padding(.trailing, screenManager.safeArea.right)
            .fixedSize(horizontal: false, vertical: getFixedSize(item))
            .readHeight { saveHeight($0, for: item) }
            .frame(height: getHeight(item), alignment: .top).frame(maxWidth: .infinity, maxHeight: height)
            .background(getBackgroundColour(for: item), overlayColour: getStackOverlayColour(item), radius: getCornerRadius(item), corners: getCorners(), shadow: popupShadow)
            .padding(.horizontal, popupHorizontalPadding)
            .offset(y: getOffset(item))
            .scaleEffect(x: getScale(item))
            .opacity(getOpacity(item))
            .compositingGroup()
            .focusSectionIfAvailable()
            .align(to: .bottom, lastPopupConfig.contentFillsEntireScreen ? 0 : popupBottomPadding)
            .transition(transition)
            .zIndex(getZIndex(item))
    }
}

// MARK: - Gestures

// MARK: On Changed
private extension PopupBottomStackView {
    func onPopupDragGestureChanged(_ value: CGFloat) { if canDragGestureBeUsed() {
        updateGestureTranslation(value)
    }}
}
private extension PopupBottomStackView {
    func canDragGestureBeUsed() -> Bool { lastPopupConfig.dragGestureEnabled ?? globalConfig.bottom.dragGestureEnabled }
    func updateGestureTranslation(_ value: CGFloat) {





        let aaa = dragHeights[items.last?.id ?? .init()] ?? 0




        if !lastPopupConfig.dragDetents.isEmpty {
            gestureTranslation = value
        } else {
            gestureTranslation = max(0, value - aaa)
        }






    }
}

// MARK: On Ended
private extension PopupBottomStackView {
    func onPopupDragGestureEnded(_ value: CGFloat) { guard value != 0 else { return }

        


        // PROBLEMY:
        // 1. SKACZE COŚ
        // 2. MAKSYMALNY HEIGHT
        // 3. Sprawdzić działanie ze stacked popups
        // 4. Sprawdzić działanie gdy popup ma bottom padding
        // 5. Sprawdzić działanie gdy klawiatura jest widoczna
        // 6. Zamykanie popupu
        // 7. Zablokować drag gesture poza krawędzie ekranu
        // 8. Poprawić top padding przy fullscreen stacked false i ignore safe area false





        



        updateDragHeights()
        //dismissLastItemIfNeeded()
        resetGestureTranslationOnEnd()
    }
}
private extension PopupBottomStackView {
    func updateDragHeights() { if let lastPopupHeight = getLastPopupHeight() {
        let currentPopupHeight = calculateCurrentPopupHeight(lastPopupHeight)
        let popupTargetHeights = calculatePopupTargetHeightsFromDragDetents(lastPopupHeight)
        let targetHeight = calculateTargetPopupHeight(currentPopupHeight, popupTargetHeights)
        let targetDragHeight = calculateTargetDragHeight(targetHeight, lastPopupHeight)

        updateDragHeight(targetDragHeight)
    }}
    func dismissLastItemIfNeeded() { if translationProgress >= gestureClosingThresholdFactor {
        items.last?.remove()
    }}
    func resetGestureTranslationOnEnd() {
        let resetAfter = items.count == 1 && translationProgress >= gestureClosingThresholdFactor ? 0.25 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + resetAfter) { gestureTranslation = 0 }
    }
}
private extension PopupBottomStackView {
    func calculatePopupTargetHeightsFromDragDetents(_ lastPopupHeight: CGFloat) -> [CGFloat] { lastPopupConfig.dragDetents
        .map { switch $0 {
            case .fixed(let targetHeight): min(targetHeight, getMaxHeight())
            case .fraction(let fraction): min(fraction * lastPopupHeight, getMaxHeight())
            case .fullscreen(let stackVisible): stackVisible ? getMaxHeight() : screenManager.size.height + screenManager.safeArea.top
        }}
        .appending(lastPopupHeight)
        .sorted(by: <)
    }
    func calculateCurrentPopupHeight(_ lastPopupHeight: CGFloat) -> CGFloat {
        let lastDragHeight = dragHeights[items.last?.id ?? .init()] ?? 0
        let currentDragHeight = lastDragHeight - gestureTranslation

        let currentPopupHeight = lastPopupHeight + currentDragHeight
        return currentPopupHeight
    }
    func calculateTargetPopupHeight(_ currentPopupHeight: CGFloat, _ popupTargetHeights: [CGFloat]) -> CGFloat {
        let index = popupTargetHeights.firstIndex(where: { $0 >= currentPopupHeight }) ?? 0
        let popupTargetHeightIndex = gestureTranslation < 0 ? index : max(0, index - 1)
        return popupTargetHeights[popupTargetHeightIndex]
    }
    func calculateTargetDragHeight(_ targetHeight: CGFloat, _ lastPopupHeight: CGFloat) -> CGFloat {
        targetHeight - lastPopupHeight
    }
    func updateDragHeight(_ targetDragHeight: CGFloat) { if let id = items.last?.id {
        dragHeights[id] = targetDragHeight
    }}





    // should close popup
}
private extension PopupBottomStackView {

}

// MARK: - View Modifiers
private extension PopupBottomStackView {
    func getCorners() -> RectCorner {
        switch popupBottomPadding {
            case 0: return [.topLeft, .topRight]
            default: return .allCorners
        }
    }
    func saveHeight(_ height: CGFloat, for item: AnyPopup<BottomPopupConfig>) { if !isGestureActive {
        let config = item.configurePopup(popup: .init())

        if config.contentFillsEntireScreen { return heights[item.id] = screenManager.size.height + screenManager.safeArea.top }
        if config.contentFillsWholeHeight { return heights[item.id] = getMaxHeight() }
        return heights[item.id] = min(height, maxHeight)
    }}
    func getMaxHeight() -> CGFloat {
        let basicHeight = screenManager.size.height - screenManager.safeArea.top
        let stackedViewsCount = min(max(0, globalConfig.bottom.stackLimit - 1), items.count - 1)
        let stackedViewsHeight = globalConfig.bottom.stackOffset * .init(stackedViewsCount) * maxHeightStackedFactor
        return basicHeight - stackedViewsHeight
    }
    func getContentBottomPadding() -> CGFloat {
        if isKeyboardVisible { return keyboardManager.height + distanceFromKeyboard }
        if lastPopupConfig.contentIgnoresSafeArea { return 0 }

        return max(screenManager.safeArea.bottom - popupBottomPadding, 0)
    }
    func getContentTopPadding() -> CGFloat { lastPopupConfig.contentFillsEntireScreen && !lastPopupConfig.contentIgnoresSafeArea ? screenManager.safeArea.top : 0 }
    func getHeight(_ item: AnyPopup<BottomPopupConfig>) -> CGFloat? { getConfig(item).contentFillsEntireScreen ? nil : height }
    func getFixedSize(_ item: AnyPopup<BottomPopupConfig>) -> Bool { !(getConfig(item).contentFillsEntireScreen || getConfig(item).contentFillsWholeHeight || height == maxHeight) }
    func getBackgroundColour(for item: AnyPopup<BottomPopupConfig>) -> Color { item.configurePopup(popup: .init()).backgroundColour ?? globalConfig.bottom.backgroundColour }
}

// MARK: - Flags & Values
extension PopupBottomStackView {
    var popupBottomPadding: CGFloat { lastPopupConfig.popupPadding.bottom }
    var popupHorizontalPadding: CGFloat { lastPopupConfig.popupPadding.horizontal }
    var popupShadow: Shadow { globalConfig.bottom.shadow }
    var height: CGFloat {


        let h1 = heights.first { $0.key == items.last?.id }?.value ?? (lastPopupConfig.contentFillsEntireScreen ? screenManager.size.height : getInitialHeight())


        if gestureTranslation < 0 {
            let h2 = h1 + abs(gestureTranslation) + (dragHeights[items.last!.id] ?? 0)
            return h2
        }




        return h1 + (dragHeights[items.last!.id] ?? 0)





    }
    var maxHeight: CGFloat { getMaxHeight() - popupBottomPadding }
    var distanceFromKeyboard: CGFloat { lastPopupConfig.distanceFromKeyboard ?? globalConfig.bottom.distanceFromKeyboard }
    var cornerRadius: CGFloat { let cornerRadius = lastPopupConfig.cornerRadius ?? globalConfig.bottom.cornerRadius; return lastPopupConfig.contentFillsEntireScreen ? min(cornerRadius, screenManager.cornerRadius ?? 0) : cornerRadius }
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
