//
//  Public+Popup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Presenting
public extension Popup {
    /// Displays the popup. Stacks previous one
    @discardableResult func showAndStack() -> some Popup { PopupManager.showAndStack(AnyPopup<Config>(self)); return self }

    /// Displays the popup. Closes previous one
    @discardableResult func showAndReplace() -> some Popup { PopupManager.showAndReplace(AnyPopup<Config>(self)); return self }
}

// MARK: - Modifiers
public extension Popup {
    /// Closes popup after n seconds
    @discardableResult func dismissAfter(_ seconds: Double) -> some Popup {
        let action = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        action.schedule(deadline: .now() + max(0.5, seconds))
        action.setEventHandler { PopupManager.dismiss(Self.self) }
        action.resume()



        PopupManager.shared.dq[id] = action
        return self
    }

    /// Hides the overlay for the selected popup
    @discardableResult func hideOverlay() -> some Popup { PopupManager.hideOverlay(self); return self }
}

// MARK: - Available Popups
public protocol TopPopup: Popup { associatedtype Config = TopPopupConfig }
public protocol CentrePopup: Popup { associatedtype Config = CentrePopupConfig }
public protocol BottomPopup: Popup { associatedtype Config = BottomPopupConfig }
