//
//  StopMovingState.swift
//  DrivingVehicle
//

import Foundation

class StopHeadingState: HeadingStateProtocol {
    private let _status: HeadingStatus! = .StopHeading
    
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
            if(options.doStart){
                manager.setState(HeadingDownState())
                vehicle.headingDonw()
            }
        case .Up:
            if(options.doStart){
                manager.setState(HeadingUpState())
                vehicle.headingUp()
            }
        }
    }
}


