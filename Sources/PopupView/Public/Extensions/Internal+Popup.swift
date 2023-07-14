//
//  File.swift
//  
//
//  Created by HMC7280885 on 2023/07/14.
//

import Foundation

internal extension Popup {
    func close() {
        TimerManager.shared.destroyTimer(id: id)
        DispatchQueue.main.async {
            self._onDismissCallback?()
        }
    }
}

internal extension Popup {
    func resetTimer() {
        guard _durationTime > 0 else { return }
        
        TimerManager.shared.createTimer(id: id)
            .set(timeInterval: _durationTime)
            .set(repeats: false)
            .set(action: self.timerComplete)
            .restart()
    }
    
    func active(_ isActive: Bool) {
        guard let timer = TimerManager.shared.getTimer(id: id) else { return }
        
        if isActive {
            timer.resume()
        } else {
            timer.pause()
        }
//        print("====> updateActive id: \(id), isActive: \(isActive)" )
    }
    
    func timerComplete(Timer: Timer?) {
        TimerManager.shared.destroyTimer(id: self.id)
        self.dismiss()
    }
}
