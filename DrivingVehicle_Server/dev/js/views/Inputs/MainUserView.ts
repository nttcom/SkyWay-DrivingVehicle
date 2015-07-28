/// <reference path="../../typings/tsd.d.ts" />

module Vehicle {
    export class MainUserView extends EventEmitter2 {

        private _imgArray:JQuery[] = [];
        private _isRomo:boolean = true;

        constructor() {
            super();

            $("#photo-btn").click((evt:JQueryEventObject)=>{
                $(evt.target).blur();
                this.takePhoto();
            });

            $("#mute-btn").click((evt:JQueryEventObject)=>{
                var name = $(evt.target).attr('name');

                if(name === "OFF") {
                    $(evt.target).attr('name','ON').html('<i class="fa fa-microphone"></i>  Microfone ON');
                    (<any>window).localStream.getAudioTracks()[0].enabled = true
                }else{
                    $(evt.target).attr('name','OFF').html('<i class="fa fa-microphone-slash"></i>  Microfone OFF');
                    (<any>window).localStream.getAudioTracks()[0].enabled = false
                }
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
            $tmp.append(img);

            return $tmp;
        }
    }
}