//
//  ConfigContainer.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


public extension ConfigContainer {
    func vertical(_ configure: (GlobalConfig.Vertical) -> GlobalConfig.Vertical) -> ConfigContainer { self.vertical = configure(.init()); return self }
    func centre(_ configure: (GlobalConfig.Centre) -> GlobalConfig.Centre) -> ConfigContainer { self.centre = configure(.init()); return self }
}


// MARK: - Internal
public class ConfigContainer {
    var vertical: GlobalConfig.Vertical = .init()
    var centre: GlobalConfig.Centre = .init()
}
