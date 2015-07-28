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
    private var _peerId: String!
    private let _skyway: SKWPeer?

    private var _dataConnection: SKWDataConnection?
    private var _mediaConnection: SKWMediaConnection?

    private var _msLocal: SKWMediaStream?


    init(peerId: String){
        _peerId = peerId

        let options: SKWPeerOption! = SKWPeerOption()
        options.key = kAPIkey
        options.domain = kDomain
        options.turn = false
        
        var encodedString = _peerId.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLQueryAllowedCharacterSet())
        
        // We cannot use "%" for peerID, so change "%" to "__"
        // This is Sample. It's not recommended that you use this ID to identify peers
        encodedString = encodedString!.stringByReplacingOccurrencesOfString("%", withString: "__", options: nil, range: nil)
        
        _skyway = SKWPeer(id: encodedString, options: options)
        _setCallbacks(_skyway)
        _setupVideo()
    }

    private func _setupVideo(){
        let constraints = SKWMediaConstraints()
        constraints.maxFrameRate = 10
        constraints.maxWidth = 360
        constraints.maxHeight = 640
        constraints.cameraPosition = ._CAMERA_POSITION_FRONT
        SKWNavigator.initialize(_skyway)
        _msLocal = SKWNavigator.getUserMedia(constraints)
    }
    
    // MARK: callbacks
    private func _setCallbacks(peer: SKWPeer?){
        peer?.on(._PEER_EVENT_OPEN, callback: {obj in
            if obj is NSString{
                println("peer onopen")
            }
        })

        peer?.on(._PEER_EVENT_CONNECTION, callback: {obj in
            println("peer connection")
            if obj is SKWDataConnection{
                self._dataConnection = obj as? SKWDataConnection
                self._setDataCallbacks(self._dataConnection)
            }
        })

        peer?.on(._PEER_EVENT_CALL, callback: {obj in
            println("peer call")
            if let connection = obj as? SKWMediaConnection{
                self._mediaConnection = connection
                self._setMediaCallbacks(self._mediaConnection)
                self._mediaConnection?.answer(self._msLocal)
            }
        })

        peer?.on(._PEER_EVENT_CLOSE, callback: {obj in
            println("peer close")
        })

        peer?.on(._PEER_EVENT_DISCONNECTED, callback: {obj in
            println("peer disconnected")
            println(obj)
        })

        peer?.on(._PEER_EVENT_ERROR, callback: {obj in
            println("peer error")
        })
    }

    private func _setMediaCallbacks(media: SKWMediaConnection?){
        media?.on(._MEDIACONNECTION_EVENT_STREAM, callback: {obj in
            println("media stream")
            if let stream = obj as? SKWMediaStream{
                self.dispatch_async_global {
                    self.videoDisplayProtocol?.onRecvMedia(stream)
                }
            }
        })
        
        media?.on(._MEDIACONNECTION_EVENT_CLOSE, callback: {obj in
            println("media close")

            media?.on(._MEDIACONNECTION_EVENT_STREAM, callback: nil)
            media?.on(._MEDIACONNECTION_EVENT_CLOSE, callback: nil)
            media?.on(._MEDIACONNECTION_EVENT_ERROR, callback: nil)

            self.videoDisplayProtocol?.removeMedia()
        })
        
        media?.on(._MEDIACONNECTION_EVENT_ERROR, callback: {obj in
            println("media error")
        })
    }

    private func _setDataCallbacks(data: SKWDataConnection?){
        data?.on(._DATACONNECTION_EVENT_OPEN, callback: {obj in
            println("data open")
            self.videoDisplayProtocol?.setVideoOrientation(data?.label)
        })
        
        data?.on(._DATACONNECTION_EVENT_DATA, callback: {obj in
            if let message = obj as? NSDictionary{
                self._onMessage(message)
            }
        })
        
        data?.on(._DATACONNECTION_EVENT_CLOSE, callback: {obj in
            println("data close")
            var dict: Dictionary = ["type":"Abort","flag":true]
            for delegate: NWObserver in self.delegates {
                self.dispatch_async_global{
                    delegate.onMessage(dict)
                }
            }
        })
        
        data?.on(._DATACONNECTION_EVENT_ERROR, callback: {obj in
            println("data error")
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
        var data = message as NSDictionary
        self._dataConnection?.send(data)
    }

}
