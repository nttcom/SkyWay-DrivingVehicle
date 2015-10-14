//
//  RotatingRightState.swift
//  DrivingVehicle
//

import Foundation

class RotatingRightState: VehicleStateProtocol {
    private let _status: VehicleStatus! = .RotatingRight
    
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
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardRightState())
                vehicle.driveDiagonallyForwardRight(value,radius: nil)
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardRightState())
                vehicle.driveDiagonallyBackwardRight(value,radius: nil)
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions, value: NSNumber){
        switch options.direction{
        case .Right:
            if(!options.doStart){
                manager.setState(StopMovingState())
                vehicle.stopDriving()
            }else{
                manager.setState(RotatingRightState())
                vehicle.rotateRight(value)
            }
        case .Left:
            if(options.doStart){
                manager.setState(RotatingLeftState())
                vehicle.rotateLeft(value)
            }
        }
    }
}
