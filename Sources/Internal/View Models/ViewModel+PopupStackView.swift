//
//  ViewModel+PopupStackView.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension PopupStackView { @MainActor class ViewModel: ObservableObject { init(alignment: VerticalEdge) { self.alignment = alignment }
    private(set) var alignment: VerticalEdge
    private(set) var popups: [AnyPopup] = []

    private var updatePopupAction: ((AnyPopup) -> ())!
    private var closePopupAction: ((AnyPopup) -> ())!






    private(set) var activePopupHeight: CGFloat? = nil
    @Published private(set) var screen: ScreenProperties = .init()
    @Published private(set) var isKeyboardActive: Bool = false


    private var gestureTranslation: CGFloat = 0
    private var translationProgress: CGFloat = 0
}}

// MARK: Setup
extension PopupStackView.ViewModel {
    func setup(updatePopupAction: @escaping (AnyPopup) -> (), closePopupAction: @escaping (AnyPopup) -> ()) {
        self.updatePopupAction = updatePopupAction
        self.closePopupAction = closePopupAction
    }
}

// MARK: Updating
extension PopupStackView.ViewModel {
    func updatePopupsProperty(_ newPopups: [AnyPopup]) {
        popups = newPopups
        activePopupHeight = calculateHeightForActivePopup()

        Task { @MainActor in withAnimation(.transition) { objectWillChange.send() }}
    }
    func updateScreenProperty(_ newScreen: ScreenProperties) {
        screen = newScreen
    }
    func updateKeyboardProperty(_ isActive: Bool) {
        isKeyboardActive = isActive
    }
}
private extension PopupStackView.ViewModel {
    func updateGestureTranslation(_ newGestureTranslation: CGFloat) {
        gestureTranslation = newGestureTranslation
        translationProgress = calculateTranslationProgress()
        activePopupHeight = calculateHeightForActivePopup()

        Task { @MainActor in withAnimation(gestureTranslation == 0 ? .transition : nil) {
            objectWillChange.send()
        }}
    }
}

extension PopupStackView.ViewModel {
    func update(popup: AnyPopup, _ action: @escaping (inout AnyPopup) -> ()) { Task { @MainActor in
        var popup = popup
        action(&popup)
        updatePopupAction(popup)
    }}
}



// MARK: - Calculating Height For Active Popup
private extension PopupStackView.ViewModel {
    func calculateHeightForActivePopup() -> CGFloat? {
        guard let activePopupHeight = popups.last?.height else { return nil }

        let activePopupDragHeight = popups.last?.dragHeight ?? 0
        let popupHeightFromGestureTranslation = activePopupHeight + activePopupDragHeight + gestureTranslation * getDragTranslationMultiplier()

        let newHeightCandidate1 = max(activePopupHeight, popupHeightFromGestureTranslation),
            newHeightCanditate2 = screen.height
        return min(newHeightCandidate1, newHeightCanditate2)
    }
}
private extension PopupStackView.ViewModel {
    func getDragTranslationMultiplier() -> CGFloat { switch alignment {
        case .top: 1
        case .bottom: -1
    }}
}

// MARK: - Translation Progress
private extension PopupStackView.ViewModel {
    func calculateTranslationProgress() -> CGFloat { guard let activePopupHeight = popups.last?.height else { return 0 }; return switch alignment {
        case .top: abs(min(gestureTranslation + (popups.last?.dragHeight ?? 0), 0)) / activePopupHeight
        case .bottom: max(gestureTranslation - (popups.last?.dragHeight ?? 0), 0) / activePopupHeight
    }}
}

