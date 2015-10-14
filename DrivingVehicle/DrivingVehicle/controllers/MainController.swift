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
    private var cannonPlayer : AVAudioPlayer!
    
    required init?(coder aDecoder: NSCoder) {
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
            self._vehicle = RomoDrive(socket: self._skyway)
#elseif Double
            let peerId = "Double-" + UIDevice.currentDevice().name
            self._skyway = Skyway(peerId: peerId)
            self._vehicle = DoubleDrive(socket: self._skyway)
#endif
        _skyway.delegates.append(self)
        _skyway.delegates.append(_vehicle)
        
        let cannonFilePath : NSString = NSBundle.mainBundle().pathForResource("cannon", ofType: "mp3")!
        let cannonfileURL: NSURL = NSURL(fileURLWithPath: cannonFilePath as String)
        
        cannonPlayer = try? AVAudioPlayer(contentsOfURL: cannonfileURL)
        
        cannonPlayer.delegate = self
        cannonPlayer.prepareToPlay()
        
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
            let flag = dict["flag"] as! Bool! == true
            switch type{
                case "Romo":
                    if(flag){
                        self.addRomoView()
                    }else{
                        self.removeRomoView()
                }
                case "GetCamera":
                    if(flag){
                        _skyway.sendCameraPosition()
                    }
                case "SwitchCamera":
                    if(flag){
                        _skyway.switchCamera()
                    }
                case "Shot":
                    if(flag){
                        if(cannonPlayer != nil){
                            if (cannonPlayer.playing == true) {
                                cannonPlayer.currentTime = 0;
                            }
                    
                            cannonPlayer.play()
                        }
                    }
                default:
                    return
            }
        }
    
    }
    
#elseif Double
    func onMessage(dict: Dictionary<String, AnyObject>){
        let type = dict["type"] as! String!
        if(type != nil){
            let flag = dict["flag"] as! Bool! == true
            switch type{
                case "GetCamera":
                    if(flag){
                        _skyway.sendCameraPosition()
                    }
                case "SwitchCamera":
                    if(flag){
                        _skyway.switchCamera()
                    }
                case "Shot":
                    if(flag){
                        if(cannonPlayer != nil){
                            if (cannonPlayer.playing == true) {
                                cannonPlayer.currentTime = 0;
                            }
    
                            cannonPlayer.play()
                        }
                    }
                default:
                    return
            }
        }
    }
    
#endif

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
}
