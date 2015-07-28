//
//  HeadingDownStateTests.swift
//  DrivingVehicle
//

import UIKit
import XCTest

class VehicleMockH2:  VehicleTemplate{
    var _exception: XCTestExpectation!
    
    init(exception: XCTestExpectation) {
        _exception = exception
    }
    
    override func headingDonw() {
        
    }
    
    override func headingUp() {
        _exception.fulfill()
    }
    
    override func stopHeading() {
        _exception.fulfill()
    }
}

class HeadingDownStateTests: XCTestCase {
    var _headingStateManager: HeadingStateManager!
    var _exception: XCTestExpectation!
    var _mock: VehicleTemplate!
    
    override func setUp() {
        super.setUp()
        _headingStateManager = HeadingStateManager()
        _headingStateManager.setState(HeadingDownState())
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialize() {
        // This is an example of a functional test case.
        XCTAssertEqual(_headingStateManager.state().status(),
            HeadingStatus.HeadingDown,
            "error \(_headingStateManager.state().status().description())")
    }
    
    func testOnHeadingDown() {
        _exception = ExceptationMock()
        _mock = VehicleMockH2(exception: _exception)
        
        var option = HeadingStateOptions(doStart: true, direction: .Down)
        _headingStateManager.state().headingStateChanged(_headingStateManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_headingStateManager.state().status(),
            HeadingStatus.HeadingDown,
            "error \(_headingStateManager.state().status().description())")
    }
    
    func testOffHeadingDown() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMockH2(exception: _exception)
        
        var option = HeadingStateOptions(doStart: false, direction: .Down)
        _headingStateManager.state().headingStateChanged(_headingStateManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_headingStateManager.state().status(),
            HeadingStatus.StopHeading,
            "error \(_headingStateManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOnHeadingUp() {
        _exception = expectationWithDescription("StateChangedException")
        _mock = VehicleMockH2(exception: _exception)
        
        var option = HeadingStateOptions(doStart: true, direction: .Up)
        _headingStateManager.state().headingStateChanged(_headingStateManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_headingStateManager.state().status(),
            HeadingStatus.HeadingUp,
            "error \(_headingStateManager.state().status().description())")
        
        self.waitForExpectationsWithTimeout(5, handler: {error in
            if(error != nil){
                XCTFail("timeout error")
            }
        })
    }
    
    func testOffHeadingUp() {
        _exception = ExceptationMock()
        _mock = VehicleMockH2(exception: _exception)
        
        var option = HeadingStateOptions(doStart: false, direction: .Up)
        _headingStateManager.state().headingStateChanged(_headingStateManager, vehicle: _mock, options: option)
        
        XCTAssertEqual(_headingStateManager.state().status(),
            HeadingStatus.HeadingDown,
            "error \(_headingStateManager.state().status().description())")
    }
}