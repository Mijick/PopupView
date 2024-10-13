//
//  Logger.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import os

class Logger {
    static func log(level: OSLogType, message: String) {
        os.Logger().log(level: level, "ERROR!\n\nFRAMEWORK: MijickPopups\nDESCRIPTION: \(message)")
    }
}
