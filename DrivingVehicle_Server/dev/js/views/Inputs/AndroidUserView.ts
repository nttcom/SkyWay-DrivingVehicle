/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="./UserInputs.ts" />

module Vehicle {
    export class AndroidUserView extends EventEmitter2 {

        private _imgArray:JQuery[] = [];
        private _isRomo:boolean = true;
        private _pageX:number = null;
        private _pageY:number = null;
        private _evtFlag = {};

        constructor() {
            super();

            this._evtFlag[InputType.Front]=false;
            this._evtFlag[InputType.Back]=false;
            this._evtFlag[InputType.Left]=false;
            this._evtFlag[InputType.Right]=false;
            this._evtFlag[InputType.HeadDown]=false;
            this._evtFlag[InputType.HeadUp]=false;


            $("#Camera").bind('touchstart',(evt:JQueryEventObject)=>{
                $(evt.target).addClass('img-hover');
                $("#remote-video").addClass('img-hover');
                setTimeout(function(){
                    $(evt.target).removeClass('img-hover');
                    $("#remote-video").removeClass('img-hover');
                },100);
                this.takePhoto();
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
                        this.emit("inputs", {type: InputType.HeadUp, flag: true});
                    }
                }else if(evt_touch.changedTouches[0].pageY - this._pageY > targetWidth){
                    if(!this._evtFlag[InputType.HeadDown]) {
                        this._evtFlag[InputType.HeadDown] = true;
                        this.emit("inputs", {type: InputType.HeadDown, flag: true});
                    }
                }else{
                    if(this._evtFlag[InputType.HeadUp]) {
                        this._evtFlag[InputType.HeadUp] = false;
                        this.emit("inputs", {type: InputType.HeadUp, flag: false});
                    }
                    if(this._evtFlag[InputType.HeadDown]) {
                        this._evtFlag[InputType.HeadDown] = false;
                        this.emit("inputs", {type: InputType.HeadUp, flag: false});
                    }
                }

                if( evt_touch.changedTouches[0].pageX - this._pageX < -1 * targetWidth){
                    if(!this._evtFlag[InputType.Left]) {
                        this._evtFlag[InputType.Left] = true;
                        this.emit("inputs", {type: InputType.Left, flag: true});
                    }
                }else if(evt_touch.changedTouches[0].pageX - this._pageX > targetWidth){
                    if(!this._evtFlag[InputType.Right]) {
                        this._evtFlag[InputType.Right] = true;
                        this.emit("inputs", {type: InputType.Right, flag: true});
                    }
                }else{
                    if(this._evtFlag[InputType.Left]) {
                        this._evtFlag[InputType.Left] = false;
                        this.emit("inputs", {type: InputType.Left, flag: false});
                    }
                    if(this._evtFlag[InputType.Right]) {
                        this._evtFlag[InputType.Right] = false;
                        this.emit("inputs", {type: InputType.Right, flag: false});
                    }
                }

            });

            $("#remote-video").bind("touchend",(evt:JQueryEventObject)=>{
                this._evtFlag[InputType.HeadUp] = false;
                this._evtFlag[InputType.HeadDown] = false;
                this._evtFlag[InputType.Left] = false;
                this._evtFlag[InputType.Right] = false;
                this.emit("inputs", {type: InputType.HeadUp, flag: false});
                this.emit("inputs", {type: InputType.HeadDown, flag: false});
                this.emit("inputs", {type: InputType.Left, flag: false});
                this.emit("inputs", {type: InputType.Right, flag: false});
            });


            $(".arrow > img").bind("touchstart",(evt:JQueryEventObject)=>{
                evt.preventDefault();

                $(evt.target).addClass("img-hover");
                var arrow_name:string = $(evt.target).parent().attr('id');

                var input = this._createInput(arrow_name, true);
                this.emit("inputs", input);

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
                        this.emit("inputs", input);
                    }
                }


            });


            $(".arrow > img").bind("touchend",(evt:JQueryEventObject)=>{
                $(evt.target).removeClass("img-hover");
                var arrow_name:string = $(evt.target).parent().attr('id');

                var input = this._createInput(arrow_name, false);
                this.emit("inputs", input);
            });

            //change the Romo icon and face
            $(".romo-control-btn").click((evt:JQueryEventObject)=>{
                $(evt.target).blur();
                var msg:string = $(evt.target).attr('id');

                if(msg === "Romo"){
                    if($("#Romo").attr("name")==="Camera"){
                        $("#Romo").attr("name","Romo").attr("src","./img/romo-icon.png");
                        $("#romo-view").show();
                        $("#local-video").hide();
                        this.emit("message", {type:msg, flag:true});
                    }else{
                        $("#Romo").attr("name","Camera").attr("src","./img/camera-icon.png");
                        $("#romo-view").hide();
                        $("#local-video").show();
                        this.emit("message", {type:msg, flag:false});
                    }

                }
            });

            //If the Robot is Double, hide Romo's icon
            var temp_params = window.location.search.substring(1).split('&');
            for(var i = 0; i < temp_params.length; i++) {
                var params = temp_params[i].split('=');
                if (params[1].indexOf('Double') === 0) {
                    this._isRomo = false;
                    $("#Romo").hide();
                }
            }
        }

        private _createInput(arrow_name:string, flag:boolean){
            var type:InputType = this._judgeType(arrow_name);
            this._evtFlag[type] = flag;

            return {type: type, flag: flag}
        }

        private _judgeType(arrow_name:string){
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

        }

        public takePhoto(){
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

            //If the Robot is Double, rotate 180deg
            if(!this._isRomo) {
                cCtx.translate(cEle.width * 0.5, cEle.height * 0.5);
                cCtx.rotate(180 * Math.PI / 180);
                cCtx.translate(-cEle.width * 0.5, -cEle.height * 0.5);
            }

            cCtx.scale(exp,exp);
            cCtx.drawImage($vEle[0], 0, 0);

            var img = new Image(cEle.width,cEle.height);
            img.src=cEle.toDataURL('image/png');

            var $tmp=$("<a/>").attr("href",img.src).attr("download","");
            $tmp.append(img)

            return $tmp;
        }
    }
}