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
    private var _movingStatus: DRDriveDirection!
    private var _turnStatus: TurnStatus!
    private var _socket: Skyway!
    
    init(socket: Skyway){
        super.init()
    
        _socket = socket
        _movingStatus = .Stop
        _turnStatus = .STOP
        DRDouble.sharedDouble().delegate = self
    }
    
    // MARK: DRDoubleDelegate
    func doubleDidConnect(theDouble: DRDouble!) {
            
    }
    
    func doubleDidDisconnect(theDouble: DRDouble!) {
        
    }
    
    func doubleStatusDidUpdate(theDouble: DRDouble!) {    }
    
    func doubleDriveShouldUpdate(theDouble: DRDouble!) {
        theDouble.drive(_movingStatus, turn: _turnStatus.floatValue)
    }
    
    func doubleTravelDataDidUpdate(theDouble: DRDouble!) {    }
    
    // MARK: VehicleTemplate
    override func driveForward(){
        _movingStatus = .Forward
        _turnStatus = .STOP
    }
    
    override func driveBackward(){
        _movingStatus = .Backward
        _turnStatus = .STOP
    }
    
    override func rotateLeft(){
        _movingStatus = .Stop
        _turnStatus = .TURN_LEFT
    }
    
    override func rotateRight(){
        _movingStatus = .Stop
        _turnStatus = .TURN_RIGHT
    }
    
    override func driveDiagonallyForwardLeft(){
        _movingStatus = .Forward
        _turnStatus = .TURN_LEFT
    }
    
    override func driveDiagonallyForwardRight(){
        _movingStatus = .Forward
        _turnStatus = .TURN_RIGHT
    }
    
    override func driveDiagonallyBackwardLeft(){
        _movingStatus = .Backward
        _turnStatus = .TURN_RIGHT
    }
    
    override func driveDiagonallyBackwardRight(){
        _movingStatus = .Backward
        _turnStatus = .TURN_LEFT
    }
    
    override func stopDriving(){
        _movingStatus = .Stop
        _turnStatus = .STOP
    }
    
    override func headingUp(){
        DRDouble.sharedDouble().poleUp()
    }
    
    override func headingDonw(){
        DRDouble.sharedDouble().poleDown()
    }
    override func stopHeading(){
        DRDouble.sharedDouble().poleStop()
    }
    
    override func button6(){
        if(DRDouble.sharedDouble().kickstandState == 1){
            DRDouble.sharedDouble().retractKickstands()
        } else {
            DRDouble.sharedDouble().deployKickstands()
        }
    }
    
    override func battery() {
        let currentDevice: UIDevice! = UIDevice.currentDevice()
        
        if (currentDevice !== nil) {
            let double_battery: Float = DRDouble.sharedDouble().batteryPercent
            currentDevice.batteryMonitoringEnabled = true
            let ios_battery: Float = currentDevice.batteryLevel
            
            let send_dict: Dictionary = [
                "VehicleBattery": Double(double_battery),
                "IOSBattery": Double(ios_battery)
            ]
            _socket?.send(send_dict)
        }
    }
}
