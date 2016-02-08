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

    export class AndroidUserView extends EventEmitter2 {

        private _imgArray:JQuery[] = [];
        private _pageX:number = null;
        private _pageY:number = null;
        private _evtFlag = {};
        private _isDouble:boolean = true;

        constructor(isDouble: boolean) {
            super();

            this._isDouble=isDouble;
            //If the Robot is Double, hide Romo's icon
            if(isDouble){
                $("#Romo").hide();
                $("#Button1").show();
            }

            this._evtFlag[InputType.Front]=false;
            this._evtFlag[InputType.Back]=false;
            this._evtFlag[InputType.Left]=false;
            this._evtFlag[InputType.Right]=false;
            this._evtFlag[InputType.HeadDown]=false;
            this._evtFlag[InputType.HeadUp]=false;


            $("#Shot").click((evt:JQueryEventObject)=>{
                $(evt.target).addClass('img-hover');
                $("#remote-video").addClass('img-hover');
                setTimeout(function(){
                    $(evt.target).removeClass('img-hover');
                    $("#remote-video").removeClass('img-hover');
                },100);
                this._takePhoto();
            });

            $("#Gallery").click((evt:JQueryEventObject)=>{
                $(evt.target).addClass('img-hover');

                //show library
                $("#photo-div").slideDown();

                setTimeout(function(){
                    $(evt.target).removeClass('img-hover');
                },100);

            });

            $("#photo-div").click((evt:JQueryEventObject)=>{
                $("#photo-div").slideUp();
            });


            $("#remote-video").bind("touchstart", (evt:JQueryEventObject)=>{
                evt.preventDefault();
                var evt_touch:any = evt.originalEvent;

                this._pageX = evt_touch.changedTouches[0].pageX;
                this._pageY = evt_touch.changedTouches[0].pageY;
            });

            //When swiping up and down on the remote video view, the robot's head move up and down
            //When swiping left and right, the robot rotates left and right
            $("#remote-video").bind("touchmove", (evt:JQueryEventObject)=>{
                evt.preventDefault();
                var evt_touch:any = evt.originalEvent;

                //threshold of swipe event
               var targetWidth = evt_touch.changedTouches[0].target.clientWidth / 8;

                if( evt_touch.changedTouches[0].pageY - this._pageY < -1 * targetWidth){
                    if(!this._evtFlag[InputType.HeadUp]) {
                        this._evtFlag[InputType.HeadUp] = true;
                        this.emit("message", {type: InputType.HeadUp, flag: true});
                    }
                }else if(evt_touch.changedTouches[0].pageY - this._pageY > targetWidth){
                    if(!this._evtFlag[InputType.HeadDown]) {
                        this._evtFlag[InputType.HeadDown] = true;
                        this.emit("message", {type: InputType.HeadDown, flag: true});
                    }
                }else{
                    if(this._evtFlag[InputType.HeadUp]) {
                        this._evtFlag[InputType.HeadUp] = false;
                        this.emit("message", {type: InputType.HeadUp, flag: false});
                    }
                    if(this._evtFlag[InputType.HeadDown]) {
                        this._evtFlag[InputType.HeadDown] = false;
                        this.emit("message", {type: InputType.HeadUp, flag: false});
                    }
                }

                if( evt_touch.changedTouches[0].pageX - this._pageX < -1 * targetWidth){
                    if(!this._evtFlag[InputType.Left]) {
                        this._evtFlag[InputType.Left] = true;
                        this.emit("message", {type: InputType.Left, flag: true, value: 0.5});
                    }
                }else if(evt_touch.changedTouches[0].pageX - this._pageX > targetWidth){
                    if(!this._evtFlag[InputType.Right]) {
                        this._evtFlag[InputType.Right] = true;
                        this.emit("message", {type: InputType.Right, flag: true, value: 0.5});
                    }
                }else{
                    if(this._evtFlag[InputType.Left]) {
                        this._evtFlag[InputType.Left] = false;
                        this.emit("message", {type: InputType.Left, flag: false, value: 0.0});
                    }
                    if(this._evtFlag[InputType.Right]) {
                        this._evtFlag[InputType.Right] = false;
                        this.emit("message", {type: InputType.Right, flag: false, value: 0.0});
                    }
                }

            });

            $("#remote-video").bind("touchend",(evt:JQueryEventObject)=>{
                this._evtFlag[InputType.HeadUp] = false;
                this._evtFlag[InputType.HeadDown] = false;
                this._evtFlag[InputType.Left] = false;
                this._evtFlag[InputType.Right] = false;
                this.emit("message", {type: InputType.HeadUp, flag: false});
                this.emit("message", {type: InputType.HeadDown, flag: false});
                this.emit("message", {type: InputType.Left, flag: false, value:0});
                this.emit("message", {type: InputType.Right, flag: false, value:0});
            });


            $(".arrow > img").bind("touchstart",(evt:JQueryEventObject)=>{
                evt.preventDefault();

                $(evt.target).addClass("img-hover");
                var arrow_name:string = $(evt.target).parent().attr('id');

                var input = this._createInput(arrow_name, true);
                this.emit("message", input);

            });

            $(".arrow > img").bind("touchmove",(evt:JQueryEventObject)=>{
                evt.preventDefault();
                var arrow_name:string = $(evt.target).parent().attr('id');
                var type:InputType = this._judgeType(arrow_name);

                if(this._evtFlag[type]) {
                    var evt_touch:any = evt.originalEvent;

                    var targetLeft = evt_touch.changedTouches[0].target.x;
                    var targetTop = evt_touch.changedTouches[0].target.y;
                    var targetRight = targetLeft + evt_touch.changedTouches[0].target.width;
                    var targetBottom = targetTop + evt_touch.changedTouches[0].target.height;

                    //When the finger move out of the arrow image, the robot stops moving
                    if (evt_touch.changedTouches[0].pageX < targetLeft || evt_touch.changedTouches[0].pageX > targetRight || evt_touch.changedTouches[0].pageY < targetTop || evt_touch.changedTouches[0].pageY > targetBottom) {
                        $(evt.target).removeClass("img-hover");
                        var arrow_name:string = $(evt.target).parent().attr('id');

                        var input = this._createInput(arrow_name, false);
                        this.emit("message", input);
                    }
                }


            });


            $(".arrow > img").bind("touchend",(evt:JQueryEventObject)=>{
                $(evt.target).removeClass("img-hover");
                var arrow_name:string = $(evt.target).parent().attr('id');

                var input = this._createInput(arrow_name, false);
                this.emit("message", input);
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
                            $("#Mic").attr("name","OFF").attr("src","./img/mic-off-android.png");
                            (<any>window).localStream.getAudioTracks()[0].enabled = false
                        }else{
                            $("#Mic").attr("name","ON").attr("src","./img/mic-on-android.png");
                            (<any>window).localStream.getAudioTracks()[0].enabled = true
                        }
                        break;

                    default:
                        break;

                }

            });

        }

        public onData = (data)=>{
            if(data.hasOwnProperty(MessageType.CameraPosition)){
                this._cameraPositionChanged(data[MessageType.CameraPosition])
            }
            if(data.hasOwnProperty(MessageType.ParkingState)){
                this._parkingStateChanged(data[MessageType.ParkingState])
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
                $("#SwitchCamera").attr("name","Back").attr("src","./img/back-camera-android.png");
            }else{
                $("#SwitchCamera").attr("name","Front").attr("src","./img/front-camera-android.png");
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

        private _createInput = (arrow_name:string, flag:boolean):UserInputs=>{
            var type:InputType = this._judgeType(arrow_name);
            var value:number = 0;
            this._evtFlag[type] = flag;

            if(type === InputType.Front || type === InputType.Back){
                value = 0.4;
            }else{
                value = 0.5
            }

            return {type: type, flag: flag, value:value}
        };

        private _judgeType=(arrow_name:string):InputType=>{
            var type:InputType;
            switch (arrow_name) {
                case "front":
                    type = InputType.Front;
                    break;
                case "back":
                    type = InputType.Back;
                    break;
                case "left":
                    type = InputType.Left;
                    break;
                case "right":
                    type = InputType.Right;
                    break;
            }
            return type;

        };

        public _takePhoto=()=>{
            var $img = this._copyFrame();
            this._imgArray.push($img);

            this._render();

        };

        private _render=()=>{
            $("#photo-lib").html("");
            for(var i in this._imgArray){
                $("#photo-lib").append(this._imgArray[i]);
            }
        };

        //copy video tag to canvas and translate DataURL for img tag
        private _copyFrame=()=>{
            var cEle = <HTMLCanvasElement> $("#tmp-canvas")[0];
            var cCtx = cEle.getContext('2d');
            var $vEle:JQuery = $('#remote-video');

            cEle.width  = $vEle.width();
            cEle.height = $vEle.height();

            var vEle = <HTMLVideoElement> document.getElementById('remote-video');
            var exp = $vEle.width()/vEle.videoWidth;

            if(this._isDouble && $("#SwitchCamera").attr("name") === "Back"){
                cCtx.scale(-exp,exp);
                cCtx.drawImage(<HTMLVideoElement> $vEle[0], -vEle.videoWidth, 0);
            }else{
                cCtx.scale(exp,exp);
                cCtx.drawImage(<HTMLVideoElement> $vEle[0], 0, 0);
            }

            var img = new Image(cEle.width,cEle.height);
            img.src=cEle.toDataURL('image/png');

            var $tmp=$("<a/>").attr("href",img.src).attr("download","");
            $tmp.append(img)

            return $tmp;
        }
    }
}