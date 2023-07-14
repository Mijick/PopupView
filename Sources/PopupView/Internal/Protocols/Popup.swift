//
//  Popup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol Popup: View {
    associatedtype Config: Configurable
    associatedtype V: View

    var id: String { get }
    
    var durationTime: Double { get set }
    var onDismiss: (() -> Void)? { get set }

    func createContent() -> V
    func configurePopup(popup: Config) -> Config
}
public extension Popup {
    var id: String { .init(describing: Self.self) }
    var body: V { createContent() }

    func configurePopup(popup: Config) -> Config { popup }
}

public extension Popup {
    mutating func setOnDismiss(_ callback: @escaping (() -> Void)) {
        self.onDismiss = callback
    }
}

public extension Popup {
    func resetTimer() {
        guard durationTime > 0 else { return }
        
        TimerManager.shared.createTimer(id: id)
            .set(timeInterval: durationTime)
            .set(repeats: false)
            .set(action: self.timerComplete)
            .restart()
    }
    
    func active(_ isActive: Bool) {
        print("===> updateActive id: \(id), isActive: \(isActive)" )
        let timer = TimerManager.shared.getTimer(id: id)
        isActive ? timer?.resume() : timer?.pause()
    }
    
    func timerComplete(Timer: Timer?) {
        TimerManager.shared.destroyTimer(id: self.id)
        PopupManager.performOperation(.remove(id: self.id))
//        self.dismiss(<#T##P#>)
    }
}
