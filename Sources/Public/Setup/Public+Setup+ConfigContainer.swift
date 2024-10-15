//
//  Public+Setup+ConfigContainer.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


public extension GlobalConfigContainer {
    /**
     Default configuration for all centre popups.
     Use the ``Popup/configurePopup(config:)-98ha0`` method to change the configuration for a specific popup.
     See the list of available methods in ``GlobalConfig``.
     */
    func centre(_ builder: (GlobalConfig.Centre) -> GlobalConfig.Centre) -> Self { Self.centre = builder(.init()); return self }

    /**
     Default configuration for all top and bottom popups.
     Use the ``Popup/configurePopup(config:)-98ha0`` method to change the configuration for a specific popup.
     See the list of available methods in ``GlobalConfig`` and ``GlobalConfig/Vertical``.
     */
    func vertical(_ builder: (GlobalConfig.Vertical) -> GlobalConfig.Vertical) -> Self { Self.vertical = builder(.init()); return self }
}
