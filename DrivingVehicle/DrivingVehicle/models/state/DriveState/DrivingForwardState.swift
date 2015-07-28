//
//  DrivingForwardState.swift
//  DrivingVehicle
//

import Foundation

class DrivingForwardState: VehicleStateProtocol {
    private let _status: VehicleStatus! = .DrivingForward
    
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
            if(!options.doStart){
                manager.setState(StopMovingState())
                vehicle.stopDriving()
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingBackwardState())
                vehicle.driveBackward()
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions){
        switch options.direction{
        case .Left:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardLeftState())
                vehicle.driveDiagonallyForwardLeft()
            }
        case .Right:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardRightState())
                vehicle.driveDiagonallyForwardRight()
            }
        }
    }
}
