
module Vehicle {
    export enum InputType{
        Front = <any>"DrivingForward",
        Back = <any>"DrivingBackward",
        Right  = <any>"RotatingRight",
        Left  = <any>"RotatingLeft",
        Button1 = <any>"Button1",
        Button2 = <any>"Button2",
        Button3 = <any>"Button3",
        Button4 = <any>"Button4",
        Button5 = <any>"Button5",
        Button6 = <any>"Button6",
        HeadUp = <any>"HeadingUp",
        HeadDown = <any>"HeadingDown",
        Misc = <any>"Misc"
    }

    export interface UserInputs{
        type: InputType;
        flag: boolean;
        value?: number;
    }
}
