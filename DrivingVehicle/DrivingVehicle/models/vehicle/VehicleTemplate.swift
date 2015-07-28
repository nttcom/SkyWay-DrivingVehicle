////  VehicleTemplate.swift//  DrivingVehicle//import Foundationimport AVFoundationenum ControlMessage{    case Button1, Button2, Button3, Button4, Button5, Button6, Abort        func description () -> String {    switch self {    case Button1:        return "Button1"    case Button2:        return "Button2"    case Button3:        return "Button3"    case Button4:        return "Button4"    case Button5:        return "Button5"    case Button6:        return "Button6"    case Abort:        return "Abort"    default:        return "error"    }    }}enum VehicleVital{    case Battery        func description () -> String {    switch self {    case Battery:        return "Battery"    default:        return "error"    }    }}public class VehicleTemplate: NSObject, NWObserver{    private let _vehicleStateManager = VechicleStateManager()    private let _headingStateManager = HeadingStateManager()            func driveForward(){}    func driveBackward(){}    func rotateLeft(){}    func rotateRight(){}        func driveDiagonallyForwardLeft(){}    func driveDiagonallyForwardRight(){}        func driveDiagonallyBackwardLeft(){}    func driveDiagonallyBackwardRight(){}        func stopDriving(){}        func headingUp(){}    func headingDonw(){}    func stopHeading(){}            func button1(){}    func button2(){}    func button3(){}    func button4(){}    func button5(){}    func button6(){}        func battery(){}        func onMessage(dict: Dictionary<String, AnyObject>){        let type = dict["type"] as! String!        if(type != nil){            var flag = dict["flag"] as! Bool! == true            switch type{            case VehicleStatus.DrivingForward.description():                var option = MovingStateOptions(doStart: flag, direction: .Front)                _vehicleStateManager.state().moveStateChanged(_vehicleStateManager, vehicle: self, options: option)            case VehicleStatus.DrivingBackward.description():                var option = MovingStateOptions(doStart: flag, direction: .Back)                _vehicleStateManager.state().moveStateChanged(_vehicleStateManager, vehicle: self, options: option)            case VehicleStatus.RotatingLeft.description():                var option = RotationStateOptions(doStart: flag, direction: .Left)                _vehicleStateManager.state().roteteStateChanged(_vehicleStateManager, vehicle: self, options: option)            case VehicleStatus.RotatingRight.description():                var option = RotationStateOptions(doStart: flag, direction: .Right)                _vehicleStateManager.state().roteteStateChanged(_vehicleStateManager, vehicle: self, options: option)            case HeadingStatus.HeadingDown.description():                var option = HeadingStateOptions(doStart: flag, direction: .Down)                _headingStateManager.state().headingStateChanged(_headingStateManager, vehicle: self, options: option)            case HeadingStatus.HeadingUp.description():                var option = HeadingStateOptions(doStart: flag, direction: .Up)                _headingStateManager.state().headingStateChanged(_headingStateManager, vehicle: self, options: option)            case ControlMessage.Button1.description():                if(flag){ button1() }            case ControlMessage.Button2.description():                if(flag){ button2() }            case ControlMessage.Button3.description():                if(flag){ button3() }            case ControlMessage.Button4.description():                if(flag){ button4() }            case ControlMessage.Button5.description():                if(flag){ button5() }            case ControlMessage.Button6.description():                if(flag){ button6() }            case VehicleVital.Battery.description():                if(flag){ battery() }            case ControlMessage.Abort.description():                if(flag){                    _vehicleStateManager.state().abort(_vehicleStateManager, vehicle: self)                    _headingStateManager.state().abort(_headingStateManager, vehicle: self)                }            default:                return            }        }            }}