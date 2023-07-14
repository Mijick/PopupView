//
//  TimerManager.swift
//  
//
//  Created by HMC7280885 on 2023/07/11.
//

import Foundation

public class TimerManager: ObservableObject {
    private(set) var timerDic: [String: WeakTimer] = [:]

    static let shared: TimerManager = .init()
    private init() {}
    
    public func createTimer(id: String) -> WeakTimer {
        let timer = timerDic[id] ?? WeakTimer.scheduledTimer(timeInterval: 0, action: { _ in })
        timerDic[id] = timer
        print("======> TimerManager create count:\(timerDic.count) id: \(id)")
        return timer
    }
    
    public func getTimer(id: String) -> WeakTimer? {
        timerDic[id]
    }
    
    @discardableResult
    public func deleteTimer(id: String) -> WeakTimer? {
        return destroyTimer(id: id)
    }
    
    @discardableResult
    public func destroyTimer(id: String) -> WeakTimer? {
        let timer = timerDic[id]
        timerDic[id]?.destroyTimer()
        timerDic.removeValue(forKey: id)
        print("======> TimerManager destroy count:\(timerDic.count) id: \(id), timer:\(timer)")
        return timer
    }
}
