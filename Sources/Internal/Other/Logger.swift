//
//  Logger.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import os

class Logger {
    static func log(level: OSLogType, message: String) {
        os.Logger().log(level: level, "ERROR!\n\nFRAMEWORK: MijickPopups\nDESCRIPTION: \(message)")
    }
}
