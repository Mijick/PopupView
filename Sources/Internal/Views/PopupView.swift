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
    @ObservedObject private var popupManager: PopupManager = .shared


    var body: some View { createBody() }
}

// MARK: - tvOS Implementation
#elseif os(tvOS)
struct PopupView: View {
    let rootView: any View
    let globalConfig: GlobalConfig
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
            .animation(stackAnimation, value: popupManager.views.map(\.id))
            .onChange(of: popupManager.views.count, perform: onViewsCountChange)
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
        PopupTopStackView(items: getViews(AnyPopup<TopPopupConfig>.self), globalConfig: globalConfig)
            .addOverlay(overlayColour, isOverlayActive(AnyPopup<TopPopupConfig>.self))
            .zIndex(zIndex.zIndex[.top]!)
    }
    func createCentrePopupStackView() -> some View {
        PopupCentreStackView(items: getViews(AnyPopup<CentrePopupConfig>.self), globalConfig: globalConfig)
            .addOverlay(overlayColour, isOverlayActive(AnyPopup<CentrePopupConfig>.self))
            .zIndex(zIndex.zIndex[.centre]!)
    }
    func createBottomPopupStackView() -> some View {
        PopupBottomStackView(items: getViews(AnyPopup<BottomPopupConfig>.self), globalConfig: globalConfig)
            .addOverlay(overlayColour, isOverlayActive(AnyPopup<BottomPopupConfig>.self))
            .zIndex(zIndex.zIndex[.bottom]!)
    }
}
private extension PopupView {
    func getViews<T: Popup>(_ type: T.Type) -> [T] { popupManager.views.compactMap { $0 as? T } }
}

private extension PopupView {
    // jeszcze uwzględnić 3.5
    func onViewsCountChange(_ count: Int) { DispatchQueue.main.asyncAfter(deadline: .now() + (!popupManager.presenting && zIndex.zIndex[.centre]?.truncatingRemainder(dividingBy: 1) != 0 && zIndex.zIndex[.centre]?.truncatingRemainder(dividingBy: 0.5) == 0 ? 0.4 : 0)) {
        zIndex.reshuffle(popupManager.views.last)
    }}
}

private extension PopupView {
    func isOverlayActive<P: Popup>(_ type: P.Type) -> Bool { popupManager.views.last is P && !shouldOverlayBeHiddenForCurrentPopup }
}
private extension PopupView {
    var shouldOverlayBeHiddenForCurrentPopup: Bool { popupManager.popupsWithoutOverlay.contains(popupManager.views.last?.id ?? "") }
}

private extension PopupView {
    var stackAnimation: Animation { popupManager.presenting ? globalConfig.common.animation.entry : globalConfig.common.animation.removal }
    var overlayColour: Color { globalConfig.common.overlayColour }
}


// MARK: - Counting zIndexes
// Purpose: To ensure that the stacks are displayed in the correct order
// Example: There are three bottom popups on the screen, and the user wants to display the centre one - to make sure they are displayed in the right order, we need to count the indexes; otherwise centre popup would be hidden by the bottom three.
extension PopupView { struct ZIndex {
    private(set) var zIndex: [T: Double] = [.bottom: 1, .centre: 1, .top: 1]





    enum T { case top, centre, bottom }



}}
extension PopupView.ZIndex {
    mutating func reshuffle(_ lastPopup: (any Popup)?) { if let lastPopup {
        if let topPopup = lastPopup as? AnyPopup<TopPopupConfig> {
            let priority = topPopup.configurePopup(popup: .init()).priority
            reshuffle(.top, priority)
        }
        else if let centrePopup = lastPopup as? AnyPopup<CentrePopupConfig> {
            let priority = centrePopup.configurePopup(popup: .init()).priority
            reshuffle(.centre, priority)
        }
        else if let bottomPopup = lastPopup as? AnyPopup<BottomPopupConfig> {
            let priority = bottomPopup.configurePopup(popup: .init()).priority
            reshuffle(.bottom, priority)
        }
    }}
}
private extension PopupView.ZIndex {
    mutating func reshuffle(_ t: T, _ priority: Priority) {
        var newIndexes = zIndex.reduce(into: [:]) {

            $0[$1.key] =
                $1.value.truncatingRemainder(dividingBy: 1) == 0 ? $1.value
            :   $1.value.truncatingRemainder(dividingBy: 0.5) == 0 ? $1.value - 0.25
            :   $1.value - 0.0001


            // problem jest taki, że zamyka poprzedni popup jeśli jest zasłonięty

        }
        newIndexes[t] = priority.getIndex()
        zIndex = newIndexes
    }
}



fileprivate extension Priority {
    func getIndex() -> Double { switch self {
        case .lowest: 1.5
        case .normal: 2.5
        case .highest: 3.5
    }}
}




// MARK: - Helpers
fileprivate extension View {
    func addOverlay(_ colour: Color, _ active: Bool) -> some View { ZStack {
        colour.active(if: active)
        self
    }}
}

















public enum Priority: Double {
    case lowest
    case normal
    case highest
}
