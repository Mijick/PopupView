//
//  Public+Utilities+Popup.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation

// MARK: Height Mode
public enum HeightMode {
    /**
     Popup height is calculated based on its content.

     ## Visualisation
     ![image](https://github.com/Mijick/Assets/blob/main/Framework%20Docs/Popups/height-mode-auto.png?raw=true)
     */
    case auto

    /**

     ## Visualisation
     ![image](https://github.com/Mijick/Assets/blob/main/Framework%20Docs/Popups/height-mode-large.png?raw=true)
     */
    case large

    /**
     
     ## Visualisation
     ![image](https://github.com/Mijick/Assets/blob/main/Framework%20Docs/Popups/height-mode-fullscreen.png?raw=true)
     */
    case fullscreen
}

// MARK: Drag Detent
public enum DragDetent {
    case fixed(CGFloat)
    case fraction(CGFloat)
    case large
    case fullscreen
}
