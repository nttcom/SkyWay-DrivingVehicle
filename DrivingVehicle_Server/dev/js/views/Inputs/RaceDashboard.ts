/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../views/Inputs/UserInputs.ts" />

module Vehicle{

    export enum BatteryMessage{
        VehicleBattery = <any>"VehicleBattery",
        IOSBattery = <any>"IOSBattery",
    }
    export class RaceDashboard{

        private _DrivingState: string = "StopMoving";
        private _WiperState: boolean = false;
        private _Timer: any;

        public onData = (data)=>{
            if(data.hasOwnProperty(Vehicle.BatteryMessage.VehicleBattery) && data.hasOwnProperty(Vehicle.BatteryMessage.IOSBattery)){
                this.batteryChanged(data[Vehicle.BatteryMessage.VehicleBattery],data[Vehicle.BatteryMessage.IOSBattery]);
            }
        };

        public batteryChanged = (v_battery: number, i_battery: number)=>{
            var vehicle_angle:number = 0;
            var ios_angle:number = 0;
            if(v_battery <= 1 && v_battery >= 0){
                vehicle_angle = 122 * v_battery;
            }

            if(i_battery <= 1 && i_battery >= 0){
                ios_angle = 122 * i_battery;
            }

            $("#vehicle-string").css({
                    "-webkit-transform": 'rotate('+vehicle_angle+'deg)',
                    "-moz-transform": 'rotate('+vehicle_angle+'deg)',
                    "-o-transform": 'rotate('+vehicle_angle+'deg)',
                    "-ms-transform": 'rotate('+vehicle_angle+'deg)'
                });
            $("#ios-string").css({
                    "-webkit-transform": 'rotate('+ios_angle+'deg)',
                    "-moz-transform": 'rotate('+ios_angle+'deg)',
                    "-o-transform": 'rotate('+ios_angle+'deg)',
                    "-ms-transform": 'rotate('+ios_angle+'deg)'
                });
        };

        public stateChanged = (inputs: UserInputs)=>{
            if(inputs.type === Vehicle.InputType.Front ||inputs.type === Vehicle.InputType.Back || inputs.type === Vehicle.InputType.Right || inputs.type === Vehicle.InputType.Left) {
                $("#handle").removeClass(this._DrivingState);
                $("#string").removeClass(this._DrivingState);
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
                $("#handle").addClass(this._DrivingState);
                $("#string").addClass(this._DrivingState);
            }else{
                switch (inputs.type) {
                    case Vehicle.InputType.Button5:
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
                        break;
                }
            }
        }
    }
}

