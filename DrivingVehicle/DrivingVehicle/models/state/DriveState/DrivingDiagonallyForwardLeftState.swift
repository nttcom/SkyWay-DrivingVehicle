//
//  DrivingDiagonallyForwardLeftState.swift
//  DrivingVehicle
//

import Foundation

class DrivingDiagonallyForwardLeftState: VehicleStateProtocol {
    private let _status: VehicleStatus! = .DrivingDiagonallyForwardLeft
    
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
                manager.setState(RotatingLeftState())
                vehicle.rotateLeft()
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardLeftState())
                vehicle.driveDiagonallyBackwardLeft()
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions){
        switch options.direction{
        case .Left:
            if(!options.doStart){
                manager.setState(DrivingForwardState())
                vehicle.driveForward()
            }
        case .Right:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardRightState())
                vehicle.driveDiagonallyForwardRight()
            }
        }
    }
}

