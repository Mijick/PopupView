//
//  ViewModel.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

enum VM {}
class ViewModel<Config: LocalConfig>: ObservableObject {
    // MARK: Attributes
    private(set) var allPopups: [AnyPopup] = []
    private(set) var popups: [AnyPopup] = []
    private(set) var updatePopupAction: ((AnyPopup) -> ())!
    private(set) var closePopupAction: ((AnyPopup) -> ())!

    // MARK: Subclass Attributes
    var activePopupHeight: CGFloat? = nil
    var screen: ScreenProperties = .init()
    var isKeyboardActive: Bool = false

    // MARK: Methods to Override
    func recalculateAndSave(height: CGFloat, for popup: AnyPopup) { fatalError() }
    func calculateHeightForActivePopup() -> CGFloat? { fatalError() }
    func calculatePopupPadding() -> EdgeInsets { fatalError() }
    func calculateCornerRadius() -> [VerticalEdge: CGFloat] { fatalError() }
    func calculateVerticalFixedSize(for popup: AnyPopup) -> Bool { fatalError() }
}

// MARK: Setup
extension ViewModel {
    func setup(updatePopupAction: @escaping (AnyPopup) -> (), closePopupAction: @escaping (AnyPopup) -> ()) {
        self.updatePopupAction = updatePopupAction
        self.closePopupAction = closePopupAction
    }
}

// MARK: Update
extension ViewModel {
    func updatePopupsValue(_ newPopups: [AnyPopup]) {
        allPopups = newPopups
        popups = newPopups.filter { $0.config is Config }
        activePopupHeight = calculateHeightForActivePopup()

        Task { @MainActor in withAnimation(.transition) { objectWillChange.send() }}
    }
    func updateScreenValue(_ newScreen: ScreenProperties) {
        screen = newScreen

        Task { @MainActor in withAnimation(.transition) { objectWillChange.send() }}
    }
    func updateKeyboardValue(_ isActive: Bool) {
        isKeyboardActive = isActive

        Task { @MainActor in withAnimation(.transition) { objectWillChange.send() }}
    }
    func updatePopup(_ popup: AnyPopup, by popupUpdateBuilder: @escaping (inout AnyPopup) -> ()) {
        var popup = popup
        popupUpdateBuilder(&popup)

        Task { @MainActor in updatePopupAction(popup) }
    }
}

// MARK: View Methods
extension ViewModel {
    func calculateZIndex(for popup: AnyPopup?) -> CGFloat {
        guard let popup,
              let index = allPopups.firstIndex(of: popup)
        else { return 2137 }

        return .init(index + 2)
    }
}

// MARK: Helpers
extension ViewModel {
    func updateHeight(_ newHeight: CGFloat, _ popup: AnyPopup) { if popup.height != newHeight {
        updatePopup(popup) { $0.height = newHeight }
    }}
}
extension ViewModel {
    func getConfig(_ item: AnyPopup?) -> Config {
        let config = item?.config as? Config
        return config ?? .init()
    }
    func getActivePopupConfig() -> Config {
        getConfig(popups.last)
    }
}



// MARK: - TESTING
#if DEBUG



// MARK: Methods
extension ViewModel {
    @MainActor func t_setup(updatePopupAction: @escaping (AnyPopup) -> (), closePopupAction: @escaping (AnyPopup) -> ()) { setup(updatePopupAction: updatePopupAction, closePopupAction: closePopupAction) }
    @MainActor func t_updatePopupsValue(_ newPopups: [AnyPopup]) { updatePopupsValue(newPopups) }
    @MainActor func t_updateScreenValue(_ newScreen: ScreenProperties) { updateScreenValue(newScreen) }
    @MainActor func t_updateKeyboardValue(_ isActive: Bool) { updateKeyboardValue(isActive) }
    @MainActor func t_updatePopup(_ popup: AnyPopup, by popupUpdateBuilder: @escaping (inout AnyPopup) -> ()) { updatePopup(popup, by: popupUpdateBuilder) }
    @MainActor func t_calculateAndUpdateActivePopupHeight() { activePopupHeight = calculateHeightForActivePopup() }
}

// MARK: Variables
extension ViewModel {
    @MainActor var t_activePopupHeight: CGFloat? { activePopupHeight }
}
#endif
