//
//  HeadingDownState.swift
//  DrivingVehicle
//

import Foundation

class HeadingDownState: HeadingStateProtocol {
    private let _status: HeadingStatus! = .HeadingDown
    
    func status() -> HeadingStatus{
        return _status
    }
    
    func abort(manager: HeadingStateManager, vehicle: VehicleTemplate) {
        manager.setState(StopHeadingState())
        vehicle.stopHeading()
    }
    
    func headingStateChanged(manager: HeadingStateManager, vehicle: VehicleTemplate, options: HeadingStateOptions){
        switch options.direction{
        case .Down:
            if(!options.doStart){
                manager.setState(StopHeadingState())
                vehicle.stopHeading()
            }
        case .Up:
            if(options.doStart){
                manager.setState(HeadingUpState())
                vehicle.headingUp()
            }
        }
    }
}


