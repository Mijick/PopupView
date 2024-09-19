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
    @ObservedObject var viewModel: ViewModel
    @Binding var items: [AnyPopup]
    @State private var gestureTranslation: CGFloat = 0
    @GestureState private var isGestureActive: Bool = false
    @ObservedObject private var screenManager: ScreenManager = .shared
    @ObservedObject private var keyboardManager: KeyboardManager = .shared


    var body: some View {
        viewModel.activePopupHeight = calculateHeightForActivePopup()


        return ZStack(alignment: (!itemsAlignment).toAlignment(), content: createPopupStack)
            .frame(height: screenManager.size.height, alignment: itemsAlignment.toAlignment())
            .animation(heightAnimation, value: items.map(\.height))
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
        Counter.increment()



        let config = getConfig(item.wrappedValue),
            translationProgress = calculateTranslationProgress()


        return item.wrappedValue.body
            .padding(calculateBodyPadding(popupConfig: config))
            .fixedSize(horizontal: false, vertical: calculateVerticalFixedSize(popupConfig: config))
            .onHeightChange { save(height: $0, for: item, popupConfig: config) }
            .frame(height: viewModel.activePopupHeight, alignment: (!itemsAlignment).toAlignment())
            .frame(maxWidth: .infinity)
            .background(getBackgroundColour(popupConfig: config), overlayColour: getStackOverlayColour(for: item.wrappedValue, translationProgress: translationProgress), corners: calculateCornerRadius(), shadow: popupShadow)
            .offset(y: calculateOffset(for: item.wrappedValue))
            .scaleEffect(x: calculateScale(for: item.wrappedValue, translationProgress: translationProgress))
            .focusSectionIfAvailable()
            .padding(calculatePopupPadding())
            .transition(transition)
            .zIndex(calculateZIndex(for: item.wrappedValue))
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
    func calculateBodyPadding(popupConfig: Config) -> EdgeInsets { guard let activePopupHeight = viewModel.activePopupHeight else { return .init() }; return .init(
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
            case .top: calculateVerticalPaddingAdhereEdge(safeAreaHeight: screenManager.safeArea.top, popupPadding: calculatePopupPadding().top)
            case .bottom: calculateVerticalPaddingCounterEdge(popupHeight: activePopupHeight, safeArea: screenManager.safeArea.top)
        }
    }
    func calculateBottomBodyPadding(activePopupHeight: CGFloat, popupConfig: Config) -> CGFloat {
        if isKeyboardVisible { return keyboardManager.height + distanceFromKeyboard }
        if popupConfig.ignoredSafeAreaEdges.contains(.bottom) { return 0 }

        return switch itemsAlignment {
            case .top: calculateVerticalPaddingCounterEdge(popupHeight: activePopupHeight, safeArea: screenManager.safeArea.bottom)
            case .bottom: calculateVerticalPaddingAdhereEdge(safeAreaHeight: screenManager.safeArea.bottom, popupPadding: calculatePopupPadding().bottom)
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
    func calculateCornerRadius() -> [VerticalEdge: CGFloat] {
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
        case .top: calculatePopupPadding().top != 0 ? cornerRadiusValue : 0
        case .bottom: cornerRadiusValue
    }}
    func calculateBottomCornerRadius(_ cornerRadiusValue: CGFloat) -> CGFloat { switch itemsAlignment {
        case .top: cornerRadiusValue
        case .bottom: calculatePopupPadding().bottom != 0 ? cornerRadiusValue : 0
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
    func calculateLargeScreenHeight() -> CGFloat { let popupPadding = calculatePopupPadding()
        let fullscreenHeight = getFullscreenHeight(),
            safeAreaHeight = screenManager.safeArea[!viewModel.alignment],
            popupPaddings = popupPadding.top + popupPadding.bottom,
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

        return switch viewModel.alignment {
            case .top: min(gestureTranslation + lastPopupDragHeight, 0)
            case .bottom: max(gestureTranslation - lastPopupDragHeight, 0)
        }
    }
    func calculateOffsetForStackedPopup(_ popup: AnyPopup) -> CGFloat {
        let invertedIndex = getInvertedIndex(of: popup)
        let offsetValue = stackOffset * .init(invertedIndex)
        let alignmentMultiplier = switch viewModel.alignment {
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
    func calculateVerticalFixedSize(popupConfig: Config) -> Bool { switch popupConfig.heightMode {
        case .fullscreen, .large: false
        case .auto: viewModel.activePopupHeight != calculateLargeScreenHeight()
    }}
}

// MARK: - Stack Overlay Colour
private extension PopupStackView {
    func getStackOverlayColour(for popup: AnyPopup, translationProgress: CGFloat) -> Color {
        let opacity = calculateStackOverlayOpacity(popup, translationProgress)
        return stackOverlayColour.opacity(opacity)
    }
}
private extension PopupStackView {
    func calculateStackOverlayOpacity(_ popup: AnyPopup, _ translationProgress: CGFloat) -> Double { guard popup != items.last else { return 0 }
        let invertedIndex = getInvertedIndex(of: popup),
            remainingTranslationProgress = 1 - translationProgress

        let progressMultiplier = invertedIndex == 1 ? remainingTranslationProgress : max(0.6, remainingTranslationProgress)
        let overlayValue = min(stackOverlayFactor * .init(invertedIndex), maxStackOverlayFactor)

        let opacity = overlayValue * progressMultiplier
        return max(opacity, 0)
    }
}

// MARK: - Background Colour
private extension PopupStackView {
    func getBackgroundColour(popupConfig: Config) -> Color {
        popupConfig.backgroundColour
    }
}

// MARK: - Popup Padding
private extension PopupStackView {
    func calculatePopupPadding() -> EdgeInsets { guard activePopupConfig.heightMode != .fullscreen else { return .init() }; return .init(
        top: activePopupConfig.popupPadding.top,
        leading: activePopupConfig.popupPadding.horizontal,
        bottom: activePopupConfig.popupPadding.bottom,
        trailing: activePopupConfig.popupPadding.horizontal
    )}
}

// MARK: - Item ZIndex
private extension PopupStackView {
    func calculateZIndex(for popup: AnyPopup) -> Double {
        .init(items.firstIndex(of: popup) ?? 2137)
    }
}

// MARK: - Translation Progress
private extension PopupStackView {
    func calculateTranslationProgress() -> CGFloat { guard let activePopupHeight = items.last?.height else { return 0 }; return switch itemsAlignment {
        case .top: abs(min(gestureTranslation + (items.last?.dragHeight ?? 0), 0)) / activePopupHeight
        case .bottom: max(gestureTranslation - (items.last?.dragHeight ?? 0), 0) / activePopupHeight
    }}
}

// MARK: - Attributes
private extension PopupStackView {
    var isKeyboardVisible: Bool { keyboardManager.height > 0 }
    var activePopupConfig: Config { getConfig(items.last) }
    var globalConfig: GlobalConfig.Vertical { ConfigContainer.vertical }
}

// MARK: - Configurable Attributes
private extension PopupStackView {
    var popupShadow: Shadow { globalConfig.shadow }
    var stackOffset: CGFloat { globalConfig.isStackingPossible ? 8 : 0 }
    var stackScaleFactor: CGFloat { 0.025 }
    var stackOverlayColour: Color { .black }
    var stackOverlayFactor: CGFloat { 0.1 }
    var maxStackOverlayFactor: CGFloat { 0.48 }
    var transition: AnyTransition { .move(edge: itemsAlignment.toEdge()) }
    var heightAnimation: Animation? { screenManager.animationsDisabled ? nil : .transition }
    var gestureClosingThresholdFactor: CGFloat { globalConfig.dragGestureProgressToClose }
    var distanceFromKeyboard: CGFloat { activePopupConfig.distanceFromKeyboard }
    var dragGestureEnabled: Bool { activePopupConfig.dragGestureEnabled }
}

// MARK: - Helpers
private extension PopupStackView {
    func getInvertedIndex(of popup: AnyPopup) -> Int {
        let index = items.firstIndex(of: popup) ?? 0
        let invertedIndex = items.count - 1 - index
        return invertedIndex
    }
    func getConfig(_ item: AnyPopup?) -> Config {
        let config = item?.config as? Config
        return config ?? .init()
    }
}


// MARK: - Gestures

// MARK: On Changed
private extension PopupStackView {
    func onPopupDragGestureChanged(_ value: CGFloat) { if dragGestureEnabled {
        updateGestureTranslation(value)
    }}
}
private extension PopupStackView {
    func updateGestureTranslation(_ value: CGFloat) { switch activePopupConfig.dragDetents.isEmpty {
        case true: gestureTranslation = calculateGestureTranslationWhenNoDragDetents(value)
        case false: gestureTranslation = calculateGestureTranslationWhenDragDetents(value)
    }}
}
private extension PopupStackView {
    func calculateGestureTranslationWhenNoDragDetents(_ value: CGFloat) -> CGFloat {
        calculateDragExtremeValue(value, 0)
    }
    func calculateGestureTranslationWhenDragDetents(_ value: CGFloat) -> CGFloat { guard value * getDragTranslationMultiplier() > 0, let activePopupHeight = items.last?.height else { return value }
        let maxHeight = calculateMaxHeightForDragGesture(activePopupHeight)
        let dragTranslation = calculateDragTranslation(maxHeight, activePopupHeight)
        return calculateDragExtremeValue(dragTranslation, value)
    }
}
private extension PopupStackView {
    func calculateMaxHeightForDragGesture(_ activePopupHeight: CGFloat) -> CGFloat {
        let maxHeight1 = (calculatePopupTargetHeightsFromDragDetents(activePopupHeight).max() ?? 0) + dragTranslationThreshold
        let maxHeight2 = screenManager.size.height
        return min(maxHeight1, maxHeight2)
    }
    func calculateDragTranslation(_ maxHeight: CGFloat, _ activePopupHeight: CGFloat) -> CGFloat {
        let translation = maxHeight - activePopupHeight - (items.last?.dragHeight ?? 0)
        return translation * getDragTranslationMultiplier()
    }
    func calculateDragExtremeValue(_ value1: CGFloat, _ value2: CGFloat) -> CGFloat { switch viewModel.alignment {
        case .top: min(value1, value2)
        case .bottom: max(value1, value2)
    }}
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
    func updateTranslationValues() { if let activePopupHeight = items.last?.height {
        let currentPopupHeight = calculateCurrentPopupHeight(activePopupHeight)
        let popupTargetHeights = calculatePopupTargetHeightsFromDragDetents(activePopupHeight)
        let targetHeight = calculateTargetPopupHeight(currentPopupHeight, popupTargetHeights)
        let targetDragHeight = calculateTargetDragHeight(targetHeight, activePopupHeight)

        resetGestureTranslation()
        updateDragHeight(targetDragHeight)
    }}
}
private extension PopupStackView {
    func calculateCurrentPopupHeight(_ activePopupHeight: CGFloat) -> CGFloat {
        let activePopupDragHeight = items.last?.dragHeight ?? 0
        let currentDragHeight = activePopupDragHeight + gestureTranslation * getDragTranslationMultiplier()

        let currentPopupHeight = activePopupHeight + currentDragHeight
        return currentPopupHeight
    }
    func calculatePopupTargetHeightsFromDragDetents(_ activePopupHeight: CGFloat) -> [CGFloat] { activePopupConfig.dragDetents
            .map { switch $0 {
                case .fixed(let targetHeight): min(targetHeight, calculateLargeScreenHeight())
                case .fraction(let fraction): min(fraction * activePopupHeight, calculateLargeScreenHeight())
                case .fullscreen(let stackVisible): stackVisible ? calculateLargeScreenHeight() : screenManager.size.height
            }}
            .appending(activePopupHeight)
            .sorted(by: <)
    }
    func calculateTargetPopupHeight(_ currentPopupHeight: CGFloat, _ popupTargetHeights: [CGFloat]) -> CGFloat {
        guard let activePopupHeight = items.last?.height,
              currentPopupHeight < screenManager.size.height
        else { return popupTargetHeights.last ?? 0 }

        let initialIndex = popupTargetHeights.firstIndex(where: { $0 >= currentPopupHeight }) ?? popupTargetHeights.count - 1,
            targetIndex = gestureTranslation * getDragTranslationMultiplier() > 0 ? initialIndex : max(0, initialIndex - 1)
        let previousPopupHeight = (items.last?.dragHeight ?? 0) + activePopupHeight,
            popupTargetHeight = popupTargetHeights[targetIndex],
            deltaHeight = abs(previousPopupHeight - popupTargetHeight)
        let progress = abs(currentPopupHeight - previousPopupHeight) / deltaHeight

        if progress < gestureClosingThresholdFactor {
            let index = gestureTranslation * getDragTranslationMultiplier() > 0 ? max(0, initialIndex - 1) : initialIndex
            return popupTargetHeights[index]
        }
        return popupTargetHeights[targetIndex]
    }
    func calculateTargetDragHeight(_ targetHeight: CGFloat, _ activePopupHeight: CGFloat) -> CGFloat {
        targetHeight - activePopupHeight
    }
    func updateDragHeight(_ targetDragHeight: CGFloat) { Task { @MainActor in
        items.lastElement?.dragHeight = targetDragHeight
    }}
    func resetGestureTranslation() { Task { @MainActor in
        gestureTranslation = 0
    }}
    func shouldDismissPopup() -> Bool {
        calculateTranslationProgress() >= gestureClosingThresholdFactor
    }
}

// MARK: Helpers
private extension PopupStackView {
    func getDragTranslationMultiplier() -> CGFloat { switch viewModel.alignment {
        case .top: 1
        case .bottom: -1
    }}
}







extension PopupStackView { class ViewModel: ObservableObject {
    let alignment: VerticalEdge

    var activePopupHeight: CGFloat? = nil



    init(alignment: VerticalEdge) {
        self.alignment = alignment
    }
}}
