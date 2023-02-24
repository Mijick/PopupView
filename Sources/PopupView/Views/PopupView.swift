//
//  File.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public struct PopupView: View {
    let sourceView: any View
    @StateObject private var stack: PopupStackManager = .shared


    public var body: some View {
        ZStack {
            createSourceView()
            createPopupStackView()
            createOverlay()
        }
    }
}

private extension PopupView {
    func createSourceView() -> some View {
        AnyView(sourceView)
    }
    func createPopupStackView() -> some View {
        ZStack {
            createTopPopupStackView()
            createCentrePopupStackView()
            createBottomPopupStackView()
        }
        .frame(width: UIScreen.width, height: UIScreen.height)
        // frame
    }
    func createOverlay() -> some View {
        Color.black.opacity(0.44)
            .ignoresSafeArea()

        // ignore
    }
}

private extension PopupView {
    func createTopPopupStackView() -> some View {
        EmptyView()
    }
    func createCentrePopupStackView() -> some View {
        EmptyView()
    }
    func createBottomPopupStackView() -> some View {
        PopupBottomStackView(items: stack.bottom, closingAction: stack.dismiss) { a in
            a.horizontalPadding = 4
        }
    }
}

private extension PopupView {

}

private extension PopupView {

}

private extension PopupView {

}





public protocol PopupProtocolMain: View, Identifiable, Hashable, Equatable {
    var id: String { get }
}
public extension PopupProtocolMain {
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }


}




public protocol BottomPopup: PopupProtocolMain {}
public extension BottomPopup {
    var config: PopupBottomStackView.Config { .init() }

    func present() { PopupStackManager.shared.present(AnyBottomPopup(self)) }
}



protocol CentrePopup: PopupProtocolMain {}
extension CentrePopup {
    var config: PopupCentreStackView.Config { .init() }
}



protocol TopPopup: PopupProtocolMain{}
extension TopPopup {
    var config: PopupTopStackView.Config { .init() }
}





class PopupStackManager: ObservableObject {
    @Published private var views: [any PopupProtocolMain] = []

    static let shared: PopupStackManager = .init()
    private init() {}
}

extension PopupStackManager {
    var top: [any TopPopup] {
        views.compactMap { $0 as? (any TopPopup) }
    }
    var centre: [any CentrePopup] {
        views.compactMap { $0 as? (any CentrePopup) }
    }
    var bottom: [AnyBottomPopup] {
        views.compactMap { $0 as? AnyBottomPopup }
    }
}

extension PopupStackManager {
    func present(_ popup: some PopupProtocolMain) {
        views.append(popup, if: canBeInserted(popup))
    }
    func dismiss() {
        views.removeLast()
    }
}

extension PopupStackManager {
    func canBeInserted(_ popup: some PopupProtocolMain) -> Bool { !views.contains(where: { $0.id == popup.id }) }
    func canBeDismissed() -> Bool { !views.isEmpty }
}







extension Array {
    @inlinable mutating func append(_ newElement: Element, if prerequisite: Bool) {
        if prerequisite { append(newElement) }
    }
    @inlinable mutating func removeLast() {
        if !isEmpty { removeLast(1) }
    }
}
