//
//  RotatingLeftState.swift
//  DrivingVehicle
//

import Foundation

class RotatingLeftState: VehicleStateProtocol {
    private let _status: VehicleStatus! = .RotatingLeft
    
    func status() -> VehicleStatus{
        return _status
    }
    
    func abort(manager: VechicleStateManager, vehicle: VehicleTemplate) {
        manager.setState(StopMovingState())
        vehicle.stopDriving()
    }
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions){
        switch options.direction{
        case .Front:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardLeftState())
                vehicle.driveDiagonallyForwardLeft()
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardLeftState())
                vehicle.driveDiagonallyBackwardLeft()
            }
        default:
            return
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions){
        switch options.direction{
        case .Left:
            if(!options.doStart){
                manager.setState(StopMovingState())
                vehicle.stopDriving()
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
