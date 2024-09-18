//
//  PopupStackView.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupStackView<Config: LocalConfig.Vertical>: View {
    @Binding var items: [AnyPopup]
    let itemsAlignment: VerticalEdge
    @State private var gestureTranslation: CGFloat = 0
    @GestureState private var isGestureActive: Bool = false
    @ObservedObject private var screenManager: ScreenManager = .shared
    @ObservedObject private var keyboardManager: KeyboardManager = .shared


    var body: some View {
        ZStack(alignment: getStackAlignment(), content: createPopupStack)
            .frame(height: screenManager.size.height, alignment: getVVV())
            .animation(getHeightAnimation(isAnimationDisabled: screenManager.animationsDisabled), value: items.map(\.height))
            .animation(isGestureActive ? nil : .transition, value: gestureTranslation)
            .animation(.keyboard, value: isKeyboardVisible)
            .onDragGesture($isGestureActive, onChanged: onPopupDragGestureChanged, onEnded: onPopupDragGestureEnded)
    }
}
private extension PopupStackView {
    func createPopupStack() -> some View {
        ForEach($items, id: \.self, content: createPopup)
    }
}
private extension PopupStackView {
    func createPopup(_ item: Binding<AnyPopup>) -> some View {
        let config = getConfig(item.wrappedValue),
            lastItemConfig = getConfig(items.last),
            height = calculateHeightForActivePopup(),
            translationProgress = translationProgress


        return item.wrappedValue.body
            .padding(calculateBodyPadding(activePopupHeight: height, popupConfig: config))
            .fixedSize(horizontal: false, vertical: calculateVerticalFixedSize(popupConfig: config, activePopupHeight: height))
            .onHeightChange { save(height: $0, for: item, popupConfig: config) }
            .frame(height: height, alignment: getStackAlignment())
            .frame(maxWidth: .infinity)
            .background(getBackgroundColour(for: item.wrappedValue), overlayColour: getStackOverlayColour(item.wrappedValue), corners: calculateCornerRadius(activePopupConfig: lastItemConfig), shadow: popupShadow)
            .padding(.horizontal, popupHorizontalPadding)
            .offset(y: calculateOffset(for: item.wrappedValue))
            .scaleEffect(x: calculateScale(for: item.wrappedValue, translationProgress: translationProgress))
            .focusSectionIfAvailable()
            .padding(getPopupAlignment(), lastItemConfig.heightMode == .fullscreen ? 0 : getPopupPadding())
            .transition(getTransition())
            .zIndex(getZIndex(item.wrappedValue))
            .compositingGroup()
    }
}

// MARK: - Calculating Height For Active Popup
private extension PopupStackView {
    func calculateHeightForActivePopup() -> CGFloat? {
        guard let activePopupHeight = items.last?.height else { return nil }

        let activePopupDragHeight = items.last?.dragHeight ?? 0
        let popupHeightFromGestureTranslation = activePopupHeight + activePopupDragHeight + gestureTranslation * getDragTranslationMultiplier()

        let newHeightCandidate1 = max(activePopupHeight, popupHeightFromGestureTranslation),
            newHeightCanditate2 = screenManager.size.height - keyboardManager.height
        return min(newHeightCandidate1, newHeightCanditate2)
    }
}

