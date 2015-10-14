/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="./UserInputs.ts" />

module Vehicle {
    export class Keyboard extends EventEmitter2 {

        private _keyState = {};

        constructor() {
            super();

            document.onkeydown = this._keyDown;
            document.onkeyup = this._keyUp;
        }

        private _keyDown = (event: KeyboardEvent)=>{
            var input = this._createUserInputs(event.keyCode, true);
            if(!this._keyState.hasOwnProperty(event.keyCode.toString())) this._keyState[event.keyCode] = false;
            if(!this._keyState[event.keyCode.toString()]) {
                this.emit("inputs", input);
            }
            this._keyState[event.keyCode.toString()] = true;
        };

        private _keyUp = (event: KeyboardEvent)=>{
            var input = this._createUserInputs(event.keyCode, false);
            this.emit("inputs", input);
            this._keyState[event.keyCode.toString()] = false;
        };

        private _createUserInputs(keyCode: number, flag: boolean, value?: number): UserInputs{
            var type: InputType;
            switch (keyCode){
                case 38://↑
                    type = InputType.Front;
                    value = 1.0;
                    break;
                case 40://↓
                    type = InputType.Back;
                    value = 1.0;
                    break;
                case 37://←
                    type = InputType.Left;
                    value = 0.5;
                    break;
                case 39://→
                    type = InputType.Right;
                    value = 0.5;
                    break;
                case 81://Q key
                    type = InputType.HeadUp;
                    break;
                case 65://A key
                    type = InputType.HeadDown;
                    break;
                case 85://U key
                    type = InputType.GearUp;
                    break;
                case 78://N key
                    type = InputType.GearDown;
                    break;
                case 80://P key
                    type = InputType.Button1;
                    break;

                case 32://space key
                    type = InputType.SwitchCamera;
                    break;

                case 87://W key
                    type = InputType.Wiper;
                    break;
                case 83://S key
                    type = InputType.Shot;
                    break;

                case 77://M key
                    type = InputType.Mic;
                    break;

                default:
                    type = InputType.Misc;
            }

            if(value === undefined) return {type: type, flag: flag};

            return {type: type, flag: flag, value: value};
        }
    }
}
