//
//  DrivingDiagonallyBackwardLeftState.swift
//  DrivingVehicle
//

import Foundation

class DrivingDiagonallyBackwardLeftState: VehicleStateProtocol {
    private let _status: VehicleStatus! = .DrivingDiagonallyBackwardLeft
    
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
                manager.setState(RotatingLeftState())
                vehicle.rotateLeft(nil)
            }else{
                manager.setState(DrivingDiagonallyBackwardLeftState())
                vehicle.driveDiagonallyBackwardLeft(value, radius:nil)
            }
        case .Front:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardLeftState())
                vehicle.driveDiagonallyForwardLeft(value, radius:nil)
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions, value: NSNumber){
        switch options.direction{
        case .Left:
            if(!options.doStart){
                manager.setState(DrivingBackwardState())
                vehicle.rotateLeft(nil)
            }else{
                manager.setState(DrivingDiagonallyBackwardLeftState())
                vehicle.driveDiagonallyBackwardLeft(nil, radius:value)
            }
        case .Right:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardRightState())
                vehicle.driveDiagonallyBackwardRight(nil, radius:value)
            }
        }
    }
}
