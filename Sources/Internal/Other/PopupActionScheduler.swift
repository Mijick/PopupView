//
//  PopupActionScheduler.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

class PopupActionScheduler {
    private var secondsToDismiss: Double
    private var action: DispatchSourceTimer?

    init(secondsToDismiss: Double) { self.secondsToDismiss = secondsToDismiss }
}

extension PopupActionScheduler {
    func schedule(action: @escaping () -> ()) {
        self.action = DispatchSource.makeTimerSource(queue: .main)
        self.action?.schedule(deadline: .now() + max(0.6, secondsToDismiss))
        self.action?.setEventHandler(handler: action)
        self.action?.resume()
    }
}