// MARK: - Calculating Paddings For Popup Body
private extension PopupStackView {
    func calculateBodyPadding(activePopupHeight: CGFloat?, popupConfig: Config) -> EdgeInsets { guard let activePopupHeight else { return .init() }; return .init(
        top: calculateTopBodyPadding(activePopupHeight: activePopupHeight, popupConfig: popupConfig),
        leading: calculateLeadingBodyPadding(),
        bottom: calculateBottomBodyPadding(activePopupHeight: activePopupHeight, popupConfig: popupConfig),
        trailing: calculateTrailingBodyPadding()
    )}
}
private extension PopupStackView {
    func calculateTopBodyPadding(activePopupHeight: CGFloat, popupConfig: Config) -> CGFloat {
        if popupConfig.ignoredSafeAreaEdges.contains(.top) { return 0 }

        return switch itemsAlignment {
            case .top: calculateVerticalPaddingAdhereEdge(safeAreaHeight: screenManager.safeArea.top, popupPadding: popupTopPadding)
            case .bottom: calculateVerticalPaddingCounterEdge(popupHeight: activePopupHeight, safeArea: screenManager.safeArea.top)
        }
    }
    func calculateBottomBodyPadding(activePopupHeight: CGFloat, popupConfig: Config) -> CGFloat {
        if isKeyboardVisible { return keyboardManager.height + distanceFromKeyboard }
        if popupConfig.ignoredSafeAreaEdges.contains(.bottom) { return 0 }

        return switch itemsAlignment {
            case .top: calculateVerticalPaddingCounterEdge(popupHeight: activePopupHeight, safeArea: screenManager.safeArea.bottom)
            case .bottom: calculateVerticalPaddingAdhereEdge(safeAreaHeight: screenManager.safeArea.bottom, popupPadding: popupBottomPadding)
        }
    }
    func calculateLeadingBodyPadding() -> CGFloat {
        screenManager.safeArea.leading
    }
    func calculateTrailingBodyPadding() -> CGFloat {
        screenManager.safeArea.trailing
    }
}
private extension PopupStackView {
    func calculateVerticalPaddingCounterEdge(popupHeight: CGFloat, safeArea: CGFloat) -> CGFloat {
        let paddingValueCandidate = safeArea + popupHeight - screenManager.size.height
        return max(paddingValueCandidate, 0)
    }
    func calculateVerticalPaddingAdhereEdge(safeAreaHeight: CGFloat, popupPadding: CGFloat) -> CGFloat {
        let paddingValueCandidate = safeAreaHeight - popupPadding
        return max(paddingValueCandidate, 0)
    }
}

// MARK: - Calculating Corner Radius
private extension PopupStackView {
    func calculateCornerRadius(activePopupConfig: Config) -> [VerticalEdge: CGFloat] {
        let cornerRadiusValue = calculateCornerRadiusValue(activePopupConfig)
        return [
            .top: calculateTopCornerRadius(cornerRadiusValue),
            .bottom: calculateBottomCornerRadius(cornerRadiusValue)
        ]
    }
}
private extension PopupStackView {
    func calculateCornerRadiusValue(_ activePopupConfig: Config) -> CGFloat { switch activePopupConfig.heightMode {
        case .auto, .large: activePopupConfig.cornerRadius
        case .fullscreen: 0
    }}
    func calculateTopCornerRadius(_ cornerRadiusValue: CGFloat) -> CGFloat { switch itemsAlignment {
        case .top: popupTopPadding != 0 ? cornerRadiusValue : 0
        case .bottom: cornerRadiusValue
    }}
    func calculateBottomCornerRadius(_ cornerRadiusValue: CGFloat) -> CGFloat { switch itemsAlignment {
        case .top: cornerRadiusValue
        case .bottom: popupBottomPadding != 0 ? cornerRadiusValue : 0
    }}
}

// MARK: - Saving Height For Item
private extension PopupStackView {
    func save(height: CGFloat, for popup: Binding<AnyPopup>, popupConfig: Config) { if !isGestureActive {
        let newHeight = calculateHeight(height, popupConfig)
        updateHeight(newHeight, popup)
    }}
}
private extension PopupStackView {
    func calculateHeight(_ height: CGFloat, _ popupConfig: Config) -> CGFloat { switch popupConfig.heightMode {
        case .auto: min(height, calculateLargeScreenHeight())
        case .large: calculateLargeScreenHeight()
        case .fullscreen: getFullscreenHeight()
    }}
    func updateHeight(_ newHeight: CGFloat, _ item: Binding<AnyPopup>) { if item.wrappedValue.height != newHeight { Task { @MainActor in
        item.wrappedValue.height = newHeight
    }}}
}
private extension PopupStackView {
    func calculateLargeScreenHeight() -> CGFloat {
        let fullscreenHeight = getFullscreenHeight(),
            safeAreaHeight = screenManager.safeArea[!itemsAlignment],
            popupPaddings = popupTopPadding + popupBottomPadding,
            stackHeight = calculateStackHeight()
        return fullscreenHeight - safeAreaHeight - popupPaddings - stackHeight
    }
    func getFullscreenHeight() -> CGFloat {
        screenManager.size.height
    }
}
private extension PopupStackView {
    func calculateStackHeight() -> CGFloat {
        let numberOfStackedItems = max(items.count - 1, 0)

        let stackedItemsHeight = stackOffset * .init(numberOfStackedItems)
        return stackedItemsHeight
    }
}

