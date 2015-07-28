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
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions){
        switch options.direction{
        case .Front:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardRightState())
                vehicle.driveDiagonallyForwardRight()
            }
        case .Back:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardRightState())
                vehicle.driveDiagonallyBackwardRight()
            }
        default:
            return
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions){
        switch options.direction{
        case .Right:
            if(!options.doStart){
                manager.setState(StopMovingState())
                vehicle.stopDriving()
            }
        case .Left:
            if(options.doStart){
                manager.setState(RotatingLeftState())
                vehicle.rotateLeft()
            }
        default:
            return
        }
    }
}
