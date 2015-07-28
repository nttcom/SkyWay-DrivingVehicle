//
//  DrivingDiagonallyForwardRightStateTests.swift
//  DrivingVehicle
//

import UIKit
import XCTest

class VehicleMock7:  VehicleTemplate{
    var _exception: XCTestExpectation!
    
    init(exception: XCTestExpectation) {
        _exception = exception
    }
    
    override func driveForward(){
        _exception.fulfill()
    }
    
    override func driveBackward() {    }
    
    override func rotateLeft() {    }
    override func rotateRight() {
        _exception.fulfill()
    }
    
    override func driveDiagonallyForwardLeft() {
        _exception.fulfill()
    }
    override func driveDiagonallyForwardRight() {    }
    
    override func driveDiagonallyBackwardLeft() {    }
    override func driveDiagonallyBackwardRight() {
        _exception.fulfill()
    }
    
    override func stopDriving() {    }
}

class DrivingDiagonallyForwardRightStateTests: XCTestCase {
    var _vehicleStatusManager: VechicleStateManager!
    var _exception: XCTestExpectation!
    var _mock: VehicleTemplate!
    
    override func setUp() {
        super.setUp()
        _vehicleStatusManager = VechicleStateManager()
        _vehicleStatusManager.setState(DrivingDiagonallyForwardRightState())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialize() {
        // This is an example of a functional test case.
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardRight,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnForward() {
        _exception = ExceptationMock()
        _mock = VehicleMock7(exception: _exception)
        
        let option = MovingStateOptions(doStart: true, direction: .Front)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardRight,
            "error \(_vehicleStatusManager.state().status().description())")
    
    }
    
    func testOffForward() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock7(exception: _exception)
        
        let option = MovingStateOptions(doStart: false, direction: .Front)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.RotatingRight,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOnBackward() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock7(exception: _exception)
        
        let option = MovingStateOptions(doStart: true, direction: .Back)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyBackwardRight,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffBackward() {
        _exception = ExceptationMock()
        _mock = VehicleMock7(exception: _exception)
        
        let option = MovingStateOptions(doStart: false, direction: .Back)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardRight,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnRotateLeft() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock7(exception: _exception)
        
        let option = RotationStateOptions(doStart: true, direction: .Left)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardLeft,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffRotateLeft() {
        _exception = ExceptationMock()
        _mock = VehicleMock7(exception: _exception)
        
        let option = RotationStateOptions(doStart: false, direction: .Left)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardRight,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnRotateRight() {
        _exception = ExceptationMock()
        _mock = VehicleMock7(exception: _exception)
        
        let option = RotationStateOptions(doStart: true, direction: .Right)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardRight,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOffRotateRight() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock7(exception: _exception)
        
        let option = RotationStateOptions(doStart: false, direction: .Right)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingForward,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
}