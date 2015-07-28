//
//  DrivingDiagonallyForwardLeftStateTests.swift
//  DrivingVehicle
//

import UIKit
import XCTest

class VehicleMock6:  VehicleTemplate{
    var _exception: XCTestExpectation!
    
    init(exception: XCTestExpectation) {
        _exception = exception
    }
    
    override func driveForward(){
        _exception.fulfill()
    }
    
    override func driveBackward() {    }
    
    override func rotateLeft() {
        _exception.fulfill()
    }
    override func rotateRight() {    }
    
    override func driveDiagonallyForwardLeft() {    }
    override func driveDiagonallyForwardRight() {
        _exception.fulfill()
    }
    
    override func driveDiagonallyBackwardLeft() {
        _exception.fulfill()
    }
    override func driveDiagonallyBackwardRight() {    }
    
    override func stopDriving() {    }
}

class DrivingDiagonallyForwardLeftStateTests: XCTestCase {
    var _vehicleStatusManager: VechicleStateManager!
    var _exception: XCTestExpectation!
    var _mock: VehicleTemplate!
    
    override func setUp() {
        super.setUp()
        _vehicleStatusManager = VechicleStateManager()
        _vehicleStatusManager.setState(DrivingDiagonallyForwardLeftState())

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialize() {
        // This is an example of a functional test case.
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardLeft,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnForward() {
        _exception = ExceptationMock()
        _mock = VehicleMock6(exception: _exception)
        
        var option = MovingStateOptions(doStart: true, direction: .Front)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardLeft,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOffForward() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock6(exception: _exception)
        
        var option = MovingStateOptions(doStart: false, direction: .Front)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.RotatingLeft,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOnBackward() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock6(exception: _exception)
        
        var option = MovingStateOptions(doStart: true, direction: .Back)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyBackwardLeft,
            "error \(_vehicleStatusManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffBackward() {
        _exception = ExceptationMock()
        _mock = VehicleMock6(exception: _exception)
        
        var option = MovingStateOptions(doStart: false, direction: .Back)
        _vehicleStatusManager.state().moveStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardLeft,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOnRotateLeft() {
        _exception = ExceptationMock()
        _mock = VehicleMock6(exception: _exception)
        
        var option = RotationStateOptions(doStart: true, direction: .Left)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardLeft,
            "error \(_vehicleStatusManager.state().status().description())")
    }
    
    func testOffRotateLeft() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock6(exception: _exception)
        
        var option = RotationStateOptions(doStart: false, direction: .Left)
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
    
    func testOnRotateRight() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMock6(exception: _exception)
        
        var option = RotationStateOptions(doStart: true, direction: .Right)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardRight,
            "error \(_vehicleStatusManager.state().status().description())")
        
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffRotateRight() {
        _exception = ExceptationMock()
        _mock = VehicleMock6(exception: _exception)
        
        var option = RotationStateOptions(doStart: false, direction: .Right)
        _vehicleStatusManager.state().roteteStateChanged(_vehicleStatusManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_vehicleStatusManager.state().status(),
            VehicleStatus.DrivingDiagonallyForwardLeft,
            "error \(_vehicleStatusManager.state().status().description())")
    }
}