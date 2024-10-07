//
//  Public+ConfigContainer.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


public extension ConfigContainer {
    func centre(_ builder: (GlobalConfig.Centre) -> GlobalConfig.Centre) -> ConfigContainer { Self.centre = builder(.init()); return self }
    func vertical(_ builder: (GlobalConfig.Vertical) -> GlobalConfig.Vertical) -> ConfigContainer { Self.vertical = builder(.init()); return self }
}
