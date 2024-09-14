//
//  PopupBottomStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupBottomStackView: PopupStack { typealias Config = BottomPopupConfig
    @Binding var items: [AnyPopup]
    let globalConfig: GlobalConfig
    @State var gestureTranslation: CGFloat = 0
    @GestureState var isGestureActive: Bool = false
    @ObservedObject private var screenManager: ScreenManager = .shared
    @ObservedObject private var keyboardManager: KeyboardManager = .shared

    
    var body: some View {
        ZStack(alignment: .top, content: createPopupStack)
            .background(createTapArea())
            .animation(getHeightAnimation(isAnimationDisabled: screenManager.animationsDisabled), value: items.map(\.height))
            .animation(isGestureActive ? .drag : .transition, value: gestureTranslation)
            .animation(.keyboard, value: isKeyboardVisible)
            .onDragGesture($isGestureActive, onChanged: onPopupDragGestureChanged, onEnded: onPopupDragGestureEnded)
    }
}

private extension PopupBottomStackView {
    func createPopupStack() -> some View {
        ForEach($items, id: \.self, content: createPopup)
    }
}

private extension PopupBottomStackView {
    func createPopup(_ item: Binding<AnyPopup>) -> some View {
        item.wrappedValue.body
            .padding(.top, getContentTopPadding())
            .padding(.bottom, getContentBottomPadding())
            .padding(.leading, screenManager.safeArea.left)
            .padding(.trailing, screenManager.safeArea.right)
            .fixedSize(horizontal: false, vertical: getFixedSize(item.wrappedValue))
            .onHeightChange { saveHeight($0, for: item) }
            .frame(height: getHeight(item.wrappedValue), alignment: .top).frame(maxWidth: .infinity, maxHeight: height)
            .background(getBackgroundColour(for: item.wrappedValue), overlayColour: getStackOverlayColour(item.wrappedValue), radius: getCornerRadius(item.wrappedValue), corners: getCorners(), shadow: popupShadow)
            .padding(.horizontal, popupHorizontalPadding)
            .offset(y: getOffset(item.wrappedValue))
            .scaleEffect(x: getScale(item.wrappedValue))
            .opacity(getOpacity(item.wrappedValue))
            .compositingGroup()
            .focusSectionIfAvailable()
            .align(to: .bottom, lastPopupConfig.contentFillsEntireScreen ? 0 : popupBottomPadding)
            .transition(transition)
            .zIndex(getZIndex(item.wrappedValue))
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
    func updateGestureTranslation(_ value: CGFloat) { switch lastPopupConfig.dragDetents.isEmpty {
        case true: gestureTranslation = calculateGestureTranslationWhenNoDragDetents(value)
        case false: gestureTranslation = calculateGestureTranslationWhenDragDetents(value)
    }}
}
private extension PopupBottomStackView {
    func calculateGestureTranslationWhenNoDragDetents(_ value: CGFloat) -> CGFloat { max(value, 0) }
    func calculateGestureTranslationWhenDragDetents(_ value: CGFloat) -> CGFloat { guard value < 0, let lastPopupHeight = getLastPopupHeight() else { return value }
        let maxHeight = calculateMaxHeightForDragGesture(lastPopupHeight)
        let dragTranslation = calculateDragTranslation(maxHeight, lastPopupHeight)
        return max(dragTranslation, value)
    }
}
private extension PopupBottomStackView {
    func calculateMaxHeightForDragGesture(_ lastPopupHeight: CGFloat) -> CGFloat {
        let maxHeight1 = (calculatePopupTargetHeightsFromDragDetents(lastPopupHeight).max() ?? 0) + dragTranslationThreshold
        let maxHeight2 = screenManager.size.height
        return min(maxHeight1, maxHeight2)
    }
    func calculateDragTranslation(_ maxHeight: CGFloat, _ lastPopupHeight: CGFloat) -> CGFloat {
        let translation = maxHeight - lastPopupHeight - getLastDragHeight()
        return -translation
    }
}
private extension PopupBottomStackView {
    var dragTranslationThreshold: CGFloat { 8 }
}

// MARK: On Ended
private extension PopupBottomStackView {
    func onPopupDragGestureEnded(_ value: CGFloat) { guard value != 0 else { return }
        dismissLastItemIfNeeded()
        updateTranslationValues()
    }
}
private extension PopupBottomStackView {
    func dismissLastItemIfNeeded() { if shouldDismissPopup() {
        PopupManager.dismissPopup(id: items.last?.id.value ?? "")
    }}
    func updateTranslationValues() { if let lastPopupHeight = getLastPopupHeight() {
        let currentPopupHeight = calculateCurrentPopupHeight(lastPopupHeight)
        let popupTargetHeights = calculatePopupTargetHeightsFromDragDetents(lastPopupHeight)
        let targetHeight = calculateTargetPopupHeight(currentPopupHeight, popupTargetHeights)
        let targetDragHeight = calculateTargetDragHeight(targetHeight, lastPopupHeight)

        resetGestureTranslation()
        updateDragHeight(targetDragHeight)
    }}
}
private extension PopupBottomStackView {
    func calculateCurrentPopupHeight(_ lastPopupHeight: CGFloat) -> CGFloat {
        let lastDragHeight = getLastDragHeight()
        let currentDragHeight = lastDragHeight - gestureTranslation

        let currentPopupHeight = lastPopupHeight + currentDragHeight
        return currentPopupHeight
    }
    func calculatePopupTargetHeightsFromDragDetents(_ lastPopupHeight: CGFloat) -> [CGFloat] { lastPopupConfig.dragDetents
        .map { switch $0 {
            case .fixed(let targetHeight): min(targetHeight, getMaxHeight())
            case .fraction(let fraction): min(fraction * lastPopupHeight, getMaxHeight())
            case .fullscreen(let stackVisible): stackVisible ? getMaxHeight() : screenManager.size.height
        }}
        .appending(lastPopupHeight)
        .sorted(by: <)
    }
    func calculateTargetPopupHeight(_ currentPopupHeight: CGFloat, _ popupTargetHeights: [CGFloat]) -> CGFloat {
        guard let lastPopupHeight = getLastPopupHeight(),
              currentPopupHeight < screenManager.size.height
        else { return popupTargetHeights.last ?? 0 }

        let initialIndex = popupTargetHeights.firstIndex(where: { $0 >= currentPopupHeight }) ?? popupTargetHeights.count - 1,
            targetIndex = gestureTranslation <= 0 ? initialIndex : max(0, initialIndex - 1)
        let previousPopupHeight = getLastDragHeight() + lastPopupHeight,
            popupTargetHeight = popupTargetHeights[targetIndex],
            deltaHeight = abs(previousPopupHeight - popupTargetHeight)
        let progress = abs(currentPopupHeight - previousPopupHeight) / deltaHeight

        if progress < gestureClosingThresholdFactor {
            let index = gestureTranslation <= 0 ? max(0, initialIndex - 1) : initialIndex
            return popupTargetHeights[index]
        }
        return popupTargetHeights[targetIndex]
    }
    func calculateTargetDragHeight(_ targetHeight: CGFloat, _ lastPopupHeight: CGFloat) -> CGFloat {
        targetHeight - lastPopupHeight
    }
    func updateDragHeight(_ targetDragHeight: CGFloat) { Task { @MainActor in
        items.lastElement?.dragHeight = targetDragHeight
    }}
    func resetGestureTranslation() { Task { @MainActor in
        gestureTranslation = 0
    }}
    func shouldDismissPopup() -> Bool {
        translationProgress >= gestureClosingThresholdFactor
    }
}

// MARK: - View Modifiers
private extension PopupBottomStackView {
    func getCorners() -> RectCorner { switch popupBottomPadding {
        case 0: return [.topLeft, .topRight]
        default: return .allCorners
    }}
    func saveHeight(_ height: CGFloat, for item: Binding<AnyPopup>) { if !isGestureActive {
        let config = getConfig(item.wrappedValue)
        let newHeight = calculateHeight(height, config)

        updateHeight(newHeight, item)
    }}
    func getMaxHeight() -> CGFloat {
        let basicHeight = screenManager.size.height - screenManager.safeArea.top - popupBottomPadding
        let stackedViewsCount = min(max(0, globalConfig.bottom.stackLimit - 1), items.count - 1)
        let stackedViewsHeight = globalConfig.bottom.stackOffset * .init(stackedViewsCount) * maxHeightStackedFactor
        return basicHeight - stackedViewsHeight
    }
    func getContentBottomPadding() -> CGFloat {
        if isKeyboardVisible { return keyboardManager.height + distanceFromKeyboard }
        if lastPopupConfig.contentIgnoresSafeArea { return 0 }

        return max(screenManager.safeArea.bottom - popupBottomPadding, 0)
    }
    func getContentTopPadding() -> CGFloat {
        if lastPopupConfig.contentIgnoresSafeArea { return 0 }

        let heightWithoutTopSafeArea = screenManager.size.height - screenManager.safeArea.top
        let topPadding = height - heightWithoutTopSafeArea
        return max(topPadding, 0)
    }
    func getHeight(_ item: AnyPopup) -> CGFloat? { getConfig(item).contentFillsEntireScreen ? nil : height }
    func getFixedSize(_ item: AnyPopup) -> Bool { !(getConfig(item).contentFillsEntireScreen || getConfig(item).contentFillsWholeHeight || height == maxHeight) }
    func getBackgroundColour(for item: AnyPopup) -> Color { getConfig(item).backgroundColour ?? globalConfig.bottom.backgroundColour }
}
private extension PopupBottomStackView {
    func calculateHeight(_ height: CGFloat, _ config: BottomPopupConfig) -> CGFloat {
        if config.contentFillsEntireScreen { return screenManager.size.height }
        if config.contentFillsWholeHeight { return getMaxHeight() }
        return min(height, maxHeight)
    }
    func updateHeight(_ newHeight: CGFloat, _ item: Binding<AnyPopup>) { if item.wrappedValue.height != newHeight { Task { @MainActor in
        item.wrappedValue.height = newHeight
    }}}
}

// MARK: - Flags & Values
extension PopupBottomStackView {
    var popupBottomPadding: CGFloat { lastPopupConfig.popupPadding.vertical }
    var popupHorizontalPadding: CGFloat { lastPopupConfig.popupPadding.horizontal }
    var popupShadow: Shadow { globalConfig.bottom.shadow }
    var height: CGFloat {
        let lastDragHeight = getLastDragHeight(),
            lastPopupHeight = getLastPopupHeight() ?? (lastPopupConfig.contentFillsEntireScreen ? screenManager.size.height : getInitialHeight())
        let dragTranslation = lastPopupHeight + lastDragHeight - gestureTranslation
        let newHeight = max(lastPopupHeight, dragTranslation)

        switch lastPopupHeight + lastDragHeight > screenManager.size.height && !lastPopupConfig.contentIgnoresSafeArea {
            case true: return newHeight == screenManager.size.height ? newHeight : newHeight - screenManager.safeArea.top
            case false: return newHeight
        }
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

    var translationProgress: CGFloat { guard let popupHeight = getLastPopupHeight() else { return 0 }; return max(gestureTranslation - getLastDragHeight(), 0) / popupHeight }
    var gestureClosingThresholdFactor: CGFloat { globalConfig.bottom.dragGestureProgressToClose }
    var transition: AnyTransition { .move(edge: .bottom) }

    var tapOutsideClosesPopup: Bool { lastPopupConfig.tapOutsideClosesView ?? globalConfig.bottom.tapOutsideClosesView }
}




struct PopupH: PopupStack { typealias Config = BottomPopupConfig
    @Binding var items: [AnyPopup]
    let globalConfig: GlobalConfig
    let edge: Edge
    @State var gestureTranslation: CGFloat = 0
    @GestureState var isGestureActive: Bool = false
    @ObservedObject private var screenManager: ScreenManager = .shared
    @ObservedObject private var keyboardManager: KeyboardManager = .shared


