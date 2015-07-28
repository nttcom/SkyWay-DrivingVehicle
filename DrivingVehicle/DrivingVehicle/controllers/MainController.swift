//
//  MainController.swift
//  DrivingVehicle
//

import UIKit
import Foundation
import AVFoundation

class MainController: UIViewController, NWObserver ,AVAudioPlayerDelegate{
    private var _skyway: Skyway!
    private var _vehicle: VehicleTemplate!
    
    private var _videoView: VideoViewManager!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.vehicleInit()
        
        _videoView = VideoViewManager(parentView: self.view)
        _skyway.videoDisplayProtocol = _videoView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func vehicleInit(){
#if Romo
            let peerId = "Romo-" + UIDevice.currentDevice().name
            self._skyway = Skyway(peerId: peerId)
            self._vehicle = RomoDrive(socket: _skyway)
            _skyway.delegates.append(self)
#elseif Double
            let peerId = "Double-" + UIDevice.currentDevice().name
            self._skyway = Skyway(peerId: peerId)
            self._vehicle = DoubleDrive(socket: _skyway)
#endif
        _skyway.delegates.append(_vehicle)
        
    }
    
    // MARK: RomoFaceDisplay
#if Romo
    private var romoView = RMCharacter.Romo()
    private var romoViewFlag : Bool = false
    
    func addRomoView(){
        self.dispatch_async_main {
            self.romoViewFlag = true
            self.romoView.addToSuperview(self.view)
        }
    }
    
    func removeRomoView(){
        self.dispatch_async_main {
            self.romoViewFlag = false
            self.romoView.removeFromSuperview()
            self.romoView = RMCharacter.Romo()
        }
    }
    
    
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }

    func onMessage(dict: Dictionary<String, AnyObject>){
        let type = dict["type"] as! String!
        if(type != nil){
            var flag = dict["flag"] as! Bool! == true
            switch type{
                case "Romo":
                    if(flag){
                        self.addRomoView()
                    }else{
                        self.removeRomoView()
                }
                default:
                    return
            }
        }
    
    }
    
#elseif Double
    func onMessage(dict: Dictionary<String, AnyObject>){
        return
    }
    
#endif

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

    }
}