// MARK: - Calculating Paddings For Popup Body
extension PopupStackView.ViewModel {
    func calculateBodyPadding(for popup: AnyPopup) -> EdgeInsets { let activePopupHeight = activePopupHeight ?? 0, popupConfig = getConfig(popup); return .init(
        top: calculateTopBodyPadding(activePopupHeight: activePopupHeight, popupConfig: popupConfig),
        leading: calculateLeadingBodyPadding(popupConfig: popupConfig),
        bottom: calculateBottomBodyPadding(activePopupHeight: activePopupHeight, popupConfig: popupConfig),
        trailing: calculateTrailingBodyPadding(popupConfig: popupConfig)
    )}
}
private extension PopupStackView.ViewModel {
    func calculateTopBodyPadding(activePopupHeight: CGFloat, popupConfig: Config) -> CGFloat {
        if popupConfig.ignoredSafeAreaEdges.contains(.top) { return 0 }

        return switch alignment {
            case .top: calculateVerticalPaddingAdhereEdge(safeAreaHeight: screen.safeArea.top, popupPadding: calculatePopupPadding().top)
            case .bottom: calculateVerticalPaddingCounterEdge(popupHeight: activePopupHeight, safeArea: screen.safeArea.top)
        }
    }
    func calculateBottomBodyPadding(activePopupHeight: CGFloat, popupConfig: Config) -> CGFloat {
        if popupConfig.ignoredSafeAreaEdges.contains(.bottom) && !isKeyboardActive { return 0 }

        return switch alignment {
            case .top: calculateVerticalPaddingCounterEdge(popupHeight: activePopupHeight, safeArea: screen.safeArea.bottom)
            case .bottom: calculateVerticalPaddingAdhereEdge(safeAreaHeight: screen.safeArea.bottom, popupPadding: calculatePopupPadding().bottom)
        }
    }
    func calculateLeadingBodyPadding(popupConfig: Config) -> CGFloat { switch popupConfig.ignoredSafeAreaEdges.contains(.leading) {
        case true: 0
        case false: screen.safeArea.leading
    }}
    func calculateTrailingBodyPadding(popupConfig: Config) -> CGFloat { switch popupConfig.ignoredSafeAreaEdges.contains(.trailing) {
        case true: 0
        case false: screen.safeArea.trailing
    }}
}
private extension PopupStackView.ViewModel {
    func calculateVerticalPaddingCounterEdge(popupHeight: CGFloat, safeArea: CGFloat) -> CGFloat {
        let paddingValueCandidate = safeArea + popupHeight - screen.height
        return max(paddingValueCandidate, 0)
    }
    func calculateVerticalPaddingAdhereEdge(safeAreaHeight: CGFloat, popupPadding: CGFloat) -> CGFloat {
        let paddingValueCandidate = safeAreaHeight - popupPadding
        return max(paddingValueCandidate, 0)
    }
}

// MARK: - Popup Padding
extension PopupStackView.ViewModel {
    func calculatePopupPadding() -> EdgeInsets { .init(
        top: calculateVerticalPopupPadding(for: .top),
        leading: calculateLeadingPopupPadding(),
        bottom: calculateVerticalPopupPadding(for: .bottom),
        trailing: calculateTrailingPopupPadding()
    )}
}
private extension PopupStackView.ViewModel {
    func calculateVerticalPopupPadding(for edge: VerticalEdge) -> CGFloat { guard let activePopupHeight else { return 0 }
        let largeScreenHeight = calculateLargeScreenHeight(),
            priorityPopupPaddingValue = calculatePriorityPopupPaddingValue(for: edge),
            remainingHeight = largeScreenHeight - activePopupHeight - priorityPopupPaddingValue

        let popupPaddingCandidate = min(remainingHeight, activePopupConfig.popupPadding[edge])
        return max(popupPaddingCandidate, 0)
    }
    func calculateLeadingPopupPadding() -> CGFloat {
        activePopupConfig.popupPadding.leading
    }
    func calculateTrailingPopupPadding() -> CGFloat {
        activePopupConfig.popupPadding.trailing
    }
}
private extension PopupStackView.ViewModel {
    func calculatePriorityPopupPaddingValue(for edge: VerticalEdge) -> CGFloat { switch edge == alignment {
        case true: 0
        case false: activePopupConfig.popupPadding[!edge]
    }}
}





