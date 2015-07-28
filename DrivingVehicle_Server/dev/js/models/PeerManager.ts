/// <reference path="../typings/tsd.d.ts" />

module Vehicle {
    export class PeerManager extends EventEmitter2{
        private _peer: PeerJs.Peer;
        private _dataChannel: PeerJs.DataConnection;
        private _APIkey: string = "yourAPIkey";

        constructor(peerId: string) {
            super();
            this._peer = new Peer({
                key: this._APIkey
            });

            this._checkPeerId(this._peer, peerId, (flag)=> {
                if (!flag) {
                    window.alert("Could not find the vehicle's peer ID");
                    return;
                }
            });
        }

        private _checkPeerId(peer: PeerJs.Peer, peerId: string, callback: (flag: boolean)=>void){
            peer.on("open", ()=>{
                peer.listAllPeers((items)=>{
                    var flag = false;
                    for(var i in items){
                        if(items[i] === peerId) {
                            flag = true;
                            break;
                        }
                    }

                    callback(flag);
                });
            });
        }

        public setupVideo(peerId: string, videoFlag: boolean, audioFlag: boolean, $local_video_dom: JQuery, $remote_video_dom: JQuery){
            navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

            this._peer.on('error', (err)=>{
            });

            navigator.getUserMedia({audio: audioFlag, video: videoFlag}, (stream)=>{
                // Set your video displays
                $local_video_dom.prop('src', URL.createObjectURL(stream));

                (<any>window).localStream = stream;
                var call = this._peer.call(peerId, stream);
                call.on('stream', (stream)=>{
                    $remote_video_dom.prop('src', URL.createObjectURL(stream));
                });
            }, ()=>{ alert("Failed to access the webcam and microphone."); });
        }

        public setupData(peerId: string, orient: string){

            //connect data channel
            this._dataChannel = this._peer.connect(peerId, {
                label: orient,
                serialization: 'binary',
                reliable: true
            });

            //data channel onopen
            this._dataChannel.on('open', ()=>{
                this._dataChannel.on('data',(data)=>{
                    this.emit("dataChannel-data",data);
                });
                this.emit("dataChannel-open",null);
            });
        }

        public sendData(message: Object){
            this._dataChannel.send(message);
        }
    }
}
