//
//  MotionManager.swift
//  kkeokkEulTime
//
//  Created by 남유성 on 6/14/24.
//

import Foundation
import CoreMotion

enum WristMotion {
    case rolled
    case none
    case unFolded
}

enum ActionType {
    case all
    case nextLevel
    case getOut
    case cutter
    case shake
    case woiWoi
}

@Observable
class MotionManager {
    static let shared = MotionManager()
    private init() {
        _motionManager.deviceMotionUpdateInterval = 0.1
        _motionManager.showsDeviceMovementDisplay = true
    }
    
    var rollData: [Double] = []
    var pitchData: [Double] = []
    var yawData: [Double] = []
    
    var isShacking: Bool = false
    var isNextLevel: Bool = false
    var isGetOut: Bool = false
    var isWoiWoi: Bool = false
    var isCutter: Bool = false
    
    @ObservationIgnored var dataCounts: Int { _dataCounts }
    @ObservationIgnored private let _dataCounts: Int = 100
    @ObservationIgnored private let _motionManager = CMMotionManager()
}

extension MotionManager {
    func startUpdates() {
        if _motionManager.isDeviceMotionAvailable {
            _motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                guard let self = self, let motion = motion else { return }
                
                let roll = motion.attitude.roll
                let pitch = motion.attitude.pitch
                let yaw = motion.attitude.yaw
                
                let accelerationMagnitude = sqrt(motion.userAcceleration.x.square() + motion.userAcceleration.y.square() + motion.userAcceleration.z.square())
                
                self.rollData.append(roll)
                self.pitchData.append(pitch)
                self.yawData.append(yaw)
                
                // MARK: - 1. 워이워이
                self.isWoiWoi = roll.toPositive() > 8
                
                // MARK: - 2. 썰어버려
                self.isCutter = pitch < 0.7
                
                // MARK: - 3. 나가주세요
                self.isGetOut = pitch < 0.2
                
                // MARK: - 4. 노려보자 카리나
                self.isNextLevel = abs(abs(pitch) - abs(roll)) < 0.1
                
                // MARK: - 5. 털어
                self.isShacking = accelerationMagnitude > 1
                
                if self.rollData.count > _dataCounts {
                    self.rollData.removeFirst()
                    self.pitchData.removeFirst()
                    self.yawData.removeFirst()
                }
            }
        }
    }
    
    func stopUpdates() {
        _motionManager.stopDeviceMotionUpdates()
    }
    
    func isDetected(type: ActionType) -> Bool {
        switch type {
        case .nextLevel:
            return isNextLevel
        case .getOut:
            return isGetOut
        case .cutter:
            return isCutter
        case .shake:
            return isShacking
        case .woiWoi:
            return isWoiWoi
        default:
            return false
        }
    }
}
