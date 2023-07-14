//
//  WeakTimer.swift
//  Groupware
//
//  Created by HMC7280885 on 2023/07/10.
//  Copyright © 2023 com.hmg. All rights reserved.
//

import Foundation

extension WeakTimer {
    public class func scheduledTimer(timeInterval: TimeInterval,
                                     repeats: Bool = false,
                                     action: @escaping (Timer) -> Void) -> WeakTimer {
        return WeakTimer(timeInterval: timeInterval,
                         repeats: repeats,
                         action: action)
    }
}

public final class WeakTimer {
    private weak var timer: Timer?
    private var action: (Timer) -> Void
    private var timeInterval: TimeInterval = 0
    private var repeats: Bool = false
    
    private var startTime: TimeInterval?
    private var pauseTime: TimeInterval?
    
    public var isPause: Bool {
        self.pauseTime != nil
    }
    
    deinit {
//        print("====> deinit WeakTimer ==========")
    }
    
    private init(timeInterval: TimeInterval,
                 repeats: Bool = false,
                 action: @escaping (Timer) -> Void) {
        self.timeInterval = timeInterval
        self.repeats = repeats
        self.action = action
        
        self.stop()
    }
}

extension WeakTimer {
    @discardableResult
    public func start() -> Self {
        self.startTime = Date.timeIntervalSinceReferenceDate
        self.runTimer(interval: timeInterval)
        return self
    }
    
    @discardableResult
    public func stop() -> Self {
        self.pauseTime = nil
        self.timer?.invalidate()
        return self
    }
    
    @discardableResult
    public func pause() -> Self {
        self.timer?.invalidate()
        
        guard !self.isPause else { return self }
        
        self.pauseTime = Date.timeIntervalSinceReferenceDate
        return self
    }
    
    @discardableResult
    public func resume() -> Self {
        guard let startTime = startTime, let pauseTime = pauseTime else { return self }
        
        let startInterval = timeInterval - (pauseTime - startTime)
        self.pauseTime = nil
        self.runTimer(interval: startInterval)
        return self
    }
    
    @discardableResult
    public func restart() -> Self {
        stop()
        start()
        return self
    }
    
    public func destroyTimer() {
        stop()
        timer = nil
    }
    
    private func runTimer(interval: TimeInterval) {
        self.timer = Timer.scheduledTimer(timeInterval: interval,
                                          target: self,
                                          selector: #selector(completion),
                                          userInfo: nil,
                                          repeats: repeats)
    }
}

extension WeakTimer {
    @discardableResult
    public func set(timeInterval: Double) -> Self {
        self.timeInterval = timeInterval
        return self
    }
    
    @discardableResult
    public func set(repeats: Bool) -> Self {
        self.repeats = repeats
        return self
    }
    
    @discardableResult
    public func set(action: @escaping (Timer) -> Void) -> Self {
        self.action = action
        return self
    }
}

extension WeakTimer {
    @objc private func completion(timer: Timer) {
        self.action(timer)
        if !self.repeats {
            stop()
        }
    }
}
