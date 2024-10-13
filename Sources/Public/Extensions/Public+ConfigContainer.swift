//
//  Public+ConfigContainer.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


public extension ConfigContainer {
    func centre(_ builder: (GlobalConfig.Centre) -> GlobalConfig.Centre) -> ConfigContainer { Self.centre = builder(.init()); return self }
    func vertical(_ builder: (GlobalConfig.Vertical) -> GlobalConfig.Vertical) -> ConfigContainer { Self.vertical = builder(.init()); return self }
}
