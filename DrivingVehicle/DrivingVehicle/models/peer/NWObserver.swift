//
//  NWObserver.swift
//  DrivingVehicle
//

import Foundation

protocol NWObserver{
    func onMessage(dict: Dictionary<String, AnyObject>)
}
