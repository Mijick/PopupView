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


    public init(@ViewBuilder _ builder: () -> some View) { self.sourceView = builder() }
    public var body: some View {
        ZStack {
            createSourceView()
            createOverlay()
            createPopupStackView()
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
        PopupBottomStackView(items: stack.bottom, closingAction: stack.dismiss)
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




public protocol BottomPopup: PopupProtocolMain {
    func configurePopup(content: PopupBottomStackView.Config) -> PopupBottomStackView.Config
}
public extension BottomPopup {
    // inna nazwa na config



    //var config: PopupBottomStackView.Config { .init() }

    func present() { PopupStackManager.shared.present(AnyBottomPopup(self)) }
}



public protocol CentrePopup: PopupProtocolMain {}
public extension CentrePopup {
    var config: PopupCentreStackView.Config { .init() }

    func present() { PopupStackManager.shared.present(AnyCentrePopup(self)) }
}



public protocol TopPopup: PopupProtocolMain{}
public extension TopPopup {
    var config: PopupTopStackView.Config { .init() }

    func present() { PopupStackManager.shared.present(AnyTopPopup(self)) }
}





class PopupStackManager: ObservableObject {
    @Published private var views: [any PopupProtocolMain] = []

    static let shared: PopupStackManager = .init()
    private init() {}
}

extension PopupStackManager {
    var top: [AnyTopPopup] {
        views.compactMap { $0 as? AnyTopPopup }
    }
    var centre: [AnyCentrePopup] {
        views.compactMap { $0 as? AnyCentrePopup }
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
