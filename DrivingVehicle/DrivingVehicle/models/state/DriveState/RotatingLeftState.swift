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
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions, value: NSNumber){
        switch options.direction{
        case .Front:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardLeftState())
                vehicle.driveDiagonallyForwardLeft(value,radius: nil)
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardLeftState())
                vehicle.driveDiagonallyBackwardLeft(value,radius: nil)
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions, value: NSNumber){
        switch options.direction{
        case .Left:
            if(!options.doStart){
                manager.setState(StopMovingState())
                vehicle.stopDriving()
            }else{
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
