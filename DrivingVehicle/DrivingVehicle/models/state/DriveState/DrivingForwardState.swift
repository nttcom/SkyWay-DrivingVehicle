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
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions, value: NSNumber){
        switch options.direction{
        case .Front:
            if(!options.doStart){
                manager.setState(StopMovingState())
                vehicle.stopDriving()
            }else{
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
                manager.setState(DrivingDiagonallyForwardLeftState())
                vehicle.driveDiagonallyForwardLeft(nil,radius: value)
            }
        case .Right:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardRightState())
                vehicle.driveDiagonallyForwardRight(nil,radius: value)
            }
        }
    }
}
