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

extension PopupStackView { @MainActor class ViewModel: ObservableObject {
    let alignment: VerticalEdge

    var items: [AnyPopup] = [] { didSet { onItemsChanged() }}
    var gestureTranslation: CGFloat = 0 { didSet { onGestureTranslationChanged() }}
    var screen: ScreenProperties = .init() { didSet { onScreenChanged() }}

    var updatePopup: ((AnyPopup) -> ())? = nil
    @Published var isKeyboardActive: Bool = false
    @Published private(set) var activePopupHeight: CGFloat? = nil

    
    private(set) var translationProgress: CGFloat = 0


    // MARK: Initialiser
    init(alignment: VerticalEdge) { self.alignment = alignment }
}}
private extension PopupStackView.ViewModel {
    func onItemsChanged() {
        let activePopupHeightCandidate = calculateHeightForActivePopup()

        Task { @MainActor in withAnimation(.transition) {
            activePopupHeight = activePopupHeightCandidate
        }}
    }
    func onScreenChanged() {
        Task { @MainActor in
            objectWillChange.send()
        }
    }
    func onGestureTranslationChanged() {
        let translationProgressCandidate = calculateTranslationProgress()
        let activePopupHeightCandidate = calculateHeightForActivePopup()

        Task { @MainActor in withAnimation(gestureTranslation == 0 ? .transition : nil) {
            translationProgress = translationProgressCandidate
            activePopupHeight = activePopupHeightCandidate
        }}
    }
}

extension PopupStackView.ViewModel {
    func update(popup: AnyPopup, _ action: @escaping (inout AnyPopup) -> ()) { Task { @MainActor in
        var popup = popup
        action(&popup)
        updatePopup?(popup)
    }}
}



