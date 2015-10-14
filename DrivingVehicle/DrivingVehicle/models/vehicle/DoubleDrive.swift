//
//  DoubleDrive.swift
//  DrivingVehicle
//

import Foundation

enum TurnStatus: Int {
    case STOP
    case TURN_RIGHT
    case TURN_LEFT
    
    var floatValue: Float{
        switch self{
        case .STOP: return 0.0
        case .TURN_RIGHT: return 1.0
        case .TURN_LEFT: return -1.0
        }
    }
}

class DoubleDrive: VehicleTemplate, DRDoubleDelegate{
    private var _socket: Skyway!
    private var _parkingStatus:Int32!
    private var _speed: Float!
    private var _radius: Float!
    
    init(socket: Skyway){
        super.init()
        _socket = socket
        _speed = 0.0
        _radius = 0.0
        DRDouble.sharedDouble().delegate = self
        _parkingStatus = DRDouble.sharedDouble().kickstandState
    
    }
    
    // MARK: DRDoubleDelegate
    func doubleDidConnect(theDouble: DRDouble!) {
            
    }
    
    func doubleDidDisconnect(theDouble: DRDouble!) {
        
    }
    
    func doubleStatusDidUpdate(theDouble: DRDouble!) {
        if(_parkingStatus != DRDouble.sharedDouble().kickstandState){
            getvehiclestatus()
            _parkingStatus = DRDouble.sharedDouble().kickstandState
        }
    }
    
    func doubleDriveShouldUpdate(theDouble: DRDouble!) {
        theDouble.variableDrive(_speed, turn: _radius)
    }
    
    func doubleTravelDataDidUpdate(theDouble: DRDouble!) {    }
    
    // MARK: VehicleTemplate
    override func driveForward(speed:NSNumber?){
        if(speed != nil){
         _speed = speed!.floatValue
        }
        _radius = 0.0
    }
    
    override func driveBackward(speed:NSNumber?){
        if(speed != nil){
            _speed = -1.0 * speed!.floatValue
        }
            _radius = 0.0
    }
    
    override func rotateLeft(radius:NSNumber?){
        _speed = 0.0
        if(radius != nil){
            _radius = -1.0 * radius!.floatValue
        }
    }
    
    override func rotateRight(radius:NSNumber?){
        _speed = 0.0
        if(radius != nil){
            _radius = radius!.floatValue
        }
    }
    
    override func driveDiagonallyForwardLeft(speed:NSNumber?,radius:NSNumber?){
        if(speed != nil){
            _speed = speed!.floatValue
        }
        if(radius != nil){
            _radius = -1.0 * radius!.floatValue
        }
    }
    
    override func driveDiagonallyForwardRight(speed:NSNumber?,radius:NSNumber?){
        if(speed != nil){
            _speed = speed!.floatValue
        }
        if(radius != nil){
            _radius = radius!.floatValue
        }
    }
    
    override func driveDiagonallyBackwardLeft(speed:NSNumber?,radius:NSNumber?){
        if(speed != nil){
            _speed = -1.0 * speed!.floatValue
        }
        if(radius != nil){
            _radius = -1.0 * radius!.floatValue
        }
    }
    
    override func driveDiagonallyBackwardRight(speed:NSNumber?,radius:NSNumber?){
        if(speed != nil){
            _speed = -1.0 * speed!.floatValue
        }
        if(radius != nil){
            _radius = radius!.floatValue
        }
    }
    
    override func stopDriving(){
        _speed = 0.0
        _radius = 0.0
    }
    
    override func headingUp(){
        DRDouble.sharedDouble().poleUp()
    }
    
    override func headingDown(){
        DRDouble.sharedDouble().poleDown()
    }
    override func stopHeading(){
        DRDouble.sharedDouble().poleStop()
        self.sendanglestate()
    }
    
    private func sendanglestate(){
        let angle = DRDouble.sharedDouble().poleHeightPercent
        let send_dict: Dictionary = [
            "AngleState": Double(angle),
        ]
        _socket?.send(send_dict)
        
    }
    
    override func button1(){
        if(DRDouble.sharedDouble().kickstandState == 1){
            DRDouble.sharedDouble().retractKickstands()
        } else {
            DRDouble.sharedDouble().deployKickstands()
        }
    }
    
    override func getvehiclestatus(){
        let currentDevice: UIDevice! = UIDevice.currentDevice()
        if (currentDevice !== nil) {
            let angle = DRDouble.sharedDouble().poleHeightPercent
            let double_battery: Float = DRDouble.sharedDouble().batteryPercent
            currentDevice.batteryMonitoringEnabled = true
            let ios_battery: Float = currentDevice.batteryLevel
                
            var parking_state: String = ""
            if(DRDouble.sharedDouble().kickstandState == 1){
                parking_state = "parking"
            }  else if(DRDouble.sharedDouble().kickstandState == 2){
                parking_state = "driving"
            }
            let send_dict: Dictionary = [
                "AngleState": Double(angle),
                "VehicleBattery": Double(double_battery),
                "IOSBattery": Double(ios_battery),
                "ParkingState": NSString(string: parking_state)
            ]
            _socket?.send(send_dict)
        }
    }
}