// MARK: - Calculating Corner Radius
extension PopupStackView.ViewModel {
    func calculateCornerRadius() -> [VerticalEdge: CGFloat] {
        let cornerRadiusValue = calculateCornerRadiusValue(activePopupConfig)
        return [
            .top: calculateTopCornerRadius(cornerRadiusValue),
            .bottom: calculateBottomCornerRadius(cornerRadiusValue)
        ]
    }
}
private extension PopupStackView.ViewModel {
    func calculateCornerRadiusValue(_ activePopupConfig: Config) -> CGFloat { switch activePopupConfig.heightMode {
        case .auto, .large: activePopupConfig.cornerRadius
        case .fullscreen: 0
    }}
    func calculateTopCornerRadius(_ cornerRadiusValue: CGFloat) -> CGFloat { switch alignment {
        case .top: calculatePopupPadding().top != 0 ? cornerRadiusValue : 0
        case .bottom: cornerRadiusValue
    }}
    func calculateBottomCornerRadius(_ cornerRadiusValue: CGFloat) -> CGFloat { switch alignment {
        case .top: cornerRadiusValue
        case .bottom: calculatePopupPadding().bottom != 0 ? cornerRadiusValue : 0
    }}
}

// MARK: - Item ZIndex
extension PopupStackView.ViewModel {
    func calculateZIndex(for popup: AnyPopup) -> Double {
        .init(popups.firstIndex(of: popup) ?? 2137)
    }
}


// MARK: - Saving Height For Item
extension PopupStackView.ViewModel {
    func save(height: CGFloat, for popup: AnyPopup) { if gestureTranslation.isZero {
        let popupConfig = getConfig(popup)
        let newHeight = calculateHeight(height, popupConfig)
        updateHeight(newHeight, popup)
    }}
}
private extension PopupStackView.ViewModel {
    func calculateHeight(_ height: CGFloat, _ popupConfig: Config) -> CGFloat { switch popupConfig.heightMode {
        case .auto: min(height, calculateLargeScreenHeight())
        case .large: calculateLargeScreenHeight()
        case .fullscreen: getFullscreenHeight()
    }}
    func updateHeight(_ newHeight: CGFloat, _ item: AnyPopup) { if item.height != newHeight {
        update(popup: item) { $0.height = newHeight }
    }}
}
private extension PopupStackView.ViewModel {
    func calculateLargeScreenHeight() -> CGFloat {
        let fullscreenHeight = getFullscreenHeight(),
            safeAreaHeight = screen.safeArea[!alignment],
            stackHeight = calculateStackHeight()
        return fullscreenHeight - safeAreaHeight - stackHeight
    }
    func getFullscreenHeight() -> CGFloat {
        screen.height
    }
}
private extension PopupStackView.ViewModel {
    func calculateStackHeight() -> CGFloat {
        let numberOfStackedItems = max(popups.count - 1, 0)

        let stackedItemsHeight = stackOffset * .init(numberOfStackedItems)
        return stackedItemsHeight
    }
}

// MARK: - Calculating Offset
extension PopupStackView.ViewModel {
    func calculateOffsetY(for popup: AnyPopup) -> CGFloat { switch popup == popups.last {
        case true: calculateOffsetForActivePopup()
        case false: calculateOffsetForStackedPopup(popup)
    }}
}
private extension PopupStackView.ViewModel {
    func calculateOffsetForActivePopup() -> CGFloat {
        let lastPopupDragHeight = popups.last?.dragHeight ?? 0

        return switch alignment {
            case .top: min(gestureTranslation + lastPopupDragHeight, 0)
            case .bottom: max(gestureTranslation - lastPopupDragHeight, 0)
        }
    }
    func calculateOffsetForStackedPopup(_ popup: AnyPopup) -> CGFloat {
        let invertedIndex = getInvertedIndex(of: popup)
        let offsetValue = stackOffset * .init(invertedIndex)
        let alignmentMultiplier = switch alignment {
            case .top: 1.0
            case .bottom: -1.0
        }

        return offsetValue * alignmentMultiplier
    }
}

