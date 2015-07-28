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
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions){
        switch options.direction{
        case .Front:
            if(options.doStart){
                manager.setState(DrivingForwardState())
                vehicle.driveForward()
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingBackwardState())
                vehicle.driveBackward()
            }
        default:
            return
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions){
        switch options.direction{
        case .Left:
            if(options.doStart){
                manager.setState(RotatingLeftState())
                vehicle.rotateLeft()
            }
        case .Right:
            if(options.doStart){
                manager.setState(RotatingRightState())
                vehicle.rotateRight()
            }
        default:
            return
        }
    }
}


