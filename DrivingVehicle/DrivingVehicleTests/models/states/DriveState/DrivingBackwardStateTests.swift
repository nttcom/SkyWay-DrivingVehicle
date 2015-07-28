//
//  DrivingBackwardStateTests.swift
//  DrivingVehicle
//

import UIKit
import XCTest

class VehicleMock2:  VehicleTemplate{
    var _exception: XCTestExpectation!
    
    init(exception: XCTestExpectation) {
        _exception = exception
    }
    
    override func driveForward(){
        _exception.fulfill()
    }
    
    override func driveBackward() {    }
    
    override func rotateLeft() {    }
    override func rotateRight() {    }
    
    override func driveDiagonallyForwardLeft() {    }
    override func driveDiagonallyForwardRight() {    }
    
    override func driveDiagonallyBackwardLeft() {
        _exception.fulfill()
    }
    override func driveDiagonallyBackwardRight() {
        _exception.fulfill()
    }
    
    override func stopDriving() {
        _exception.fulfill()
    }
}

class DrivingBackwardStateTests: XCTestCase {
    var _vehicleStatusManager: VechicleStateManager!
    var _exception: XCTestExpectation!
    var _mock: VehicleTemplate!
    
    override func setUp() {
        super.setUp()
        _vehicleStatusManager = VechicleStateManager()
        _vehicleStatusManager.setState(DrivingBackwardState())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialize() {
        // This is an example of a functional test case.
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingBackward,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnForward() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock2(exception: _exception)
        
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
        _exception = ExceptationMock()
        _mock = VehicleMock2(exception: _exception)
        
        let option = MovingStateOptions(doStart: false, direction: .Front)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingBackward,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnBackward() {
        _exception = ExceptationMock()
        _mock = VehicleMock2(exception: _exception)
        
        let option = MovingStateOptions(doStart: true, direction: .Back)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingBackward,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOffBackward() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock2(exception: _exception)
        
        let option = MovingStateOptions(doStart: false, direction: .Back)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.StopMoving,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOnRotateLeft() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock2(exception: _exception)
        
        let option = RotationStateOptions(doStart: true, direction: .Left)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyBackwardLeft,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffRotateLeft() {
        _exception = ExceptationMock()
        _mock = VehicleMock2(exception: _exception)
        
        let option = RotationStateOptions(doStart: false, direction: .Left)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingBackward,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnRotateRight() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock2(exception: _exception)
        
        let option = RotationStateOptions(doStart: true, direction: .Right)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyBackwardRight,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffRotateRight() {
        _exception = ExceptationMock()
        _mock = VehicleMock2(exception: _exception)
        
        let option = RotationStateOptions(doStart: false, direction: .Right)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingBackward,
            "error \(_vehicleStatusManager.state().status().description())")
    }
}

