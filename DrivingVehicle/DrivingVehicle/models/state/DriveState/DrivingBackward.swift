//
//  DrivingBackward.swift
//  DrivingVehicle
//

import Foundation

class DrivingBackwardState: VehicleStateProtocol {
    private let _status: VehicleStatus! = .DrivingBackward
    
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
                manager.setState(StopMovingState())
                vehicle.stopDriving()
            }
        case .Front:
            if(options.doStart){
                manager.setState(DrivingForwardState())
                vehicle.driveForward()
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions){
        switch options.direction{
        case .Left:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardLeftState())
                vehicle.driveDiagonallyBackwardLeft()
            }
        case .Right:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardRightState())
                vehicle.driveDiagonallyBackwardRight()
            }
        }
    }
}
