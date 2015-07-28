//
//  DrivingDiagonallyForwardRightState.swift
//  DrivingVehicle
//

import Foundation

class DrivingDiagonallyForwardRightState: VehicleStateProtocol {
    private let _status: VehicleStatus! = .DrivingDiagonallyForwardRight
    
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
                manager.setState(RotatingRightState())
                vehicle.rotateRight()
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardRightState())
                vehicle.driveDiagonallyBackwardRight()
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions){
        switch options.direction{
        case .Right:
            if(!options.doStart){
                manager.setState(DrivingForwardState())
                vehicle.driveForward()
            }
        case .Left:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardLeftState())
                vehicle.driveDiagonallyForwardLeft()
            }
        }
    }
}
