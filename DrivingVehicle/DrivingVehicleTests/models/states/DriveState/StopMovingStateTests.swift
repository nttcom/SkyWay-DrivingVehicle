//
//  StopMovingStateTests.swift
//  DrivingVehicle
//

import UIKit
import XCTest

class VehicleMock1:  VehicleTemplate{
    var _exception: XCTestExpectation!
    
    init(exception: XCTestExpectation) {
        _exception = exception
    }
    
    override func driveForward(){
        _exception.fulfill()
    }
    
    override func driveBackward() {
        _exception.fulfill()
    }
    
    override func rotateLeft() {
        _exception.fulfill()
    }
    override func rotateRight() {
        _exception.fulfill()
    }
    
    override func driveDiagonallyForwardLeft() {    }
    override func driveDiagonallyForwardRight() {    }
    
    override func driveDiagonallyBackwardLeft() {    }
    override func driveDiagonallyBackwardRight() {    }
    
    override func stopDriving() {   }
}

class StopMovingStateTests: XCTestCase {
    var _vehicleStatusManager: VechicleStateManager!
    var _mock: VehicleTemplate!
    var _exceptation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        _vehicleStatusManager = VechicleStateManager()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialize() {
        // This is an example of a functional test case.
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.StopMoving,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnForward() {
        _exceptation = expectationWithDescription("StateChangedException")
        _mock = VehicleMock1(exception: _exceptation)

        let option = MovingStateOptions(doStart: true, direction: .Front)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingForward,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffForward() {
        _exceptation = ExceptationMock()
        _mock = VehicleMock1(exception: _exceptation)
        
        let option = MovingStateOptions(doStart: false, direction: .Front)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.StopMoving,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnBackward() {
        _exceptation = expectationWithDescription("StateChangedException")
        _mock = VehicleMock1(exception: _exceptation)
        
        let option = MovingStateOptions(doStart: true, direction: .Back)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingBackward,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffBackward() {
        _exceptation = ExceptationMock()
        _mock = VehicleMock1(exception: _exceptation)
        
        let option = MovingStateOptions(doStart: false, direction: .Back)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.StopMoving,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnRotateLeft() {
        _exceptation = expectationWithDescription("StateChangedException")
        _mock = VehicleMock1(exception: _exceptation)
        
        let option = RotationStateOptions(doStart: true, direction: .Left)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.RotatingLeft,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffRotateLeft() {
        _exceptation = ExceptationMock()
        _mock = VehicleMock1(exception: _exceptation)
        
        let option = RotationStateOptions(doStart: false, direction: .Left)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.StopMoving,
            "error \(_vehicleStatusManager.state().status().description())")
    }

    func testOnRotateRight() {
        _exceptation = expectationWithDescription("StateChangedException")
        _mock = VehicleMock1(exception: _exceptation)
        
        let option = RotationStateOptions(doStart: true, direction: .Right)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.RotatingRight,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffRotateRight() {
        _exceptation = ExceptationMock()
        _mock = VehicleMock1(exception: _exceptation)
        
        let option = RotationStateOptions(doStart: false, direction: .Right)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.StopMoving,
            "error \(_vehicleStatusManager.state().status().description())")
    }
}


