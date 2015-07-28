/// <reference path="../typings/tsd.d.ts" />
/// <reference path="../views/Inputs/UserInputs.ts" />
/// <reference path="../views/Inputs/Gamepad.ts" />
/// <reference path="../views/Inputs/Keyboard.ts" />
/// <reference path="../views/Inputs/AndroidUserView.ts" />
/// <reference path="../models/PeerManager.ts" />

module Vehicle {
    export class AndroidMainController {
        private _emitters: {[key: string]: EventEmitter2;};
        private _peerManager: PeerManager;
        private _androidUserView: AndroidUserView;

        constructor(type: string, $local_video_dom?: JQuery, $remote_video_dom?: JQuery) {
            var args = this._get_url_vars();
            this._emitters = {};
            this._androidUserView = new Vehicle.AndroidUserView;

            if (!("peerId" in args)) {
                window.alert("Please specify the peer ID (with URL query)");
                return;
            }

            var peerId = args["peerId"];
            this._peerManager = new PeerManager(peerId);

            if(type == "video"){
                this._peerManager.setupVideo(peerId, true, true, $local_video_dom, $remote_video_dom);
                this._setupData(peerId);
            } else if(type === "mute"){
                this._peerManager.setupVideo(peerId, true, false, $local_video_dom, $remote_video_dom);
                this._setupData(peerId);
            }
        }

        private _setupData(peerId: string) {
            //init GamePad and listen event
            var gamepad = new Vehicle.Gamepad();
            gamepad.addListener("inputs", this._onMessage);
            this._emitters["gamepad"] = gamepad;

            //init keyboard and listen event
            var keyboard = new Vehicle.Keyboard();
            keyboard.addListener("inputs", this._onMessage);
            this._emitters["keyboard"] = keyboard;

            this._peerManager.setupData(peerId, 'portrait');

            this._peerManager.addListener("dataChannel-open",this._openDataConnection);
        }

        private _get_url_vars(): Object{
            var args: Object= {};
            var temp_params = window.location.search.substring(1).split('&');
            for(var i = 0; i < temp_params.length; i++) {
                var params = temp_params[i].split('=');
                args[params[0]] = params[1];
            }
            return args;
        }

        private _onMessage = (inputs: UserInputs)=>{
            if(inputs.type === Vehicle.InputType.Button6 && inputs.flag){
             this._androidUserView.takePhoto();
             }
            this._peerManager.sendData(inputs);
        };

        private _openDataConnection = ()=>{
            this._androidUserView.addListener("message", this._onMessage);
            this._androidUserView.addListener("inputs", this._onMessage);
        };
    }
}

