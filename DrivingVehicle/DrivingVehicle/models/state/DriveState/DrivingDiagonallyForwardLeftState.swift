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
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions, value: NSNumber){
        switch options.direction{
        case .Front:
            if(!options.doStart){
                manager.setState(RotatingLeftState())
                vehicle.rotateLeft(nil)
            }else{
                manager.setState(DrivingDiagonallyForwardLeftState())
                vehicle.driveDiagonallyForwardLeft(value, radius:nil)
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardLeftState())
                vehicle.driveDiagonallyBackwardLeft(value, radius:nil)
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions, value: NSNumber){
        switch options.direction{
        case .Left:
            if(!options.doStart){
                manager.setState(DrivingForwardState())
                vehicle.driveForward(nil)
            }else{
                manager.setState(DrivingDiagonallyForwardLeftState())
                vehicle.driveDiagonallyForwardLeft(nil, radius:value)
            }
        case .Right:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardRightState())
                vehicle.driveDiagonallyForwardRight(nil, radius:value)
            }
        }
    }
}