// MARK: - Calculating Height For Active Popup
private extension PopupStackView.ViewModel {
    func calculateHeightForActivePopup() -> CGFloat? {
        guard let activePopupHeight = items.last?.height else { return nil }

        let activePopupDragHeight = items.last?.dragHeight ?? 0
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
    func calculateTranslationProgress() -> CGFloat { guard let activePopupHeight = items.last?.height else { return 0 }; return switch alignment {
        case .top: abs(min(gestureTranslation + (items.last?.dragHeight ?? 0), 0)) / activePopupHeight
        case .bottom: max(gestureTranslation - (items.last?.dragHeight ?? 0), 0) / activePopupHeight
    }}
}

// MARK: - Calculating Paddings For Popup Body
extension PopupStackView.ViewModel {
    func calculateBodyPadding(popupConfig: Config) -> EdgeInsets { let activePopupHeight = activePopupHeight ?? 0; return .init(
        top: calculateTopBodyPadding(activePopupHeight: activePopupHeight, popupConfig: popupConfig),
        leading: calculateLeadingBodyPadding(),
        bottom: calculateBottomBodyPadding(activePopupHeight: activePopupHeight, popupConfig: popupConfig),
        trailing: calculateTrailingBodyPadding()
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
    func calculateLeadingBodyPadding() -> CGFloat {
        screen.safeArea.leading
    }
    func calculateTrailingBodyPadding() -> CGFloat {
        screen.safeArea.trailing
    }
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
    func calculatePopupPadding() -> EdgeInsets { guard activePopupConfig.heightMode != .fullscreen else { return .init() }; return .init(
        top: activePopupConfig.popupPadding.top,
        leading: activePopupConfig.popupPadding.horizontal,
        bottom: activePopupConfig.popupPadding.bottom,
        trailing: activePopupConfig.popupPadding.horizontal
    )}
}



// MARK: - Helpers
private extension PopupStackView.ViewModel {
    var activePopupConfig: Config {
        let config = items.last?.config as? Config
        return config ?? .init()
    }
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
        .init(items.firstIndex(of: popup) ?? 2137)
    }
}


// MARK: - Saving Height For Item
extension PopupStackView.ViewModel {
    func save(height: CGFloat, for popup: AnyPopup, popupConfig: Config) { if gestureTranslation.isZero {
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
    func calculateLargeScreenHeight() -> CGFloat { let popupPadding = calculatePopupPadding()
        let fullscreenHeight = getFullscreenHeight(),
            safeAreaHeight = screen.safeArea[!alignment],
            popupPaddings = popupPadding.top + popupPadding.bottom,
            stackHeight = calculateStackHeight()
        return fullscreenHeight - safeAreaHeight - popupPaddings - stackHeight
    }
    func getFullscreenHeight() -> CGFloat {
        screen.height
    }
}
private extension PopupStackView.ViewModel {
    func calculateStackHeight() -> CGFloat {
        let numberOfStackedItems = max(items.count - 1, 0)

        let stackedItemsHeight = stackOffset * .init(numberOfStackedItems)
        return stackedItemsHeight
    }
}

// MARK: - Calculating Offset
extension PopupStackView.ViewModel {
    func calculateOffset(for popup: AnyPopup) -> CGFloat { switch popup == items.last {
        case true: calculateOffsetForActivePopup()
        case false: calculateOffsetForStackedPopup(popup)
    }}
}
private extension PopupStackView.ViewModel {
    func calculateOffsetForActivePopup() -> CGFloat {
        let lastPopupDragHeight = items.last?.dragHeight ?? 0

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
    func calculateScale(for popup: AnyPopup) -> CGFloat { guard popup != items.last else { return 1 }
        let invertedIndex = getInvertedIndex(of: popup),
            remainingTranslationProgress = 1 - translationProgress

        let progressMultiplier = invertedIndex == 1 ? remainingTranslationProgress : max(0.7, remainingTranslationProgress)
        let scaleValue = .init(invertedIndex) * stackScaleFactor * progressMultiplier
        return 1 - scaleValue
    }
}

// MARK: - Fixed Size
extension PopupStackView.ViewModel {
    func calculateVerticalFixedSize(popupConfig: Config) -> Bool { switch popupConfig.heightMode {
        case .fullscreen, .large: false
        case .auto: activePopupHeight != calculateLargeScreenHeight()
    }}
}

// MARK: - Stack Overlay Colour
extension PopupStackView.ViewModel {
    func getStackOverlayColour(for popup: AnyPopup) -> Color {
        let opacity = calculateStackOverlayOpacity(popup)
        return stackOverlayColour.opacity(opacity)
    }
}
private extension PopupStackView.ViewModel {
    func calculateStackOverlayOpacity(_ popup: AnyPopup) -> Double { guard popup != viewModel.items.last else { return 0 }
        let invertedIndex = getInvertedIndex(of: popup),
            remainingTranslationProgress = 1 - viewModel.translationProgress

        let progressMultiplier = invertedIndex == 1 ? remainingTranslationProgress : max(0.6, remainingTranslationProgress)
        let overlayValue = min(stackOverlayFactor * .init(invertedIndex), maxStackOverlayFactor)

        let opacity = overlayValue * progressMultiplier
        return max(opacity, 0)
    }
}

// MARK: - Background Colour
private extension PopupStackView.ViewModel {
    func getBackgroundColour(popupConfig: Config) -> Color {
        popupConfig.backgroundColour
    }
}


// MARK: - Attributes
private extension PopupStackView {
    var activePopupConfig: Config { getConfig(viewModel.items.last) }
    var globalConfig: GlobalConfig.Vertical { ConfigContainer.vertical }
}

// MARK: - Configurable Attributes
private extension PopupStackView.ViewModel {
    var popupShadow: Shadow { globalConfig.shadow }
    var stackOffset: CGFloat { globalConfig.isStackingPossible ? 8 : 0 }
    var stackScaleFactor: CGFloat { 0.025 }
    var stackOverlayColour: Color { .black }
    var stackOverlayFactor: CGFloat { 0.1 }
    var maxStackOverlayFactor: CGFloat { 0.48 }
    var transition: AnyTransition { .move(edge: viewModel.alignment.toEdge()) }
    var gestureClosingThresholdFactor: CGFloat { globalConfig.dragGestureProgressToClose }
    var dragGestureEnabled: Bool { activePopupConfig.dragGestureEnabled }
}

// MARK: - Helpers
private extension PopupStackView.ViewModel {
    func getInvertedIndex(of popup: AnyPopup) -> Int {
        let index = viewModel.items.firstIndex(of: popup) ?? 0
        let invertedIndex = viewModel.items.count - 1 - index
        return invertedIndex
    }
    func getConfig(_ item: AnyPopup?) -> Config {
        let config = item?.config as? Config
        return config ?? .init()
    }
}


// MARK: - Gestures

// MARK: On Changed
private extension PopupStackView.ViewModel {
    func onPopupDragGestureChanged(_ value: CGFloat) { if dragGestureEnabled {
        updateGestureTranslation(value)
    }}
}
private extension PopupStackView.ViewModel {
    func updateGestureTranslation(_ value: CGFloat) { switch activePopupConfig.dragDetents.isEmpty {
        case true: viewModel.gestureTranslation = calculateGestureTranslationWhenNoDragDetents(value)
        case false: viewModel.gestureTranslation = calculateGestureTranslationWhenDragDetents(value)
    }}
}
private extension PopupStackView.ViewModel {
    func calculateGestureTranslationWhenNoDragDetents(_ value: CGFloat) -> CGFloat {
        calculateDragExtremeValue(value, 0)
    }
    func calculateGestureTranslationWhenDragDetents(_ value: CGFloat) -> CGFloat { guard value * getDragTranslationMultiplier() > 0, let activePopupHeight = viewModel.items.last?.height else { return value }
        let maxHeight = calculateMaxHeightForDragGesture(activePopupHeight)
        let dragTranslation = calculateDragTranslation(maxHeight, activePopupHeight)
        return calculateDragExtremeValue(dragTranslation, value)
    }
}
private extension PopupStackView.ViewModel {
    func calculateMaxHeightForDragGesture(_ activePopupHeight: CGFloat) -> CGFloat {
        let maxHeight1 = (calculatePopupTargetHeightsFromDragDetents(activePopupHeight).max() ?? 0) + dragTranslationThreshold
        let maxHeight2 = viewModel.screen.height
        return min(maxHeight1, maxHeight2)
    }
    func calculateDragTranslation(_ maxHeight: CGFloat, _ activePopupHeight: CGFloat) -> CGFloat {
        let translation = maxHeight - activePopupHeight - (viewModel.items.last?.dragHeight ?? 0)
        return translation * getDragTranslationMultiplier()
    }
    func calculateDragExtremeValue(_ value1: CGFloat, _ value2: CGFloat) -> CGFloat { switch viewModel.alignment {
        case .top: min(value1, value2)
        case .bottom: max(value1, value2)
    }}
}
private extension PopupStackView.ViewModel {
    var dragTranslationThreshold: CGFloat { 8 }
}

// MARK: On Ended
private extension PopupStackView.ViewModel {
    func onPopupDragGestureEnded(_ value: CGFloat) { guard value != 0 else { return }
        dismissLastItemIfNeeded()
        updateTranslationValues()
    }
}
private extension PopupStackView.ViewModel {
    func dismissLastItemIfNeeded() { if shouldDismissPopup() {
        PopupManager.dismissPopup(id: viewModel.items.last?.id.value ?? "")
    }}
    func updateTranslationValues() { if let activePopupHeight = viewModel.items.last?.height {
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
        let activePopupDragHeight = viewModel.items.last?.dragHeight ?? 0
        let currentDragHeight = activePopupDragHeight + viewModel.gestureTranslation * getDragTranslationMultiplier()

        let currentPopupHeight = activePopupHeight + currentDragHeight
        return currentPopupHeight
    }
    func calculatePopupTargetHeightsFromDragDetents(_ activePopupHeight: CGFloat) -> [CGFloat] { activePopupConfig.dragDetents
            .map { switch $0 {
                case .fixed(let targetHeight): min(targetHeight, calculateLargeScreenHeight())
                case .fraction(let fraction): min(fraction * activePopupHeight, calculateLargeScreenHeight())
                case .fullscreen(let stackVisible): stackVisible ? calculateLargeScreenHeight() : viewModel.screen.height
            }}
            .appending(activePopupHeight)
            .sorted(by: <)
    }
    func calculateTargetPopupHeight(_ currentPopupHeight: CGFloat, _ popupTargetHeights: [CGFloat]) -> CGFloat {
        guard let activePopupHeight = viewModel.items.last?.height,
              currentPopupHeight < viewModel.screen.height
        else { return popupTargetHeights.last ?? 0 }

        let initialIndex = popupTargetHeights.firstIndex(where: { $0 >= currentPopupHeight }) ?? popupTargetHeights.count - 1,
            targetIndex = viewModel.gestureTranslation * getDragTranslationMultiplier() > 0 ? initialIndex : max(0, initialIndex - 1)
        let previousPopupHeight = (viewModel.items.last?.dragHeight ?? 0) + activePopupHeight,
            popupTargetHeight = popupTargetHeights[targetIndex],
            deltaHeight = abs(previousPopupHeight - popupTargetHeight)
        let progress = abs(currentPopupHeight - previousPopupHeight) / deltaHeight

        if progress < gestureClosingThresholdFactor {
            let index = viewModel.gestureTranslation * getDragTranslationMultiplier() > 0 ? max(0, initialIndex - 1) : initialIndex
            return popupTargetHeights[index]
        }
        return popupTargetHeights[targetIndex]
    }
    func calculateTargetDragHeight(_ targetHeight: CGFloat, _ activePopupHeight: CGFloat) -> CGFloat {
        targetHeight - activePopupHeight
    }
    func updateDragHeight(_ targetDragHeight: CGFloat) { if let activePopup = viewModel.items.last {
        viewModel.update(popup: activePopup) { $0.dragHeight = targetDragHeight }
    }}
    func resetGestureTranslation() {
        viewModel.gestureTranslation = 0
    }
    func shouldDismissPopup() -> Bool {
        viewModel.translationProgress >= gestureClosingThresholdFactor
    }
}

// MARK: Helpers
private extension PopupStackView.ViewModel {
    func getDragTranslationMultiplier() -> CGFloat { switch viewModel.alignment {
        case .top: 1
        case .bottom: -1
    }}
}
