/// <reference path="../typings/tsd.d.ts" />
/// <reference path="../views/Inputs/UserInputs.ts" />
/// <reference path="../views/Inputs/VehicleMessage.ts" />
/// <reference path="../views/Inputs/Gamepad.ts" />
/// <reference path="../views/Inputs/Keyboard.ts" />
/// <reference path="../views/Inputs/RaceDashboard.ts" />
/// <reference path="../views/Inputs/MainUserView.ts" />
/// <reference path="../models/PeerManager.ts" />

module Vehicle {
    export class MainController {
        private _emitters: {[key: string]: EventEmitter2;};
        private _peerManager: PeerManager;
        private _raceDashboard: RaceDashboard;
        private _mainUserView: MainUserView;

        constructor(type: string, $local_video_dom?: JQuery, $remote_video_dom?: JQuery) {
            var args = this._get_url_vars();
            this._emitters = {};
            this._mainUserView = new Vehicle.MainUserView(args["Double"]);
            this._raceDashboard = new Vehicle.RaceDashboard(args["Double"]);

            if (!("peerId" in args)) {
                window.alert("Please specify the peer ID (with URL query)");
                return;
            }

            var peerId = args["peerId"];
            this._peerManager = new PeerManager(peerId);

            if(type == "video"){
                this._setupVideo(peerId, true, true, $local_video_dom, $remote_video_dom);
                this._setupData(peerId);
            } else if(type === "mute"){
                this._setupVideo(peerId, true, false, $local_video_dom, $remote_video_dom);
                this._setupData(peerId);
            }
        }

        private _setupVideo(peerId: string, videoFlag: boolean, audioFlag: boolean, $local_video_dom: JQuery, $remote_video_dom: JQuery){
            this._peerManager.setupVideo(peerId, videoFlag, audioFlag, $local_video_dom, $remote_video_dom);
        }

        private _setupData(peerId: string) {
            //init GamePad and listen event
            var gamepad = new Vehicle.Gamepad();
            gamepad.addListener("inputs", this._onInput);
            this._emitters["gamepad"] = gamepad;

            //init keyboard and listen event
            var keyboard = new Vehicle.Keyboard();
            keyboard.addListener("inputs", this._onInput);
            this._emitters["keyboard"] = keyboard;

            this._peerManager.setupData(peerId, 'landscape');

            this._peerManager.addListener("dataChannel-open",this._openDataConnection);
            this._peerManager.addListener("dataChannel-data",this._raceDashboard.onData);
            this._peerManager.addListener("dataChannel-data",this._mainUserView.onData);
        }

        private _get_url_vars(): Object{
            var args: Object= {};
            var temp_params = window.location.search.substring(1).split('&');
            for(var i = 0; i < temp_params.length; i++) {
                var params = temp_params[i].split('=');
                args[params[0]] = params[1];
                if (params[1].indexOf("Double") === 0) {
                    args["Double"]=true;
                }
            }
            return args;
        }

        private _onInput = (inputs: UserInputs)=>{
            var list:string[]=this._mainUserView.getMsgList();
            if(list.indexOf(String(inputs.type)) >= 0){
                this._mainUserView.onInput(inputs);
            }else{
                if(inputs.type === InputType.Front || inputs.type === InputType.Back){
                    inputs.value = this._raceDashboard.getGearValue();
                }
                this._send(inputs);
            }
            this._raceDashboard.onInput(inputs);
        };

        private _openDataConnection = ()=>{
            this._mainUserView.addListener("message", this._send);
            this._raceDashboard.addListener("message", this._send);

            var msg = {type:InputType.GetCamera, flag:true};
            this._send(msg);

            //get vehicle state
            setTimeout(()=>{
                msg = {type:InputType.GetVehicleStatus, flag:true};
                this._send(msg);
            },1000);

            setInterval(()=>{
                this._send(msg);
            },60000)
        };

        private _send = (inputs: UserInputs)=>{
            this._peerManager.sendData(inputs)
        }
    }
}

