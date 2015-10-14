/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="./UserInputs.ts" />
/// <reference path="../../views/Inputs/VehicleMessage.ts" />

module Vehicle {

    enum Msg{
        Romo,
        SwitchCamera,
        Mic,
        Shot,
        Button1
    }

    export class MainUserView extends EventEmitter2 {

        private _imgArray:JQuery[] = [];
        private _isDouble:boolean = true;

        constructor(isDouble: boolean) {
            super();

            this._isDouble=isDouble;
            //If the Robot is Double, hide Romo's icon
            if(isDouble){
                $("#Romo").hide();
                $("#Button1").show();
                $("#HeadingtoAngle").attr("disabled","disabled")
            }

            $("#dashboard-controller button").click((evt:JQueryEventObject)=>{
                $(evt.target).blur();
                var name = $(evt.target).attr('name');
                if(name == "simple"){
                    $("#car-images").show();
                    $(evt.target)
                        .attr('name','dashboard')
                        .removeClass('btn-default')
                        .addClass('btn-info')
                        .html('mode: dashboard');
                }else{
                    $("#car-images").hide();
                    $(evt.target)
                        .attr('name','simple')
                        .removeClass('btn-info')
                        .addClass('btn-default')
                        .html('mode: simple');
                }

            });

            $("#Shot").click((evt:JQueryEventObject)=>{
                $(evt.target).blur();
                this._takePhoto();
            });

            $(".vehicle-control-btn").click((evt:JQueryEventObject)=>{
                $(evt.target).blur();
                var msg:string = $(evt.target).attr('id');
                var name = $(evt.target).attr('name');

                switch (msg){
                    case "Romo":
                        var type = InputType.Romo;
                        if(name === "Camera"){
                            $("#Romo").attr("name","Romo").attr("src","./img/romo-icon.png");
                            $("#romo-view").show();
                            $("#local-video").hide();
                            this.emit("message", {type:type, flag:true});
                        }else{
                            $("#Romo").attr("name","Camera").attr("src","./img/camera-icon.png");
                            $("#romo-view").hide();
                            $("#local-video").show();
                            this.emit("message", {type:type, flag:false});
                        }
                        break;

                    case "SwitchCamera":
                        var type = InputType.SwitchCamera;
                        this.emit("message", {type:type, flag:true});
                        break;

                    case "Button1":
                        var type = InputType.Button1;
                        this.emit("message", {type:type, flag:true});
                        this._loadParking();
                        break;

                    case "Mic":
                        if(name === "ON"){
                            $("#Mic").attr("name","OFF").attr("src","./img/mic-off.png");
                            (<any>window).localStream.getAudioTracks()[0].enabled = false
                        }else{
                            $("#Mic").attr("name","ON").attr("src","./img/mic-on.png");
                            (<any>window).localStream.getAudioTracks()[0].enabled = true
                        }
                        break;

                    default:
                        break;

                }

            });

            $(".head-btn")
                .mousedown((evt:JQueryEventObject)=>{
                    $(evt.target).blur();
                    var msg:string = $(evt.target).attr('id');
                    this.emit("message", {type:msg, flag:true});
                })
                .mouseout((evt:JQueryEventObject)=>{
                    $(evt.target).blur();
                    var msg:string = $(evt.target).attr('id');
                    this.emit("message", {type:msg, flag:false});
                 })
                .mouseup((evt:JQueryEventObject)=>{
                    $(evt.target).blur();
                    var msg:string = $(evt.target).attr('id');
                    this.emit("message", {type:msg, flag:false});
                });

            $("#HeadingtoAngle").on('input',(evt:JQueryEventObject)=>{
                $(evt.target).blur();
                var msg = InputType.HeadingtoAngle;
                var value:number = Number($(evt.target).val());
                this.emit("message", {type:msg, flag:true, value:value});
            });

        }

        public onData = (data)=>{
            if(data.hasOwnProperty(MessageType.CameraPosition)){
                this._cameraPositionChanged(data[MessageType.CameraPosition])
            }
            if(data.hasOwnProperty(MessageType.ParkingState)){
                this._parkingStateChanged(data[MessageType.ParkingState])
            }
            if(data.hasOwnProperty(MessageType.AngleState)){
                this._angleStateChanged(data[MessageType.AngleState])
            }
        };

        public getMsgList=():string[]=>{
            var list: string[] = [];
            for(var n in Msg) {
                if(typeof Msg[n] === 'number') list.push(n);
            }
            return list;
        };

        public onInput=(inputs:UserInputs)=>{
            if(inputs.flag){
                $("#" + String(inputs.type)).trigger("click");
            }
        };

        private _cameraPositionChanged = (pos: string)=> {
            if(pos == "back"){
                $("#SwitchCamera").attr("name","Back").attr("src","./img/back-camera.png");
            }else{
                $("#SwitchCamera").attr("name","Front").attr("src","./img/front-camera.png");
            }
        };

        private _loadParking = ()=> {
            $("#Button1").attr("src","./img/park-loading.gif");
        };

        private _parkingStateChanged = (pos: string)=> {
            if(pos == "driving"){
                $("#Button1").attr("name","Driving").attr("src","./img/driving.png");
            }else if(pos == "parking"){
                $("#Button1").attr("name","Parking").attr("src","./img/parking.png");
            }
        };

        private _angleStateChanged = (pos: string)=> {
            $("#HeadingtoAngle").val(pos)
        };

        private _takePhoto(){
            var $img = this._copyFrame();
            this._imgArray.push($img);

            this._render();

        }

        private _render(){
            $("#photo-lib").html("");
            for(var i in this._imgArray){
                $("#photo-lib").append(this._imgArray[i]);
            }
        }

        //copy video tag to canvas and translate DataURL for img tag
        private _copyFrame(){
            var cEle = <HTMLCanvasElement> $("#tmp-canvas")[0];
            var cCtx = cEle.getContext('2d');
            var $vEle:JQuery = $('#remote-video');

            cEle.width  = $vEle.width();
            cEle.height = $vEle.height();

            var vEle = <HTMLVideoElement> document.getElementById('remote-video');
            var exp = $vEle.width()/vEle.videoWidth;

            if(this._isDouble && $("#SwitchCamera").attr("name") === "Back"){
                cCtx.scale(-exp,exp);
                cCtx.drawImage($vEle[0], -vEle.videoWidth, 0);
            }else{
                cCtx.scale(exp,exp);
                cCtx.drawImage($vEle[0], 0, 0);
            }

            var img = new Image(cEle.width,cEle.height);
            img.src=cEle.toDataURL('image/png');

            var $tmp=$("<a/>").attr("href",img.src).attr("download","");
            $tmp.append(img);

            return $tmp;
        }
    }
}