// MARK: - Calculating Offset
private extension PopupStackView {
    func calculateOffset(for popup: AnyPopup) -> CGFloat { switch popup == items.last {
        case true: calculateOffsetForActivePopup()
        case false: calculateOffsetForStackedPopup(popup)
    }}
}
private extension PopupStackView {
    func calculateOffsetForActivePopup() -> CGFloat {
        let lastPopupDragHeight = items.last?.dragHeight ?? 0

        return switch itemsAlignment {
            case .top: min(gestureTranslation + lastPopupDragHeight, 0)
            case .bottom: max(gestureTranslation - lastPopupDragHeight, 0)
        }
    }
    func calculateOffsetForStackedPopup(_ popup: AnyPopup) -> CGFloat {
        let invertedIndex = getInvertedIndex(of: popup)
        let offsetValue = stackOffset * .init(invertedIndex)
        let alignmentMultiplier = switch itemsAlignment {
            case .top: 1.0
            case .bottom: -1.0
        }

        return offsetValue * alignmentMultiplier
    }
}

// MARK: - Calculating Scale
private extension PopupStackView {
    func calculateScale(for popup: AnyPopup, translationProgress: CGFloat) -> CGFloat { guard popup != items.last else { return 1 }
        let invertedIndex = getInvertedIndex(of: popup),
            remainingTranslationProgress = 1 - translationProgress

        let progressMultiplier = invertedIndex == 1 ? remainingTranslationProgress : max(0.7, remainingTranslationProgress)
        let scaleValue = .init(invertedIndex) * stackScaleFactor * progressMultiplier
        return 1 - scaleValue
    }
}

// MARK: - Fixed Size
private extension PopupStackView {
    func calculateVerticalFixedSize(popupConfig: Config, activePopupHeight: CGFloat?) -> Bool { switch popupConfig.heightMode {
        case .fullscreen, .large: false
        case .auto: activePopupHeight != calculateLargeScreenHeight()
    }}
}




// MARK: - View Modifiers
private extension PopupStackView {
    func getBackgroundColour(for item: AnyPopup) -> Color { getConfig(item).backgroundColour }
}


extension PopupStackView {
    var popupTopPadding: CGFloat { getConfig(items.last).popupPadding.top }
    var popupBottomPadding: CGFloat { getConfig(items.last).popupPadding.bottom }
    var popupHorizontalPadding: CGFloat { getConfig(items.last).popupPadding.horizontal }
    var popupShadow: Shadow { getGlobalConfig().shadow }



    var distanceFromKeyboard: CGFloat { getConfig(items.last).distanceFromKeyboard }
    var isKeyboardVisible: Bool { keyboardManager.height > 0 }










    var translationProgress: CGFloat { guard let popupHeight = getLastPopupHeight() else { return 0 }
        let translationProgress = calculateTranslationProgress(popupHeight)
        return translationProgress
    }
    var gestureClosingThresholdFactor: CGFloat { getGlobalConfig().dragGestureProgressToClose }
}



// MARK: - Attributes
private extension PopupStackView {
    var stackOffset: CGFloat { getGlobalConfig().isStackingPossible ? 8 : 0 }
    var stackScaleFactor: CGFloat { 0.025 }
}