    var body: some View {
        ZStack(alignment: getStackAlignment(), content: createPopupStack)
            .background(createTapArea())
            .animation(getHeightAnimation(isAnimationDisabled: screenManager.animationsDisabled), value: items.map(\.height))
            .animation(isGestureActive ? .drag : .transition, value: gestureTranslation)
            .animation(.keyboard, value: isKeyboardVisible)
            .onDragGesture($isGestureActive, onChanged: onPopupDragGestureChanged, onEnded: onPopupDragGestureEnded)
    }
}
private extension PopupH {
    func createPopupStack() -> some View {
        ForEach($items, id: \.self, content: createPopup)
    }
}
private extension PopupH {
    func createPopup(_ item: Binding<AnyPopup>) -> some View {
        item.wrappedValue.body
            .padding(.top, getContentTopPadding())
            .padding(.bottom, getContentBottomPadding())
            .padding(.leading, screenManager.safeArea.left)
            .padding(.trailing, screenManager.safeArea.right)
            .fixedSize(horizontal: false, vertical: getFixedSize(item.wrappedValue))
            .onHeightChange { saveHeight($0, for: item) }
            .frame(height: getHeight(item.wrappedValue), alignment: getStackAlignment()).frame(maxWidth: .infinity, maxHeight: height)
            .background(getBackgroundColour(for: item.wrappedValue), overlayColour: getStackOverlayColour(item.wrappedValue), radius: getCornerRadius(item.wrappedValue), corners: getCorners(), shadow: popupShadow)
            .padding(.horizontal, popupHorizontalPadding)
            .offset(y: getOffset(item.wrappedValue))
            .scaleEffect(x: getScale(item.wrappedValue))
            .opacity(getOpacity(item.wrappedValue))
            .compositingGroup()
            .focusSectionIfAvailable()
            .align(to: getPopupAlignment(), lastPopupConfig.contentFillsEntireScreen ? 0 : popupVerticalPadding)
            .transition(getTransition())
            .zIndex(getZIndex(item.wrappedValue))
    }
}


// MARK: - Gestures

// MARK: On Changed
private extension PopupH {
    func onPopupDragGestureChanged(_ value: CGFloat) { if canDragGestureBeUsed() {
        updateGestureTranslation(value)
    }}
}
private extension PopupH {
    func canDragGestureBeUsed() -> Bool { lastPopupConfig.dragGestureEnabled ?? getGlobalConfig().dragGestureEnabled }
    func updateGestureTranslation(_ value: CGFloat) { switch lastPopupConfig.dragDetents.isEmpty {
        case true: gestureTranslation = calculateGestureTranslationWhenNoDragDetents(value)
        case false: gestureTranslation = calculateGestureTranslationWhenDragDetents(value)
    }}
}
private extension PopupH {
    func calculateGestureTranslationWhenNoDragDetents(_ value: CGFloat) -> CGFloat { getDragExtremeValue(value, 0) }
    func calculateGestureTranslationWhenDragDetents(_ value: CGFloat) -> CGFloat { guard value * getDragTranslationMultiplier() > 0, let lastPopupHeight = getLastPopupHeight() else { return value }
        let maxHeight = calculateMaxHeightForDragGesture(lastPopupHeight)
        let dragTranslation = calculateDragTranslation(maxHeight, lastPopupHeight)
        return getDragExtremeValue(dragTranslation, value)
    }
}
private extension PopupH {
    func calculateMaxHeightForDragGesture(_ lastPopupHeight: CGFloat) -> CGFloat {
        let maxHeight1 = (calculatePopupTargetHeightsFromDragDetents(lastPopupHeight).max() ?? 0) + dragTranslationThreshold
        let maxHeight2 = screenManager.size.height
        return min(maxHeight1, maxHeight2)
    }
    func calculateDragTranslation(_ maxHeight: CGFloat, _ lastPopupHeight: CGFloat) -> CGFloat {
        let translation = maxHeight - lastPopupHeight - getLastDragHeight()
        return translation * getDragTranslationMultiplier()
    }
}
private extension PopupH {
    var dragTranslationThreshold: CGFloat { 8 }
}

// MARK: On Ended
private extension PopupBottomStackView {
    func onPopupDragGestureEnded(_ value: CGFloat) { guard value != 0 else { return }
        dismissLastItemIfNeeded()
        updateTranslationValues()
    }
}
private extension PopupBottomStackView {
    func dismissLastItemIfNeeded() { if shouldDismissPopup() {
        PopupManager.dismissPopup(id: items.last?.id.value ?? "")
    }}
    func updateTranslationValues() { if let lastPopupHeight = getLastPopupHeight() {
        let currentPopupHeight = calculateCurrentPopupHeight(lastPopupHeight)
        let popupTargetHeights = calculatePopupTargetHeightsFromDragDetents(lastPopupHeight)
        let targetHeight = calculateTargetPopupHeight(currentPopupHeight, popupTargetHeights)
        let targetDragHeight = calculateTargetDragHeight(targetHeight, lastPopupHeight)

        resetGestureTranslation()
        updateDragHeight(targetDragHeight)
    }}
}



// OD TEGO ZACZĄĆ
private extension PopupBottomStackView {
    func calculateCurrentPopupHeight(_ lastPopupHeight: CGFloat) -> CGFloat {
        let lastDragHeight = getLastDragHeight()
        let currentDragHeight = lastDragHeight - gestureTranslation

        let currentPopupHeight = lastPopupHeight + currentDragHeight
        return currentPopupHeight
    }
    func calculatePopupTargetHeightsFromDragDetents(_ lastPopupHeight: CGFloat) -> [CGFloat] { lastPopupConfig.dragDetents
            .map { switch $0 {
                case .fixed(let targetHeight): min(targetHeight, getMaxHeight())
                case .fraction(let fraction): min(fraction * lastPopupHeight, getMaxHeight())
                case .fullscreen(let stackVisible): stackVisible ? getMaxHeight() : screenManager.size.height
            }}
            .appending(lastPopupHeight)
            .sorted(by: <)
    }
    func calculateTargetPopupHeight(_ currentPopupHeight: CGFloat, _ popupTargetHeights: [CGFloat]) -> CGFloat {
        guard let lastPopupHeight = getLastPopupHeight(),
              currentPopupHeight < screenManager.size.height
        else { return popupTargetHeights.last ?? 0 }

        let initialIndex = popupTargetHeights.firstIndex(where: { $0 >= currentPopupHeight }) ?? popupTargetHeights.count - 1,
            targetIndex = gestureTranslation <= 0 ? initialIndex : max(0, initialIndex - 1)
        let previousPopupHeight = getLastDragHeight() + lastPopupHeight,
            popupTargetHeight = popupTargetHeights[targetIndex],
            deltaHeight = abs(previousPopupHeight - popupTargetHeight)
        let progress = abs(currentPopupHeight - previousPopupHeight) / deltaHeight

        if progress < gestureClosingThresholdFactor {
            let index = gestureTranslation <= 0 ? max(0, initialIndex - 1) : initialIndex
            return popupTargetHeights[index]
        }
        return popupTargetHeights[targetIndex]
    }
    func calculateTargetDragHeight(_ targetHeight: CGFloat, _ lastPopupHeight: CGFloat) -> CGFloat {
        targetHeight - lastPopupHeight
    }
    func updateDragHeight(_ targetDragHeight: CGFloat) { Task { @MainActor in
        items.lastElement?.dragHeight = targetDragHeight
    }}
    func resetGestureTranslation() { Task { @MainActor in
        gestureTranslation = 0
    }}
    func shouldDismissPopup() -> Bool {
        translationProgress >= gestureClosingThresholdFactor
    }
}






extension PopupH {
    func getMaxHeight() -> CGFloat {
        let basicHeight = screenManager.size.height - getKeySafeArea() - popupVerticalPadding
        let stackedViewsCount = min(max(0, getGlobalConfig().stackLimit - 1), items.count - 1)
        let stackedViewsHeight = getGlobalConfig().stackOffset * .init(stackedViewsCount) * maxHeightStackedFactor
        return basicHeight - stackedViewsHeight
    }
}



extension PopupH {
    var popupVerticalPadding: CGFloat { lastPopupConfig.popupPadding.vertical }
    var popupHorizontalPadding: CGFloat { lastPopupConfig.popupPadding.horizontal }
    var popupShadow: Shadow { getGlobalConfig().shadow }



