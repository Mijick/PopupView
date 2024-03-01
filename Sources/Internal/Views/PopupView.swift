//
//  PopupView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - iOS / macOS Implementation
#if os(iOS) || os(macOS)
struct PopupView: View {
    let globalConfig: GlobalConfig
    @State private var zIndex: ZIndex = .init()
    @State private var viewStack: ViewStack = .init()
    @ObservedObject private var popupManager: PopupManager = .shared
    @ObservedObject private var screenManager: ScreenManager = .shared


    var body: some View { createBody() }
}

// MARK: - tvOS Implementation
#elseif os(tvOS)
struct PopupView: View {
    let rootView: any View
    let globalConfig: GlobalConfig
    @ObservedObject private var popupManager: PopupManager = .shared
    @ObservedObject private var screenManager: ScreenManager = .shared


    var body: some View {
        AnyView(rootView)
            .disabled(!popupManager.views.isEmpty)
            .overlay(createBody())
    }
}
#endif


// MARK: - Common Part
private extension PopupView {
    func createBody() -> some View {
        createPopupStackView()
            .frame(height: screenManager.size.height)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(createOverlay())
            .onReceive(popupManager.$views, perform: onViewsCountChange)
    }
}

private extension PopupView {
    func createPopupStackView() -> some View {
        ZStack {
            createTopPopupStackView().zIndex(zIndex.top)
            createCentrePopupStackView().zIndex(zIndex.centre)
            createBottomPopupStackView().zIndex(zIndex.bottom)
        }
        .animation(stackAnimation, value: popupManager.views.map(\.id))
    }
    func createOverlay() -> some View {
        overlayColour
            .ignoresSafeArea()
            .active(if: isOverlayActive)
            .animation(overlayAnimation, value: isStackEmpty)
            .animation(overlayAnimation, value: shouldOverlayBeHiddenForCurrentPopup)
    }
}

private extension PopupView {
    func createTopPopupStackView() -> some View {
        PopupTopStackView(items: viewStack.top, globalConfig: globalConfig)
    }
    func createCentrePopupStackView() -> some View {
        PopupCentreStackView(items: viewStack.centre, globalConfig: globalConfig)
    }
    func createBottomPopupStackView() -> some View {
        PopupBottomStackView(items: $viewStack.bottom, globalConfig: globalConfig)
    }
}

private extension PopupView {
    func onViewsCountChange(_ views: Published<[Popup]>.Publisher.Output) {
        viewStack.update(views)
        zIndex.reshuffle(views.last)
    }
}

private extension PopupView {
    var isOverlayActive: Bool { !isStackEmpty && !shouldOverlayBeHiddenForCurrentPopup }
    var isStackEmpty: Bool { popupManager.views.isEmpty }
    var shouldOverlayBeHiddenForCurrentPopup: Bool { popupManager.popupsWithoutOverlay.contains(popupManager.views.last?.id ?? "") }
}

private extension PopupView {
    var stackAnimation: Animation { popupManager.presenting ? globalConfig.common.animation.entry : globalConfig.common.animation.removal }
    var overlayColour: Color { globalConfig.common.overlayColour }
    var overlayAnimation: Animation { .easeInOut(duration: 0.44) }
}


// MARK: - Counting zIndexes
// Purpose: To ensure that the stacks are displayed in the correct order
// Example: There are three bottom popups on the screen, and the user wants to display the centre one - to make sure they are displayed in the right order, we need to count the indexes; otherwise centre popup would be hidden by the bottom three.
extension PopupView { struct ZIndex {
    private var values: [Double] = [1, 1, 1]
}}
extension PopupView.ZIndex {
    mutating func reshuffle(_ lastPopup: (any Popup)?) { if let lastPopup {
        if lastPopup is AnyPopup<TopPopupConfig> { reshuffle(0) }
        else if lastPopup is AnyPopup<CentrePopupConfig> { reshuffle(1) }
        else if lastPopup is AnyPopup<BottomPopupConfig> { reshuffle(2) }
    }}
}
private extension PopupView.ZIndex {
    mutating func reshuffle(_ index: Int) { if values[index] != 3 {
        values.enumerated().forEach {
            values[$0.offset] = $0.offset == index ? 3 : max(1, $0.element - 1)
        }
    }}
}
private extension PopupView.ZIndex {
    var top: Double { values[0] }
    var centre: Double { values[1] }
    var bottom: Double { values[2] }
}




extension PopupView { struct ViewStack {
    var top: [AnyPopup<TopPopupConfig>] = []
    var centre: [AnyPopup<CentrePopupConfig>] = []
    var bottom: [AnyPopup<BottomPopupConfig>] = []
}}
extension PopupView.ViewStack {
    mutating func update(_ views: [any Popup]) {
        top = views.compactMap { $0 as? AnyPopup<TopPopupConfig> }
        centre = views.compactMap { $0 as? AnyPopup<CentrePopupConfig> }
        bottom = views.compactMap { $0 as? AnyPopup<BottomPopupConfig> }
    }
}
