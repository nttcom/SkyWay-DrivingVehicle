/// <reference path="../typings/tsd.d.ts" />
/// <reference path="../views/Inputs/UserInputs.ts" />
/// <reference path="../views/Inputs/Gamepad.ts" />
/// <reference path="../views/Inputs/Keyboard.ts" />
/// <reference path="../views/Inputs/RaceDashboard.ts" />
/// <reference path="../models/PeerManager.ts" />

module Vehicle {
    export class RaceMainController {
        private _emitters: {[key: string]: EventEmitter2;};
        private _peerManager: PeerManager;
        private _raceDashboard: RaceDashboard;

        constructor(type: string, $local_video_dom?: JQuery, $remote_video_dom?: JQuery) {
            var args = this._get_url_vars();
            this._emitters = {};
            this._raceDashboard = new RaceDashboard();


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

            this._peerManager.setupData(peerId, 'landscape');

            this._peerManager.addListener("dataChannel-open",this._openDataConnection);
            this._peerManager.addListener("dataChannel-data",this._raceDashboard.onData);
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
            this._raceDashboard.stateChanged(inputs);
            this._peerManager.sendData(inputs);
        };

        private _openDataConnection = ()=>{
            //get battery info
            var msg = {type:"Battery", flag:true};
            this._peerManager.sendData(msg);
            setInterval(()=>{
                this._peerManager.sendData(msg);
            },60000)
        };
    }
}