    var maxHeight: CGFloat { getMaxHeight() - popupVerticalPadding }
    var distanceFromKeyboard: CGFloat { lastPopupConfig.distanceFromKeyboard ?? getGlobalConfig().distanceFromKeyboard }
    var maxHeightStackedFactor: CGFloat { 0.85 }
    var isKeyboardVisible: Bool { keyboardManager.height > 0 }



    var stackLimit: Int { getGlobalConfig().stackLimit }
    var stackScaleFactor: CGFloat { getGlobalConfig().stackScaleFactor }
    var stackOffsetValue: CGFloat { getGlobalConfig().stackOffset * getOffsetMultiplier() }
    var stackCornerRadiusMultiplier: CGFloat { getGlobalConfig().stackCornerRadiusMultiplier }




    var cornerRadius: CGFloat {
        let cornerRadius = lastPopupConfig.cornerRadius ?? getGlobalConfig().cornerRadius
        return lastPopupConfig.contentFillsEntireScreen ? min(cornerRadius, screenManager.cornerRadius ?? 0) : cornerRadius
    }

    var translationProgress: CGFloat { guard let popupHeight = getLastPopupHeight() else { return 0 }
        let translationProgress = calculateTranslationProgress(popupHeight)
        return translationProgress
    }
    var gestureClosingThresholdFactor: CGFloat { getGlobalConfig().dragGestureProgressToClose }


