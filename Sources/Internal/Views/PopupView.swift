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
#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
struct PopupView: View {
    @State private var zIndex: ZIndex = .init()
    @ObservedObject private var popupManager: PopupManager = .shared


    var body: some View { createBody() }
}

// MARK: - tvOS Implementation
#elseif os(tvOS)
struct PopupView: View {
    let rootView: any View
    @State private var zIndex: ZIndex = .init()
    @ObservedObject private var popupManager: PopupManager = .shared


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
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .animation(.transition, value: popupManager.views)
            .onChange(popupManager.views.count, completion: onViewsCountChange)
    }
}

private extension PopupView {
    func createPopupStackView() -> some View {
        ZStack {
            createTopPopupStackView()
            createCentrePopupStackView()
            createBottomPopupStackView()
        }
    }
}

private extension PopupView {
    func createTopPopupStackView() -> some View {
        PopupStackView(items: getViews(TopPopupConfig.self), edge: .top)
            .addOverlay(overlayColour, isOverlayActive(TopPopupConfig.self))
            .zIndex(zIndex.top)
    }
    func createCentrePopupStackView() -> some View {
        PopupCentreStackView(items: getViews(CentrePopupConfig.self))
            .addOverlay(overlayColour, isOverlayActive(CentrePopupConfig.self))
            .zIndex(zIndex.centre)
    }
    func createBottomPopupStackView() -> some View {
        PopupStackView(items: getViews(BottomPopupConfig.self), edge: .bottom)
            .addOverlay(overlayColour, isOverlayActive(BottomPopupConfig.self))
            .zIndex(zIndex.bottom)
    }
}
private extension PopupView {
    func getViews<C: Configurable>(_ type: C.Type) -> Binding<[AnyPopup]> { .init(
        get: { popupManager.views.filter { $0.config is C } },
        set: { $0.forEach { item in if let index = popupManager.views.firstIndex(of: item) { popupManager.views[index] = item }}}
    )}
}

private extension PopupView {
    func onViewsCountChange(_ count: Int) {
        zIndex.reshuffle(popupManager.views.last?.config)
    }
}

private extension PopupView {
    func isOverlayActive<C: Configurable>(_ type: C.Type) -> Bool { popupManager.views.last?.config is C && !shouldOverlayBeHiddenForCurrentPopup }
}
private extension PopupView {
    var shouldOverlayBeHiddenForCurrentPopup: Bool { popupManager.views.last?.isOverlayHidden ?? false }
}

private extension PopupView {
    var overlayColour: Color { globalConfig.common.overlayColour }
}


// MARK: - Counting zIndexes
// Purpose: To ensure that the stacks are displayed in the correct order
// Example: There are three bottom popups on the screen, and the user wants to display the centre one - to make sure they are displayed in the right order, we need to count the indexes; otherwise centre popup would be hidden by the bottom three.
extension PopupView { struct ZIndex {
    private var values: [Double] = [1, 1, 1]
}}
extension PopupView.ZIndex {
    mutating func reshuffle(_ lastConfig: (any Configurable)?) { if let lastConfig {
        if lastConfig is TopPopupConfig { reshuffle(0) }
        else if lastConfig is CentrePopupConfig { reshuffle(1) }
        else if lastConfig is BottomPopupConfig { reshuffle(2) }
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


// MARK: - Helpers
fileprivate extension View {
    func addOverlay(_ colour: Color, _ active: Bool) -> some View { ZStack {
        colour.active(if: active)
        self
    }}
}
