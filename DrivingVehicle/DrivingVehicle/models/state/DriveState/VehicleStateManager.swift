//
//  VehicleStateManager.swift
//  DrivingVehicle
//

import Foundation

enum MovingDirection{
    case Front, Back
}

enum RotationDirection{
    case Left, Right
}

enum VehicleStatus{
    case StopMoving, DrivingForward, DrivingBackward,
    DrivingDiagonallyForwardLeft, DrivingDiagonallyForwardRight,
    DrivingDiagonallyBackwardLeft, DrivingDiagonallyBackwardRight,
    RotatingLeft, RotatingRight
    
    func description () -> String {
        switch self {
        case StopMoving:
            return "StopMoving"
        case DrivingForward:
            return "DrivingForward"
        case DrivingBackward:
            return "DrivingBackward"
        case DrivingDiagonallyForwardLeft:
            return "DrivingDiagonallyForwardLeft"
        case DrivingDiagonallyForwardRight:
            return "DrivingDiagonallyForwardRight"
        case DrivingDiagonallyBackwardLeft:
            return "DrivingDiagonallyBackwardLeft"
        case DrivingDiagonallyBackwardRight:
            return "DrivingDiagonallyBackwardRight"
        case RotatingLeft:
            return "RotatingLeft"
        case RotatingRight:
            return "RotatingRight"
        default:
            return "error"
        }
    }
}

struct MovingStateOptions {
    var doStart: Bool = false
    var direction: MovingDirection
}

struct RotationStateOptions {
    var doStart: Bool = false
    var direction: RotationDirection
}

protocol VehicleStateProtocol{
    func status() -> VehicleStatus
    func abort(manager: VechicleStateManager, vehicle: VehicleTemplate) -> Void
    func moveStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: MovingStateOptions) -> Void
    func roteteStateChanged(manager: VechicleStateManager, vehicle: VehicleTemplate, options: RotationStateOptions) -> Void
}

class VechicleStateManager{
    private var _state: VehicleStateProtocol!
    
    init(){
        _state = StopMovingState()
    }
    
    func state() -> VehicleStateProtocol{
        return _state
    }
    
    func setState(state: VehicleStateProtocol){
        _state = state
    }
}