private extension PopupStackView {
    func getDragExtremeValue(_ value1: CGFloat, _ value2: CGFloat) -> CGFloat { switch itemsAlignment {
        case .top: min(value1, value2)
        case .bottom: max(value1, value2)
    }}
    func getDragTranslationMultiplier() -> CGFloat { switch itemsAlignment {
        case .top: 1
        case .bottom: -1
    }}






    func getStackAlignment() -> Alignment { switch itemsAlignment {
        case .top: .bottom
        case .bottom: .top
    }}
    func getVVV() -> Alignment { switch itemsAlignment {
        case .top: .top
        case .bottom: .bottom
    }}
    func getPopupAlignment() -> Edge.Set { switch itemsAlignment {
        case .top: .top
        case .bottom: .bottom
    }}
    func getPopupPadding() -> CGFloat { switch itemsAlignment {
        case .top: popupTopPadding
        case .bottom: popupBottomPadding
    }}






    func calculateTranslationProgress(_ popupHeight: CGFloat) -> CGFloat { switch itemsAlignment {
        case .top: abs(min(gestureTranslation + getLastDragHeight(), 0)) / popupHeight
        case .bottom: max(gestureTranslation - getLastDragHeight(), 0) / popupHeight
    }}
}



// MARK: - Helpers
private extension PopupStackView {
    func isNextToLast(_ item: AnyPopup) -> Bool { getInvertedIndex(of: item) == 1 }
    func getInvertedIndex(of item: AnyPopup) -> Int { items.count - 1 - index(item) }
    func index(_ item: AnyPopup) -> Int { items.firstIndex(of: item) ?? 0 }
}
private extension PopupStackView {
    var remainingTranslationProgress: CGFloat { 1 - translationProgress }
}




// MARK: - Stack Overlay Colour
extension PopupStackView {
    func getStackOverlayColour(_ item: AnyPopup) -> Color {
        let opacity = calculateStackOverlayOpacity(item)
        return stackOverlayColour.opacity(opacity)
    }
}
private extension PopupStackView {
    func calculateStackOverlayOpacity(_ item: AnyPopup) -> Double {
        let overlayValue = min(maxStackOverlayFactor, .init(getInvertedIndex(of: item)) * stackOverlayFactor)
        let remainingTranslationProgressValue = isNextToLast(item) ? remainingTranslationProgress : max(0.6, remainingTranslationProgress)
        let opacity = overlayValue * remainingTranslationProgressValue
        return max(0, opacity)
    }
}
private extension PopupStackView {
    var stackOverlayColour: Color { .black }
    var stackOverlayFactor: CGFloat { 0.1 }
    var maxStackOverlayFactor: CGFloat { 0.48 }
}



// MARK: - Item ZIndex
extension PopupStackView {
    func getZIndex(_ item: AnyPopup) -> Double { .init(items.firstIndex(of: item) ?? 2137) }
}





// MARK: - Config Related
extension PopupStackView {
    func getConfig(_ item: AnyPopup?) -> Config { item.getConfig() }
    func getGlobalConfig() -> GlobalConfig.Vertical { switch itemsAlignment {
        case .top: ConfigContainer.vertical
        case .bottom: ConfigContainer.vertical
    }}
}
extension AnyPopup? {
    func getConfig<Config: LocalConfig>() -> Config {
        (self?.config as? Config) ?? .init()
    }
}

// MARK: - Height Related
extension PopupStackView {
    func getInitialHeight() -> CGFloat { items.nextToLast?.height ?? 30 }
    func getLastDragHeight() -> CGFloat { items.last?.dragHeight ?? 0 }
    func getLastPopupHeight() -> CGFloat? {
        let height = items.last?.height
        return height == 0 ? getInitialHeight() : height
    }

}

// MARK: - Animation Related
extension PopupStackView {
    func getHeightAnimation(isAnimationDisabled: Bool) -> Animation? { !isAnimationDisabled ? .transition : nil }
    func getTransition() -> AnyTransition { switch itemsAlignment {
        case .top: .move(edge: .top)
        case .bottom: .move(edge: .bottom)
    }}
}




















