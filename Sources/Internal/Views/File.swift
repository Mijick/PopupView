//
//  File.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation


class Counter {
    static var callsCount: Int = 0


    static func increment() {
        callsCount += 1
        print(callsCount)
    }
}