    var tapOutsideClosesPopup: Bool { lastPopupConfig.tapOutsideClosesView ?? getGlobalConfig().tapOutsideClosesView }
}








extension PopupH { enum Edge {
    case top
    case bottom
}}
private extension PopupH {
    func getDragExtremeValue(_ value1: CGFloat, _ value2: CGFloat) -> CGFloat { switch edge {
        case .top: min(value1, value2)
        case .bottom: max(value1, value2)
    }}
    func getDragTranslationMultiplier() -> CGFloat { switch edge {
        case .top: 1
        case .bottom: -1
    }}




    func getStackAlignment() -> Alignment { switch edge {
        case .top: .bottom
        case .bottom: .top
    }}
    func getPopupAlignment() -> Alignment { switch edge {
        case .top: .top
        case .bottom: .bottom
    }}
    func getKeySafeArea() -> CGFloat { switch edge {
        case .top: screenManager.safeArea.bottom
        case .bottom: screenManager.safeArea.top
    }}



    func getOffsetMultiplier() -> CGFloat { switch edge {
        case .top: 1
        case .bottom: -1
    }}


    func calculateTranslationProgress(_ popupHeight: CGFloat) -> CGFloat { switch edge {
        case .top: abs(min(gestureTranslation + getLastDragHeight(), 0)) / popupHeight
        case .bottom: max(gestureTranslation - getLastDragHeight(), 0) / popupHeight
    }}


    func getTransition() -> AnyTransition { switch edge {
        case .top: .move(edge: .top)
        case .bottom: .move(edge: .bottom)
    }}



    // TODO: POPRAWIĆ
    func getGlobalConfig() -> GlobalConfig.Bottom { switch edge {
        case .top: globalConfig.bottom
        case .bottom: globalConfig.bottom
    }}
}
