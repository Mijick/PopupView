//
//  Public+ConfigContainer+Setup.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


public extension GlobalConfigContainer {
    func centre(_ builder: (GlobalConfig.Centre) -> GlobalConfig.Centre) -> Self { Self.centre = builder(.init()); return self }
    func vertical(_ builder: (GlobalConfig.Vertical) -> GlobalConfig.Vertical) -> Self { Self.vertical = builder(.init()); return self }
}
