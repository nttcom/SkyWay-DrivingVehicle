//
//  StopMovingState.swift
//  DrivingVehicle
//

import Foundation


class StopMovingState: VehicleStateProtocol {
    private let _status: VehicleStatus! = .StopMoving
    
    func status() -> VehicleStatus{
        return _status
    }
    
    func abort(manager: VechicleStateManager, vehicle: VehicleTemplate) {
        return
    }
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions, value: NSNumber){
        switch options.direction{
        case .Front:
            if(options.doStart){
                manager.setState(DrivingForwardState())
                vehicle.driveForward(value)
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingBackwardState())
                vehicle.driveBackward(value)
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions, value: NSNumber){
        switch options.direction{
        case .Left:
            if(options.doStart){
                manager.setState(RotatingLeftState())
                vehicle.rotateLeft(value)
            }
        case .Right:
            if(options.doStart){
                manager.setState(RotatingRightState())
                vehicle.rotateRight(value)
            }
        }
    }
}


