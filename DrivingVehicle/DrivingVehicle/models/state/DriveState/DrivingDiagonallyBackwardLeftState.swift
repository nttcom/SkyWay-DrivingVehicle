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
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions){
        switch options.direction{
        case .Back:
            if(!options.doStart){
                manager.setState(RotatingLeftState())
                vehicle.rotateLeft()
            }
        case .Front:
            if(options.doStart){
                manager.setState(DrivingDiagonallyForwardLeftState())
                vehicle.driveDiagonallyForwardLeft()
            }
        default:
            return
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions){
        switch options.direction{
        case .Left:
            if(!options.doStart){
                manager.setState(DrivingBackwardState())
                vehicle.rotateLeft()
            }
        case .Right:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardRightState())
                vehicle.driveDiagonallyBackwardRight()
            }
        default:
            return
        }
    }
}
