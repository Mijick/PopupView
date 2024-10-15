//
//  Public+Main+Popup.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

/**
Blablabla

 # Available


 ### TopPopup
 ![TopPopup](https://github.com/Mijick/Assets/blob/main/Framework%20Docs/Popups/enable-drag-gesture.png?raw=true)

 ### CentrePopup
 ![CentrePopup](https://github.com/Mijick/Assets/blob/main/Framework%20Docs/Popups/enable-drag-gesture.png?raw=true)

 ### BottomPopup
 ![BottomPopup](https://github.com/Mijick/Assets/blob/main/Framework%20Docs/Popups/enable-drag-gesture.png?raw=true)
 */
public protocol Popup: View {
    associatedtype Config: LocalConfig

    func configurePopup(config: Config) -> Config
    func onFocus()
    func onDismiss()
}

// MARK: Default Methods Implementation
public extension Popup {
    func configurePopup(config: Config) -> Config { config }
    func onFocus() {}
    func onDismiss() {}
}

// MARK: Available Types
public protocol TopPopup: Popup { associatedtype Config = TopPopupConfig }
public protocol CentrePopup: Popup { associatedtype Config = CentrePopupConfig }
public protocol BottomPopup: Popup { associatedtype Config = BottomPopupConfig }
