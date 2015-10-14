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
    
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions, value: NSNumber){
        switch options.direction{
        case .Back:
            if(!options.doStart){
                manager.setState(StopMovingState())
                vehicle.stopDriving()
            }else{
                manager.setState(DrivingBackwardState())
                vehicle.driveBackward(value)
            }
        case .Front:
            if(options.doStart){
                manager.setState(DrivingForwardState())
                vehicle.driveForward(value)
            }
        }
    }
    
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions, value: NSNumber){
        switch options.direction{
        case .Left:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardLeftState())
                vehicle.driveDiagonallyBackwardLeft(nil,radius: value)
            }
        case .Right:
            if(options.doStart){
                manager.setState(DrivingDiagonallyBackwardRightState())
                vehicle.driveDiagonallyBackwardRight(nil,radius: value)
            }
        }
    }
}
