//
//  Task++.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async {
        try! await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