// MARK: - Gestures

// MARK: On Changed
private extension PopupStackView {
    func onPopupDragGestureChanged(_ value: CGFloat) { if canDragGestureBeUsed() {
        updateGestureTranslation(value)
    }}
}
private extension PopupStackView {
    func canDragGestureBeUsed() -> Bool { getConfig(items.last).dragGestureEnabled }
    func updateGestureTranslation(_ value: CGFloat) { switch getConfig(items.last).dragDetents.isEmpty {
        case true: gestureTranslation = calculateGestureTranslationWhenNoDragDetents(value)
        case false: gestureTranslation = calculateGestureTranslationWhenDragDetents(value)
    }}
}
private extension PopupStackView {
    func calculateGestureTranslationWhenNoDragDetents(_ value: CGFloat) -> CGFloat { getDragExtremeValue(value, 0) }
    func calculateGestureTranslationWhenDragDetents(_ value: CGFloat) -> CGFloat { guard value * getDragTranslationMultiplier() > 0, let lastPopupHeight = getLastPopupHeight() else { return value }
        let maxHeight = calculateMaxHeightForDragGesture(lastPopupHeight)
        let dragTranslation = calculateDragTranslation(maxHeight, lastPopupHeight)
        return getDragExtremeValue(dragTranslation, value)
    }
}
private extension PopupStackView {
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
private extension PopupStackView {
    var dragTranslationThreshold: CGFloat { 8 }
}

// MARK: On Ended
private extension PopupStackView {
    func onPopupDragGestureEnded(_ value: CGFloat) { guard value != 0 else { return }
        dismissLastItemIfNeeded()
        updateTranslationValues()
    }
}
private extension PopupStackView {
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
private extension PopupStackView {
    func calculateCurrentPopupHeight(_ lastPopupHeight: CGFloat) -> CGFloat {
        let lastDragHeight = getLastDragHeight()
        let currentDragHeight = lastDragHeight + gestureTranslation * getDragTranslationMultiplier()

        let currentPopupHeight = lastPopupHeight + currentDragHeight
        return currentPopupHeight
    }
    func calculatePopupTargetHeightsFromDragDetents(_ lastPopupHeight: CGFloat) -> [CGFloat] { getConfig(items.last).dragDetents
            .map { switch $0 {
                case .fixed(let targetHeight): min(targetHeight, calculateLargeScreenHeight())
                case .fraction(let fraction): min(fraction * lastPopupHeight, calculateLargeScreenHeight())
                case .fullscreen(let stackVisible): stackVisible ? calculateLargeScreenHeight() : screenManager.size.height
            }}
            .appending(lastPopupHeight)
            .sorted(by: <)
    }
    func calculateTargetPopupHeight(_ currentPopupHeight: CGFloat, _ popupTargetHeights: [CGFloat]) -> CGFloat {
        guard let lastPopupHeight = getLastPopupHeight(),
              currentPopupHeight < screenManager.size.height
        else { return popupTargetHeights.last ?? 0 }

        let initialIndex = popupTargetHeights.firstIndex(where: { $0 >= currentPopupHeight }) ?? popupTargetHeights.count - 1,
            targetIndex = gestureTranslation * getDragTranslationMultiplier() > 0 ? initialIndex : max(0, initialIndex - 1)
        let previousPopupHeight = getLastDragHeight() + lastPopupHeight,
            popupTargetHeight = popupTargetHeights[targetIndex],
            deltaHeight = abs(previousPopupHeight - popupTargetHeight)
        let progress = abs(currentPopupHeight - previousPopupHeight) / deltaHeight

        if progress < gestureClosingThresholdFactor {
            let index = gestureTranslation * getDragTranslationMultiplier() > 0 ? max(0, initialIndex - 1) : initialIndex
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



enum VerticalEdge {
    case top
    case bottom
}
extension VerticalEdge {
    static prefix func !(lhs: Self) -> Self { switch lhs {
        case .top: .bottom
        case .bottom: .top
    }}
}
