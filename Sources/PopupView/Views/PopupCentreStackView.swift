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
    @State private var height: CGFloat?


    @State private var ac: AnyView?
    @State private var configTemp: CentrePopupConfig?

    @State private var aaaChang: Bool = false


    var body: some View {
        createPopup()
            .frame(width: UIScreen.width, height: UIScreen.height)
            .background(createTapArea())
            .animation(transitionAnimation, value: height)
            .animation(transitionAnimation, value: aaaChang)
            .transition(
                .scale(scale: items.isEmpty ? 0.86 : 1.1).combined(with: .opacity).animation(height == nil || items.isEmpty ? transitionAnimation : nil)
            )
            .onChange(of: items, perform: onItemsChange)
    }
}

private extension PopupCentreStackView {
    func createPopup() -> some View {
        ac?
            .readHeight(onChange: saveHeight(_:))
            .frame(width: width, height: height)
            .opacity(aaaChang ? 0 : 1)
            .background(backgroundColour)
            .cornerRadius(cornerRadius)
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
        if items.isEmpty {
            height = nil
            ac = nil

        } else {
            DispatchQueue.main.async {
                ac = AnyView(items.last!.body)
                configTemp = items.last!.configurePopup(popup: .init())
            }







            guard height != nil else {  return}

            aaaChang = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { aaaChang = false }
        }
    }
}

// MARK: -View Handlers
private extension PopupCentreStackView {
    func saveHeight(_ value: CGFloat) { height = items.isEmpty ? nil : value }
}

private extension PopupCentreStackView {
    var width: CGFloat { max(0, UIScreen.width - config.horizontalPadding * 2) }
    var cornerRadius: CGFloat { config.cornerRadius }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var config: CentrePopupConfig { items.last?.configurePopup(popup: .init()) ?? configTemp ?? .init() }
}
