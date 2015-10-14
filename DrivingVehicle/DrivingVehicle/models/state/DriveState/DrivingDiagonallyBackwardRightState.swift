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
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions, value: NSNumber){
        switch options.direction{
        case .Back:
            if(!options.doStart){
                manager.setState(RotatingRightState())
                vehicle.rotateRight(nil)
            }else{
                manager.setState(DrivingDiagonallyBackwardRightState())
                vehicle.driveDiagonallyBackwardRight(value, radius:nil)
            }
        case .Front:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardRightState())
                vehicle.driveDiagonallyForwardRight(value, radius:nil)
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions, value: NSNumber){
        switch options.direction{
        case .Right:
            if(!options.doStart){
                manager.setState(DrivingBackwardState())
                vehicle.driveBackward(nil)
            }else{
                manager.setState(DrivingDiagonallyBackwardRightState())
                vehicle.driveDiagonallyBackwardRight(nil, radius:value)
            }
        case .Left:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardLeftState())
                vehicle.driveDiagonallyBackwardLeft(nil, radius:value)
            }
        }
    }
}
