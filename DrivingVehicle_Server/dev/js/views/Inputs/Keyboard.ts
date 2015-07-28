/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="./UserInputs.ts" />

module Vehicle {
    export class Keyboard extends EventEmitter2 {

        constructor() {
            super();

            document.onkeydown = this._keyDown;
            document.onkeyup = this._keyUp;
        }

        private _keyDown = (event: KeyboardEvent)=>{
            var input = this._createUserInputs(event.keyCode, true);
            this.emit("inputs", input);
        };

        private _keyUp = (event: KeyboardEvent)=>{
            var input = this._createUserInputs(event.keyCode, false);
            this.emit("inputs", input);
        };

        private _createUserInputs(keyCode: number, flag: boolean, value?: number): UserInputs{
            var type: InputType;
            switch (keyCode){
                case 38://↑
                    type = InputType.Front;
                    break;
                case 40://↓
                    type = InputType.Back;
                    break;
                case 37://←
                    type = InputType.Left;
                    break;
                case 39://→
                    type = InputType.Right;
                    break;

                case 72://H key
                    type = InputType.Left;
                    break;
                case 74://J key
                    type = InputType.Front;
                    break;
                case 75://K key
                    type = InputType.Back;
                    break;
                case 76://L key
                    type = InputType.Right;
                    break;
                case 32://space key
                    type = InputType.Button6;
                    break;
                case 78://N key
                    type = InputType.HeadDown;
                    break;
                case 85://U key
                    type = InputType.HeadUp;
                    break;
                case 65://A key
                    type = InputType.Button5;
                    break;
                default:
                    type = InputType.Misc;
            }

            if(value === undefined) return {type: type, flag: flag};

            return {type: type, flag: flag, value: value};
        }
    }
}
