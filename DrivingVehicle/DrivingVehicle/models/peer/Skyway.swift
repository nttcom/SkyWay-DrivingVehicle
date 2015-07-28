//
//  Skyway.swift
//  DrivingVehicle
//

import Foundation

class Skyway{
    // Enter your APIkey and Domain
    // Please check this page. >> https://skyway.io/ds/
    private let kAPIkey:String = "yourAPIKEY"
    private let kDomain:String = "yourDomain"
    
    var delegates = [NWObserver]()
    var videoDisplayProtocol: VideoDisplayProtocol?
    private var _peerId: String
    private let _skyway: SKWPeer

    private var _dataConnection: SKWDataConnection?
    private var _mediaConnection: SKWMediaConnection?

    private var _msLocal: SKWMediaStream?


    init(peerId: String){
        _peerId = peerId

        let options: SKWPeerOption = SKWPeerOption()
        options.key = kAPIkey
        options.domain = kDomain
        options.turn = false
        
        var encodedString = _peerId.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLQueryAllowedCharacterSet())
        
        // This is Sample. It's not recommended that you use this ID to identify peers
        encodedString = encodedString!.stringByReplacingOccurrencesOfString("%", withString: "__", options: [], range: nil)
        
        _skyway = SKWPeer(id: encodedString, options: options)
        _setCallbacks(_skyway)
        _setupVideo()
    }

    private func _setupVideo(){
        let constraints = SKWMediaConstraints()
        constraints.maxFrameRate = 10
        constraints.maxWidth = 360
        constraints.maxHeight = 640
        constraints.cameraPosition = .CAMERA_POSITION_FRONT
        SKWNavigator.initialize(_skyway)
        _msLocal = SKWNavigator.getUserMedia(constraints)
    }
    
    // MARK: callbacks
    private func _setCallbacks(peer: SKWPeer?){
        peer?.on(.PEER_EVENT_OPEN, callback: {obj in
            if obj is NSString{
                print("peer onopen")
            }
        })

        peer?.on(.PEER_EVENT_CONNECTION, callback: {obj in
            print("peer connection")
            if obj is SKWDataConnection{
                self._dataConnection = obj as? SKWDataConnection
                self._setDataCallbacks(self._dataConnection)
            }
        })

        peer?.on(.PEER_EVENT_CALL, callback: {obj in
            print("peer call")
            if let connection = obj as? SKWMediaConnection{
                self._mediaConnection = connection
                self._setMediaCallbacks(self._mediaConnection)
                self._mediaConnection?.answer(self._msLocal)
            }
        })

        peer?.on(.PEER_EVENT_CLOSE, callback: {obj in
            print("peer close")
        })

        peer?.on(.PEER_EVENT_DISCONNECTED, callback: {obj in
            print("peer disconnected")
            print(obj)
        })

        peer?.on(.PEER_EVENT_ERROR, callback: {obj in
            print("peer error")
        })
    }

    private func _setMediaCallbacks(media: SKWMediaConnection?){
        media?.on(.MEDIACONNECTION_EVENT_STREAM, callback: {obj in
            print("media stream")
            if let stream = obj as? SKWMediaStream{
                self.dispatch_async_global {
                    self.videoDisplayProtocol?.onRecvMedia(stream)
                }
            }
        })
        
        media?.on(.MEDIACONNECTION_EVENT_CLOSE, callback: {obj in
            print("media close")

            media?.on(.MEDIACONNECTION_EVENT_STREAM, callback: nil)
            media?.on(.MEDIACONNECTION_EVENT_CLOSE, callback: nil)
            media?.on(.MEDIACONNECTION_EVENT_ERROR, callback: nil)

            self.videoDisplayProtocol?.removeMedia()
        })
        
        media?.on(.MEDIACONNECTION_EVENT_ERROR, callback: {obj in
            print("media error")
        })
    }

    private func _setDataCallbacks(data: SKWDataConnection?){
        data?.on(.DATACONNECTION_EVENT_OPEN, callback: {obj in
            print("data open")
            self.videoDisplayProtocol?.setVideoOrientation(data?.label)
        })
        
        data?.on(.DATACONNECTION_EVENT_DATA, callback: {obj in
            if let message = obj as? NSDictionary{
                self._onMessage(message)
            }
        })
        
        data?.on(.DATACONNECTION_EVENT_CLOSE, callback: {obj in
            print("data close")
            let dict: Dictionary = ["type":"Abort","flag":true]
            for delegate: NWObserver in self.delegates {
                self.dispatch_async_global{
                    delegate.onMessage(dict)
                }
            }
        })
        
        data?.on(.DATACONNECTION_EVENT_ERROR, callback: {obj in
            print("data error")
        })
    }

    private func _onMessage(message: NSDictionary?){
        if let bindMessage = message{
            let dict = bindMessage as! Dictionary<String, AnyObject>
            for delegate: NWObserver in self.delegates {
                self.dispatch_async_global{
                    delegate.onMessage(dict)
                }
            }
        }
    }

    private func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }

    internal func send(message: Dictionary<String, AnyObject>){
        let data = message as NSDictionary
        self._dataConnection?.send(data)
    }

}