// MARK: - Calculating Scale
extension PopupStackView.ViewModel {
    func calculateScaleX(for popup: AnyPopup) -> CGFloat { guard popup != popups.last else { return 1 }
        let invertedIndex = getInvertedIndex(of: popup),
            remainingTranslationProgress = 1 - translationProgress

        let progressMultiplier = invertedIndex == 1 ? remainingTranslationProgress : max(minScaleProgressMultiplier, remainingTranslationProgress)
        let scaleValue = .init(invertedIndex) * stackScaleFactor * progressMultiplier
        return 1 - scaleValue
    }
}
private extension PopupStackView.ViewModel {
    var minScaleProgressMultiplier: CGFloat { 0.7 }
}

// MARK: - Fixed Size
extension PopupStackView.ViewModel {
    func calculateVerticalFixedSize(for popup: AnyPopup) -> Bool { switch getConfig(popup).heightMode {
        case .fullscreen, .large: false
        case .auto: activePopupHeight != calculateLargeScreenHeight()
    }}
}

// MARK: - Stack Overlay Opacity
extension PopupStackView.ViewModel {
    func calculateStackOverlayOpacity(for popup: AnyPopup) -> Double { guard popup != popups.last else { return 0 }
        let invertedIndex = getInvertedIndex(of: popup),
            remainingTranslationProgress = 1 - translationProgress

        let progressMultiplier = invertedIndex == 1 ? remainingTranslationProgress : max(minStackOverlayProgressMultiplier, remainingTranslationProgress)
        let overlayValue = min(stackOverlayFactor * .init(invertedIndex), maxStackOverlayFactor)

        let opacity = overlayValue * progressMultiplier
        return max(opacity, 0)
    }
}
private extension PopupStackView.ViewModel {
    var minStackOverlayProgressMultiplier: CGFloat { 0.6 }
}




// MARK: - Attributes
extension PopupStackView.ViewModel {
    var activePopupConfig: Config { getConfig(popups.last) }
}

// MARK: - Configurable Attributes
extension PopupStackView.ViewModel {
    var stackOffset: CGFloat { ConfigContainer.vertical.isStackingPossible ? 8 : 0 }
    var stackScaleFactor: CGFloat { 0.025 }
    var stackOverlayFactor: CGFloat { 0.1 }
    var maxStackOverlayFactor: CGFloat { 0.48 }
    var gestureClosingThresholdFactor: CGFloat { ConfigContainer.vertical.dragGestureProgressToClose }
    var dragGestureEnabled: Bool { activePopupConfig.dragGestureEnabled }
}

// MARK: - Helpers
extension PopupStackView.ViewModel {
    func getInvertedIndex(of popup: AnyPopup) -> Int {
        let index = popups.firstIndex(of: popup) ?? 0
        let invertedIndex = popups.count - 1 - index
        return invertedIndex
    }
    func getConfig(_ item: AnyPopup?) -> Config {
        let config = item?.config as? Config
        return config ?? .init()
    }
}


// MARK: - Gestures

