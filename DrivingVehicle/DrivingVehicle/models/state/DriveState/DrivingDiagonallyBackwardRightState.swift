//
//  DrivingDiagonallyBackwardRightState.swift
//  DrivingVehicle
//

import Foundation

class DrivingDiagonallyBackwardRightState: VehicleStateProtocol {
    private let _status: VehicleStatus! = .DrivingDiagonallyBackwardRight
    
    func status() -> VehicleStatus{
        return _status
    }
    
    func abort(manager: VechicleStateManager, vehicle: VehicleTemplate) {
        manager.setState(StopMovingState())
        vehicle.stopDriving()
    }
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions){
        switch options.direction{
        case .Back:
            if(!options.doStart){
                manager.setState(RotatingRightState())
                vehicle.rotateRight()
            }
        case .Front:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardRightState())
                vehicle.driveDiagonallyForwardRight()
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions){
        switch options.direction{
        case .Right:
            if(!options.doStart){
                manager.setState(DrivingBackwardState())
                vehicle.driveBackward()
            }
        case .Left:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardLeftState())
                vehicle.driveDiagonallyBackwardLeft()
            }
        }
    }
}
