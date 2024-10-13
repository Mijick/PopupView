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
class ViewModel<Config: LocalConfig>: ViewModelObject {
    // MARK: Attributes
    private(set) var popups: [AnyPopup] = []
    private(set) var updatePopupAction: ((AnyPopup) -> ())!
    private(set) var closePopupAction: ((AnyPopup) -> ())!

    // MARK: Subclass Attributes
    var activePopupHeight: CGFloat? = nil
    var screen: Screen = .init()
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
        popups = newPopups.filter { $0.config is Config }
        activePopupHeight = calculateHeightForActivePopup()

        withAnimation(.transition) { objectWillChange.send() }
    }
    func updateScreenValue(_ newScreen: Screen) {
        screen = newScreen

        withAnimation(.transition) { objectWillChange.send() }
    }
    func updateKeyboardValue(_ isActive: Bool) {
        isKeyboardActive = isActive

        withAnimation(.transition) { objectWillChange.send() }
    }
}

// MARK: View Methods
extension ViewModel {
    func calculateZIndex() -> CGFloat {
        popups.last == nil ? 2137 : .init(popups.count)
    }
}

// MARK: Helpers
extension ViewModel {
    func updateHeight(_ newHeight: CGFloat, _ popup: AnyPopup) { if popup.height != newHeight {
        updatePopupAction(popup.settingHeight(newHeight))
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



// MARK: - TESTS
#if DEBUG



// MARK: Methods
extension ViewModel {
    func t_setup(updatePopupAction: @escaping (AnyPopup) -> (), closePopupAction: @escaping (AnyPopup) -> ()) { setup(updatePopupAction: updatePopupAction, closePopupAction: closePopupAction) }
    func t_updatePopupsValue(_ newPopups: [AnyPopup]) { updatePopupsValue(newPopups) }
    func t_updateScreenValue(_ newScreen: Screen) { updateScreenValue(newScreen) }
    func t_updateKeyboardValue(_ isActive: Bool) { updateKeyboardValue(isActive) }
    func t_updatePopup(_ popup: AnyPopup) { updatePopupAction(popup) }
    func t_calculateAndUpdateActivePopupHeight() { activePopupHeight = calculateHeightForActivePopup() }
}

// MARK: Variables
extension ViewModel {
    var t_popups: [AnyPopup] { popups }
    var t_activePopupHeight: CGFloat? { activePopupHeight }
}
#endif
