//
//  PopupCentreStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupCentreStackView: View {
    let items: [AnyPopup<CentrePopupConfig>]
    let globalConfig: GlobalConfig.Centre
    @ObservedObject private var screen: ScreenManager = .shared
    @State private var activeView: AnyView?
    @State private var configTemp: CentrePopupConfig?
    @State private var height: CGFloat?
    @State private var contentIsAnimated: Bool = false
    @State private var cacheCleanerTrigger: Bool = false

    
    var body: some View {
        createPopup()
            .frame(height: screen.size.height)
            .background(createTapArea())
            .animation(transitionAnimation, value: config.horizontalPadding)
            .animation(transitionAnimation, value: height)
            .animation(transitionAnimation, value: contentIsAnimated)
            .transition(getTransition())
            .onChange(of: items, perform: onItemsChange)
            .clearCacheObjects(shouldClear: items.isEmpty, trigger: $cacheCleanerTrigger)
    }
}

private extension PopupCentreStackView {
    func createPopup() -> some View {
        activeView?
            .readHeight(onChange: saveHeight)
            .frame(height: height).frame(maxWidth: .infinity)
            .opacity(contentOpacity)
            .background(backgroundColour, radius: cornerRadius, corners: .allCorners)
            .padding(.horizontal, config.horizontalPadding)
            .compositingGroup()
            .focusSectionIfAvailable()
    }
    func createTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismiss ?? {})
            .active(if: config.tapOutsideClosesView)
    }
}

// MARK: -Logic Handlers
private extension PopupCentreStackView {
    func onItemsChange(_ items: [AnyPopup<CentrePopupConfig>]) {
        handlePopupChange(items)
        notifyPopupChange(items)
    }
}
private extension PopupCentreStackView {
    func handlePopupChange(_ items: [AnyPopup<CentrePopupConfig>]) {
        guard let popup = items.last else { return handleClosingPopup() }

        showNewPopup(popup)
        animateContentIfNeeded()
    }
    func notifyPopupChange(_ items: [AnyPopup<CentrePopupConfig>]) { items.last?.configurePopup(popup: .init()).onFocus() }
}
private extension PopupCentreStackView {
    func showNewPopup(_ popup: AnyPopup<CentrePopupConfig>) { DispatchQueue.main.async {
        activeView = AnyView(popup.body)
        configTemp = popup.configurePopup(popup: .init())
    }}
    func animateContentIfNeeded() { if height != nil {
        contentIsAnimated = true
        DispatchQueue.main.asyncAfter(deadline: .now() + contentOpacityAnimationTime) { contentIsAnimated = false }
    }}
    func handleClosingPopup() { DispatchQueue.main.async {
        height = nil
        activeView = nil
    }}
}

// MARK: -View Handlers
private extension PopupCentreStackView {
    func saveHeight(_ value: CGFloat) { height = items.isEmpty ? nil : value }
    func getTransition() -> AnyTransition {
        .scale(scale: items.isEmpty ? globalConfig.transitionExitScale : globalConfig.transitionEntryScale)
        .combined(with: .opacity)
        .animation(height == nil || items.isEmpty ? transitionAnimation : nil)
    }
}

private extension PopupCentreStackView {
    var cornerRadius: CGFloat { config.cornerRadius ?? globalConfig.cornerRadius }
    var contentOpacity: CGFloat { contentIsAnimated ? 0 : 1 }
    var contentOpacityAnimationTime: CGFloat { globalConfig.contentAnimationTime }
    var backgroundColour: Color { config.backgroundColour ?? globalConfig.backgroundColour }
    var transitionAnimation: Animation { globalConfig.transitionAnimation }
    var config: CentrePopupConfig { items.last?.configurePopup(popup: .init()) ?? configTemp ?? .init() }
}
