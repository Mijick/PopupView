//
//  GlobalConfig.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


public struct GlobalConfig {
    let top: Top
    let centre: Centre
    let bottom: Bottom


    init(_ topConfigBuilder: (Top) -> Top, _ centreConfigBuilder: (Centre) -> Centre, _ bottomConfigBuilder: (Bottom) -> Bottom) {
        self.top = topConfigBuilder(.init())
        self.centre = centreConfigBuilder(.init())
        self.bottom = bottomConfigBuilder(.init())
    }
}
