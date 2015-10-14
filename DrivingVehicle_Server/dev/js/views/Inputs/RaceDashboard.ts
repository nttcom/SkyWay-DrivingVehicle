/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../views/Inputs/UserInputs.ts" />
/// <reference path="../../views/Inputs/VehicleMessage.ts" />

module Vehicle{

    export class RaceDashboard extends EventEmitter2{

        private _DrivingState: string = "StopMoving";
        private _WiperState: boolean = false;
        private _Timer: any;
        private _isDouble: boolean = true;
        private _currentGear:number = 0;
        private _gear2value:number[] = [0.3, 0.4, 0.6];
        private _radius:number = 0;


        constructor(isDouble: boolean) {
            super();
            this._isDouble=isDouble;
        }

        public onData = (data)=>{
            if(data.hasOwnProperty(MessageType.VehicleBattery) && data.hasOwnProperty(MessageType.IOSBattery)){
                this._batteryChanged(data[MessageType.VehicleBattery],data[MessageType.IOSBattery]);
            }
            if(data.hasOwnProperty(MessageType.CameraPosition)){
                this._cameraPositionChanged(data[MessageType.CameraPosition])
            }
        };

        public onInput = (inputs: UserInputs)=>{
            if(inputs.flag === true && (inputs.type === InputType.GearUp || inputs.type === InputType.GearDown)){
                this._gearChange(inputs);
            }
            if(inputs.type === InputType.Front ||inputs.type === InputType.Back || inputs.type === InputType.Right || inputs.type === InputType.Left){
                this._drivingStateChanged(inputs);
            }
            if(inputs.type === InputType.Wiper){
                this._wiperStateChanged(inputs);
            }
        };

        public getGearValue = ():number=>{
            return this._gear2value[this._currentGear]
        };

        private _gearChange = (inputs: UserInputs)=>{
            if(inputs.type === InputType.GearUp && this._currentGear < this._gear2value.length - 1){
                this._currentGear++;
            }else if(inputs.type === InputType.GearDown && this._currentGear > 0){
                this._currentGear--;
            }
            $("#gear").attr("src","./img/gear-"+ this._currentGear +".png");
            this._changeDrivingDisplay();
            this._updateSpeed();

        };

        private _updateSpeed = ()=>{
            if(this._DrivingState.indexOf("Forward") >= 0){
                this.emit("message", {type:InputType.Front, flag:true, value: this.getGearValue()});
            }else if(this._DrivingState.indexOf("Backward") >= 0){
                this.emit("message", {type:InputType.Back, flag:true, value: this.getGearValue()});
            }
        };

        private _batteryChanged = (v_battery: number, i_battery: number)=>{
            var vehicle_angle:number = 0;
            var ios_angle:number = 0;
            if(v_battery <= 1 && v_battery >= 0){
                vehicle_angle = 122 * v_battery;
            }

            if(i_battery <= 1 && i_battery >= 0){
                ios_angle = 122 * i_battery;
            }

            this._updateTransform($("#vehicle-string"),vehicle_angle);
            this._updateTransform($("#ios-string"),ios_angle);
        };

        private _cameraPositionChanged = (pos: string)=> {
            if(this._isDouble && pos == "back"){
                $("#remote-video").css({
                    "-webkit-transform": 'rotateY(180deg)',
                    "-moz-transform": 'rotateY(180deg)',
                    "-o-transform": 'rotateY(180deg)',
                    "-ms-transform": 'rotateY(180deg)'
                });
            }else{
                $("#remote-video").css({
                    "-webkit-transform": 'rotateY(0deg)',
                    "-moz-transform": 'rotateY(0deg)',
                    "-o-transform": 'rotateY(0deg)',
                    "-ms-transform": 'rotateY(0deg)'
                });
            }
        };

        private _wiperStateChanged = (inputs: UserInputs)=> {
            if (!this._WiperState && inputs.flag) {
                this._WiperState=true;
                $(".wiper").addClass("wiper-rotate");
                setTimeout(() =>{
                    $(".wiper").removeClass("wiper-rotate");
                },500);

                this._Timer=setInterval(function(){
                    $(".wiper").addClass("wiper-rotate");
                    setTimeout(() =>{
                        $(".wiper").removeClass("wiper-rotate");
                    },500);
                },1000);
            }else if(this._WiperState && inputs.flag){
                this._WiperState=false;
                clearInterval(this._Timer)
            }
        };