// MARK: On Changed
extension PopupStackView.ViewModel {
    func onPopupDragGestureChanged(_ value: CGFloat) { if dragGestureEnabled {
        let newGestureTranslation = calculateGestureTranslation(value)
        updateGestureTranslation(newGestureTranslation)
    }}
}
private extension PopupStackView.ViewModel {
    func calculateGestureTranslation(_ value: CGFloat) -> CGFloat { switch activePopupConfig.dragDetents.isEmpty {
        case true: calculateGestureTranslationWhenNoDragDetents(value)
        case false: calculateGestureTranslationWhenDragDetents(value)
    }}
}
private extension PopupStackView.ViewModel {
    func calculateGestureTranslationWhenNoDragDetents(_ value: CGFloat) -> CGFloat {
        calculateDragExtremeValue(value, 0)
    }
    func calculateGestureTranslationWhenDragDetents(_ value: CGFloat) -> CGFloat { guard value * getDragTranslationMultiplier() > 0, let activePopupHeight = popups.last?.height else { return value }
        let maxHeight = calculateMaxHeightForDragGesture(activePopupHeight)
        let dragTranslation = calculateDragTranslation(maxHeight, activePopupHeight)
        return calculateDragExtremeValue(dragTranslation, value)
    }
}
private extension PopupStackView.ViewModel {
    func calculateMaxHeightForDragGesture(_ activePopupHeight: CGFloat) -> CGFloat {
        let maxHeight1 = (calculatePopupTargetHeightsFromDragDetents(activePopupHeight).max() ?? 0) + dragTranslationThreshold
        let maxHeight2 = screen.height
        return min(maxHeight1, maxHeight2)
    }
    func calculateDragTranslation(_ maxHeight: CGFloat, _ activePopupHeight: CGFloat) -> CGFloat {
        let translation = maxHeight - activePopupHeight - (popups.last?.dragHeight ?? 0)
        return translation * getDragTranslationMultiplier()
    }
    func calculateDragExtremeValue(_ value1: CGFloat, _ value2: CGFloat) -> CGFloat { switch alignment {
        case .top: min(value1, value2)
        case .bottom: max(value1, value2)
    }}
}
private extension PopupStackView.ViewModel {
    var dragTranslationThreshold: CGFloat { 8 }
}

