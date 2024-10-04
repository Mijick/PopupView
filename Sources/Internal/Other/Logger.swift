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
    static func log(if shouldLog: Bool, level: OSLogType, message: String) { if shouldLog {
        os.Logger().log(level: level, "ERROR!\n\nFRAMEWORK: MijickPopups\nDESCRIPTION: \(message)")
    }}
}