        private _drivingStateChanged = (inputs: UserInputs)=>{

            if((inputs.type === InputType.Right || inputs.type === InputType.Left) && inputs.flag){
                this._radius = inputs.value;
            }

            switch (this._DrivingState) {
                case "StopMoving":
                    switch (inputs.type) {
                        case Vehicle.InputType.Front:
                            if (inputs.flag) this._DrivingState = "DrivingForward";
                            break;
                        case Vehicle.InputType.Back:
                            if (inputs.flag) this._DrivingState = "DrivingBackward";
                            break;
                        case Vehicle.InputType.Right:
                            if (inputs.flag) this._DrivingState = "RotatingRight";
                            break;
                        case Vehicle.InputType.Left:
                            if (inputs.flag) this._DrivingState = "RotatingLeft";
                            break;
                    }
                    break;
                case "DrivingForward":
                    switch (inputs.type) {
                        case Vehicle.InputType.Front:
                            if (!inputs.flag) this._DrivingState = "StopMoving";
                            break;
                        case Vehicle.InputType.Back:
                            if (inputs.flag) this._DrivingState = "DrivingBackward";
                            break;
                        case Vehicle.InputType.Right:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyForwardRight";
                            break;
                        case Vehicle.InputType.Left:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyForwardLeft";
                            break;
                    }
                    break;
                case "DrivingBackward":
                    switch (inputs.type) {
                        case Vehicle.InputType.Front:
                            if (inputs.flag) this._DrivingState = "DrivingForward";
                            break;
                        case Vehicle.InputType.Back:
                            if (!inputs.flag) this._DrivingState = "StopMoving";
                            break;
                        case Vehicle.InputType.Right:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyBackwardRight";
                            break;
                        case Vehicle.InputType.Left:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyBackwardLeft";
                            break;
                    }
                    break;
                case "RotatingRight":
                    switch (inputs.type) {
                        case Vehicle.InputType.Front:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyForwardRight";
                            break;
                        case Vehicle.InputType.Back:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyBackwardRight";
                            break;
                        case Vehicle.InputType.Right:
                            if (!inputs.flag) this._DrivingState = "StopMoving";
                            break;
                        case Vehicle.InputType.Left:
                            if (inputs.flag) this._DrivingState = "RotatingLeft";
                            break;
                    }
                    break;
                case "RotatingLeft":
                    switch (inputs.type) {
                        case Vehicle.InputType.Front:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyForwardLeft";
                            break;
                        case Vehicle.InputType.Back:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyBackwardLeft";
                            break;
                        case Vehicle.InputType.Right:
                            if (inputs.flag) this._DrivingState = "RotatingRight";
                            break;
                        case Vehicle.InputType.Left:
                            if (!inputs.flag) this._DrivingState = "StopMoving";
                            break;
                    }
                    break;
                case "DrivingDiagonallyForwardRight":
                    switch (inputs.type) {
                        case Vehicle.InputType.Front:
                            if (!inputs.flag) this._DrivingState = "RotatingRight";
                            break;
                        case Vehicle.InputType.Back:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyBackwardRight";
                            break;
                        case Vehicle.InputType.Right:
                            if (!inputs.flag) this._DrivingState = "DrivingForward";
                            break;
                        case Vehicle.InputType.Left:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyForwardLeft";
                            break;
                    }
                    break;
                case "DrivingDiagonallyForwardLeft":
                    switch (inputs.type) {
                        case Vehicle.InputType.Front:
                            if (!inputs.flag) this._DrivingState = "RotatingLeft";
                            break;
                        case Vehicle.InputType.Back:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyBackwardLeft";
                            break;
                        case Vehicle.InputType.Right:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyForwardRight";
                            break;
                        case Vehicle.InputType.Left:
                            if (!inputs.flag) this._DrivingState = "DrivingForward";
                            break;
                    }
                    break;
                case "DrivingDiagonallyBackwardRight":
                    switch (inputs.type) {
                        case Vehicle.InputType.Front:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyForwardRight";
                            break;
                        case Vehicle.InputType.Back:
                            if (!inputs.flag) this._DrivingState = "RotatingRight";
                            break;
                        case Vehicle.InputType.Right:
                            if (!inputs.flag) this._DrivingState = "DrivingBackward";
                            break;
                        case Vehicle.InputType.Left:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyBackwardLeft";
                            break;
                    }
                    break;
                case "DrivingDiagonallyBackwardLeft":
                    switch (inputs.type) {
                        case Vehicle.InputType.Front:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyForwardLeft";
                            break;
                        case Vehicle.InputType.Back:
                            if (!inputs.flag) this._DrivingState = "RotatingLeft";
                            break;
                        case Vehicle.InputType.Right:
                            if (inputs.flag) this._DrivingState = "DrivingDiagonallyBackwardRight";
                            break;
                        case Vehicle.InputType.Left:
                            if (!inputs.flag) this._DrivingState = "DrivingBackward";
                            break;
                    }
                    break;
            }

            this._changeDrivingDisplay();
        };

        private _changeDrivingDisplay = ()=>{
            if(this._DrivingState.indexOf("Diagonally") >= 0){
                if(this._DrivingState.indexOf("Left") >=0 ){
                    this._updateTransform($("#handle"), this._radius * -120);
                }else{
                    this._updateTransform($("#handle"), this._radius * 120);
                }
                this._updateTransform($("#string"), this._gear2value[this._currentGear] * 140);
            }else if(this._DrivingState.indexOf("Rotating") >= 0){
                if(this._DrivingState.indexOf("Left") >=0 ){
                    this._updateTransform($("#handle"), this._radius * -120);
                }else{
                    this._updateTransform($("#handle"), this._radius * 120);
                }
                this._updateTransform($("#string"), this._radius * 50);
            }else if(this._DrivingState.indexOf("Stop") >= 0){
                this._updateTransform($("#handle"), 0);
                this._updateTransform($("#string"), 0);
            }else{
                this._updateTransform($("#handle"), 0);
                this._updateTransform($("#string"), this._gear2value[this._currentGear] * 180);
            }
        };

        private _updateTransform = ($dom:JQuery, value:number)=>{
            $dom.css({
                "-webkit-transform": 'rotate('+value+'deg)',
                "-moz-transform": 'rotate('+value+'deg)',
                "-o-transform": 'rotate('+value+'deg)',
                "-ms-transform": 'rotate('+value+'deg)'
            })
        };
    }
}