// MARK: On Ended
extension PopupStackView.ViewModel {
    func onPopupDragGestureEnded(_ value: CGFloat) { guard value != 0 else { return }
        dismissLastItemIfNeeded()
        updateTranslationValues()
    }
}
private extension PopupStackView.ViewModel {
    func dismissLastItemIfNeeded() { if shouldDismissPopup() { if let popup = popups.last {
        closePopupAction(popup)
    }}}
    func updateTranslationValues() { if let activePopupHeight = popups.last?.height {
        let currentPopupHeight = calculateCurrentPopupHeight(activePopupHeight)
        let popupTargetHeights = calculatePopupTargetHeightsFromDragDetents(activePopupHeight)
        let targetHeight = calculateTargetPopupHeight(currentPopupHeight, popupTargetHeights)
        let targetDragHeight = calculateTargetDragHeight(targetHeight, activePopupHeight)

        resetGestureTranslation()
        updateDragHeight(targetDragHeight)
    }}
}
private extension PopupStackView.ViewModel {
    func calculateCurrentPopupHeight(_ activePopupHeight: CGFloat) -> CGFloat {
        let activePopupDragHeight = popups.last?.dragHeight ?? 0
        let currentDragHeight = activePopupDragHeight + gestureTranslation * getDragTranslationMultiplier()

        let currentPopupHeight = activePopupHeight + currentDragHeight
        return currentPopupHeight
    }
    func calculatePopupTargetHeightsFromDragDetents(_ activePopupHeight: CGFloat) -> [CGFloat] { activePopupConfig.dragDetents
            .map { switch $0 {
                case .fixed(let targetHeight): min(targetHeight, calculateLargeScreenHeight())
                case .fraction(let fraction): min(fraction * activePopupHeight, calculateLargeScreenHeight())
                case .large: calculateLargeScreenHeight()
                case .fullscreen: screen.height
            }}
            .appending(activePopupHeight)
            .sorted(by: <)
    }
    func calculateTargetPopupHeight(_ currentPopupHeight: CGFloat, _ popupTargetHeights: [CGFloat]) -> CGFloat {
        guard let activePopupHeight = popups.last?.height,
              currentPopupHeight < screen.height
        else { return popupTargetHeights.last ?? 0 }

        let initialIndex = popupTargetHeights.firstIndex(where: { $0 >= currentPopupHeight }) ?? popupTargetHeights.count - 1,
            targetIndex = gestureTranslation * getDragTranslationMultiplier() > 0 ? initialIndex : max(0, initialIndex - 1)
        let previousPopupHeight = (popups.last?.dragHeight ?? 0) + activePopupHeight,
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
    func updateDragHeight(_ targetDragHeight: CGFloat) { if let activePopup = popups.last {
        update(popup: activePopup) { $0.dragHeight = targetDragHeight }
    }}
    func resetGestureTranslation() {
        updateGestureTranslation(0)
    }
    func shouldDismissPopup() -> Bool {
        translationProgress >= gestureClosingThresholdFactor
    }
}




// MARK: - Testing
#if DEBUG
extension PopupStackView.ViewModel {
    var testHook: TestHook { .init(target: self) }
}



extension PopupStackView.ViewModel { struct TestHook {
    private let target: PopupStackView.ViewModel
    init(target: PopupStackView.ViewModel) { self.target = target }
}}
extension PopupStackView.ViewModel.TestHook {
    @MainActor func getInvertedIndex(of popup: AnyPopup) -> Int { target.getInvertedIndex(of: popup) }
    @MainActor func update(popup: AnyPopup, _ action: @escaping (inout AnyPopup) -> ()) { target.update(popup: popup, action) }
    @MainActor func calculatePopupHeight(height: CGFloat, popupConfig: Config) -> CGFloat { target.calculateHeight(height, popupConfig) }
    @MainActor func calculatePopupOffsetY(for popup: AnyPopup) -> CGFloat { target.calculateOffsetY(for: popup) }
    @MainActor func calculateBodyPadding(for popup: AnyPopup) -> EdgeInsets { target.calculateBodyPadding(for: popup) }
    @MainActor func calculateTranslationProgress() -> CGFloat { target.calculateTranslationProgress() }
    @MainActor func calculateCornerRadius() -> [VerticalEdge: CGFloat] { target.calculateCornerRadius() }
    @MainActor func calculateScaleX(for popup: AnyPopup) -> CGFloat { target.calculateScaleX(for: popup) }
    @MainActor func calculateStackOverlayOpacity(for popup: AnyPopup) -> CGFloat { target.calculateStackOverlayOpacity(for: popup) }
    @MainActor func calculateVerticalFixedSize(for popup: AnyPopup) -> Bool { target.calculateVerticalFixedSize(for: popup) }
    @MainActor func calculatePopupPadding() -> EdgeInsets { target.calculatePopupPadding() }
    @MainActor func recalculateActivePopupHeight() { target.activePopupHeight = target.calculateHeightForActivePopup() }
    @MainActor func recalculateTranslationProgress() { target.translationProgress = target.calculateTranslationProgress() }
    @MainActor func updateScreenProperty(_ newScreen: ScreenProperties) { target.updateScreenProperty(newScreen) }

    @MainActor func onPopupDragGestureChanged(_ value: CGFloat) { target.onPopupDragGestureChanged(value) }
    @MainActor func onPopupDragGestureEnded(_ value: CGFloat) { target.onPopupDragGestureEnded(value) }


    @MainActor func updatePopupsProperty(_ newPopups: [AnyPopup]) { target.updatePopupsProperty(newPopups) }
    @MainActor func updateGestureTranslation(_ newGestureTranslation: CGFloat) { target.updateGestureTranslation(newGestureTranslation) }
}
extension PopupStackView.ViewModel.TestHook {
    @MainActor var stackOffset: CGFloat { target.stackOffset }
    @MainActor var stackScaleFactor: CGFloat { target.stackScaleFactor }
    @MainActor var stackOverlayFactor: CGFloat { target.stackOverlayFactor }
    @MainActor var minScaleProgressMultiplier: CGFloat { target.minScaleProgressMultiplier }
    @MainActor var minStackOverlayProgressMultiplier: CGFloat { target.minStackOverlayProgressMultiplier }
    @MainActor var maxStackOverlayFactor: CGFloat { target.maxStackOverlayFactor }
    @MainActor var dragTranslationThreshold: CGFloat { target.dragTranslationThreshold }
    @MainActor var gestureTranslation: CGFloat { target.gestureTranslation }
}
#endif
