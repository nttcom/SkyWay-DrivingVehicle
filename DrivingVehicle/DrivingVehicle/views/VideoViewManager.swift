//
//  VideoViewManager.swift
//  DrivingVehicle
//

import Foundation

enum ViewTag{
    case TAG_REMOTE_VIDEO, TAG_LOCAL_VIDEO
    
    func intValue () -> Int {
        switch self {
        case TAG_REMOTE_VIDEO:
            return 1001
        case TAG_LOCAL_VIDEO:
            return 1002
        }
    }
}

protocol VideoDisplayProtocol{
    func onRecvMedia(mediaConnection: SKWMediaStream?)
    func setVideoOrientation(orientation: String?)
    func removeMedia()
}

class VideoViewManager: VideoDisplayProtocol{
    private let _videoView: SKWVideo!
    private var _msRemote: SKWMediaStream?
    private let _parentView: UIView!
    private let _verticalAspect: CGFloat = 1136 / 480
    private var _isLandscape: Bool = false

    init(parentView: UIView){
        _parentView = parentView
        _videoView = SKWVideo(frame: parentView.frame)
        _videoView.tag = ViewTag.TAG_REMOTE_VIDEO.intValue()
        parentView.addSubview(_videoView)
    }
    
    // MARK: VideoDisplayProtocol
    func onRecvMedia(mediaConnection: SKWMediaStream?) {
        _msRemote = mediaConnection
        _videoView.addSrc(mediaConnection, track: 0)
        bringFront()
        _videoView.setDidChangeVideoSizeCallback({(size: CGSize) in
            self._isLandscape = size.width > size.height
            self.transform()
        })
    }
    
    func setVideoOrientation(orientation: String?){
        _isLandscape = orientation == "landscape"
    }

    func removeMedia(){
        _videoView.removeSrc(_msRemote, track: 0)
    }

    func bringFront(){
        _parentView.bringSubviewToFront(_videoView)
    }
    
    func sendBack(){
        _parentView.sendSubviewToBack(_videoView)
    }
    
    func transform(){
        if(_isLandscape){
            _videoView.transform = CGAffineTransformMakeScale(2.4, 2.4)
        } else{
            _videoView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }

    }
}
