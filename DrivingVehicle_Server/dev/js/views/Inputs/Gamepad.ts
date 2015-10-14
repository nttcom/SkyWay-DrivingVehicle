/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="./UserInputs.ts" />

module Vehicle{
    export class Gamepad extends EventEmitter2{
        private _ticking: boolean;
        private _gamepads: Array<any>;
        private _prevRawGamepadTypes: Array<any>;
        private _TYPICAL_BUTTON_COUNT: number;
        private _TYPICAL_AXIS_COUNT: number;
        private _lastButtons: Array<any>;
        private _lastAxes: Array<any>;


        constructor(){
            super();

            this._ticking = false;
            this._gamepads = [];
            this._prevRawGamepadTypes = [];
            this._TYPICAL_BUTTON_COUNT = 16;
            this._TYPICAL_AXIS_COUNT = 4;
            this._lastButtons = [];
            this._lastAxes = [];

            var gamepadSupportAvailable = navigator.getGamepads ||
                !!navigator.webkitGetGamepads;

            if (!gamepadSupportAvailable) {
            } else {
                if ('ongamepadconnected' in window) {
                    window.addEventListener('gamepadconnected',
                        this._onGamepadConnect, false);
                    window.addEventListener('gamepaddisconnected',
                        this._onGamepadDisconnect, false);
                } else {
                    this._startPolling();
                }
            }
        }

        private _onGamepadConnect = ()=>{
            this._startPolling();
        };

        private _onGamepadDisconnect = ()=>{
        };

        private _startPolling(){
            if (!this._ticking) {
                this._ticking = true;
                this._tick();
            }
        }

        private _tick = ()=>{
            this._pollGamepads();
            this._pollStatus();
            this._scheduleNextTick();
        };

        private _pollStatus(){

            if(this._gamepads.length > 0){

                for(var i=0; i < this._gamepads[0].buttons.length; i++){
                    var button = this._gamepads[0].buttons[i];

                    //PS4controller's bug (when GamePad is connected, shoulder button's value is 0.5)
                    var pressed = (button.value > 0.6);

                    if(i >= this._lastButtons.length) {
                        this._lastButtons[i] = false;
                    }

                    if(this._lastButtons[i]  != pressed) {
                        this.emit("inputs", this._createUserInputs(i, pressed, button.value));
                    }

                    this._lastButtons[i] = pressed;
                }

                for(var i=0; i < this._gamepads[0].axes.length; i++ ){
                    var axe = this._judgeAxe(this._gamepads[0].axes[i]);

                    if(i >= this._lastAxes.length) {
                        this._lastAxes[i] = 0;
                    }


                    if(this._lastAxes[i] != axe) {
                        this.emit("inputs", this._createUserInputsAxe(i, axe, this._lastAxes[i]));
                    }

                    this._lastAxes[i] = axe;
                }

            }
        }

        private _pollGamepads(){
            var rawGamepads =
                (navigator.getGamepads && navigator.getGamepads()) ||
                (navigator.webkitGetGamepads && navigator.webkitGetGamepads());


            if (rawGamepads) {
                this._gamepads = [];

                var gamepadsChanged = false;

                for (var i = 0; i < rawGamepads.length; i++) {
                    if (typeof rawGamepads[i] != this._prevRawGamepadTypes[i]) {
                        gamepadsChanged = true;
                        this._prevRawGamepadTypes[i] = typeof rawGamepads[i];
                    }

                    if (rawGamepads[i]) {
                        this._gamepads.push(rawGamepads[i]);
                    }
                }
            } else{
                this._gamepads = [];
                this._prevRawGamepadTypes = [];
                this._lastButtons = [];
            }
        }

        private _scheduleNextTick(){
            if (this._ticking) {
                if (window.requestAnimationFrame) {
                    window.requestAnimationFrame(this._tick);
                }
            }
        }

        private _createUserInputs(buttonId: number, flag: boolean, value?: number): UserInputs{
            var type: InputType;
            switch (buttonId){
                case 12://↑
                    type = InputType.Front;
                    value = 1.0;
                    break;
                case 13://↓
                    type = InputType.Back;
                    value = 1.0;
                    break;
                case 14://←
                    type = InputType.Left;
                    value = 0.5;
                    break;
                case 15://→
                    type = InputType.Right;
                    value = 0.5;
                    break;
                case 0://×
                    type = InputType.HeadDown;
                    break;
                case 1://○
                    type = InputType.Wiper;
                    break;
                case 2://□
                    type = InputType.SwitchCamera;
                    break;
                case 3://△
                    type = InputType.HeadUp;
                    break;
                case 4://L1
                    type = InputType.GearDown;
                    break;
                case 5://R1
                    type = InputType.GearUp;
                    break;
                case 6://L2
                    type = InputType.Back;
                    value = 1.0;
                    break;
                case 7://R2
                    type = InputType.Front;
                    value = 1.0;
                    break;
                default:
                    type = InputType.Misc;
            }

            if(value === undefined) return {type: type, flag: flag};

            return {type: type, flag: flag, value: value};
        }

        private _judgeAxe(axe: number){
            axe = parseInt((axe * 5).toString()) / 5;
            return axe;
        }

        private _createUserInputsAxe(axeId: number, current: number, previous: number): UserInputs{
            var type: InputType;
            var flag: boolean = false;
            var value: number = 0;
            switch (axeId){
                case 0://x axis
                    if(current < 0){
                        flag = true;
                        type = InputType.Left;
                        value = -1 * current;
                    }else if(current > 0){
                        flag = true;
                        type = InputType.Right;
                        value = current;
                    }else{
                        if(previous < 0){
                            flag = false;
                            type = InputType.Left;
                        }else if(previous > 0){
                            flag = false;
                            type = InputType.Right;
                        }
                    }
                    break;
                case 1://y axis
                    if(current > 0){
                        flag = true;
                        type = InputType.Back;
                        value = current;
                    }else if(current < 0){
                        flag = true;
                        type = InputType.Front;
                        value = -1 * current;
                    }else{
                        if(previous > 0){
                            flag = false;
                            type = InputType.Back;
                        }else if(previous < 0){
                            flag = false;
                            type = InputType.Front;
                        }
                    }
                    break;
                default:
                    type = InputType.Misc;
            }

            return {type: type, flag: flag, value: value};
        }
    }
}
