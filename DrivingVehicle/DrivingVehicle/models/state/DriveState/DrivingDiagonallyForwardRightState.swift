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
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions, value: NSNumber){
        switch options.direction{
        case .Front:
            if(!options.doStart){
                manager.setState(RotatingRightState())
                vehicle.rotateRight(nil)
            }else{
                manager.setState(DrivingDiagonallyForwardRightState())
                vehicle.driveDiagonallyForwardRight(value, radius:nil)
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardRightState())
                vehicle.driveDiagonallyBackwardRight(value, radius:nil)
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions, value: NSNumber){
        switch options.direction{
        case .Right:
            if(!options.doStart){
                manager.setState(DrivingForwardState())
                vehicle.driveForward(nil)
            }else{
                manager.setState(DrivingDiagonallyForwardRightState())
                vehicle.driveDiagonallyForwardRight(nil, radius:value)
            }
        case .Left:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardLeftState())
                vehicle.driveDiagonallyForwardLeft(nil, radius:value)
            }
        }
    }
}
