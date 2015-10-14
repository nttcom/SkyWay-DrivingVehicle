
module Vehicle {
    export enum InputType{
        Front = <any>"DrivingForward",
        Back = <any>"DrivingBackward",
        Right  = <any>"RotatingRight",
        Left  = <any>"RotatingLeft",
        Button1 = <any>"Button1", //switch parking state(for Double)
        Button2 = <any>"Button2",
        Button3 = <any>"Button3",
        Button4 = <any>"Button4",
        Button5 = <any>"Button5",
        Button6 = <any>"Button6",
        HeadUp = <any>"HeadingUp",
        HeadDown = <any>"HeadingDown",
        HeadingtoAngle = <any>"HeadingtoAngle",
        GearUp = <any>"GearUp",
        GearDown = <any>"GearDown",
        Romo = <any>"Romo",
        SwitchCamera = <any>"SwitchCamera",
        GetCamera = <any>"GetCamera",
        GetVehicleStatus = <any>"GetVehicleStatus", //get battery, angle and parking(Double only) status
        Shot = <any>"Shot",
        Wiper = <any>"Wiper",
        Mic = <any> "Mic",
        Misc = <any>"Misc"
    }

    export interface UserInputs{
        type: InputType;
        flag: boolean;
        value?: number;
    }
}
