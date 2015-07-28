//
//  VehicleStateManager.swift
//  DrivingVehicle
//

import Foundation

enum HeadingDirection{
    case Down, Up
}

enum HeadingStatus{
    case StopHeading, HeadingDown, HeadingUp
    
    func description () -> String {
        switch self {
        case StopHeading:
            return "StopHeading"
        case HeadingDown:
            return "HeadingDown"
        case HeadingUp:
            return "HeadingUp"
        default:
            return "error"
        }
    }
}

struct HeadingStateOptions {
    var doStart: Bool = false
    var direction: HeadingDirection
}

protocol HeadingStateProtocol{
    func status() -> HeadingStatus
    func abort(manager: HeadingStateManager, vehicle: VehicleTemplate) -> Void
    func headingStateChanged(manager: HeadingStateManager, vehicle: VehicleTemplate, options: HeadingStateOptions) -> Void
}

class HeadingStateManager{
    private var _state: HeadingStateProtocol!
    
    init(){
        _state = StopHeadingState()
    }
    
    func state() -> HeadingStateProtocol{
        return _state
    }
    
    func setState(state: HeadingStateProtocol){
        _state = state
    }
}




