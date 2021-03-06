##DrivingVehicle

The application for iOS devices of connecting Romo/Double.

This app is currently compatible with Swift2  

### How to build
 1. Open "DrivingVehicle.xcodeproj"
 1. Download the frameworks below, and copy to the designated folder
    1. Download "SkyWay.framework" from [SkyWay](http://nttcom.github.io/skyway/)
    1. Download "RMCore.framework", "RMCharacter.framework" and "RMCharacter.bundle" from [Romo SDK for iOS](https://github.com/Romotive/Romo/tree/master/SDK/Public/frameworks)
    1. Clone or download "DoubleControlSDK.framework" from [Double's SDK](https://github.com/doublerobotics/Basic-Control-SDK-iOS)
    1. Copy all files to ./DrivingVehicle/frameworks
 1. Add all frameworks to Target (Romo/Double)
    1. Add "SkyWay.framework", "RMCore.framework", "RMCharacter.framework" and "DoubleControlSDK.framework"library to the "Link Binary With Libraries" build phase
    1. Add "RMCharacter.bundle" to the "Copy Bundle Resources" build phase
 1. Set kAPIKey and kDomain to your API key/Domain registered on SkyWay.io at the top of "DrivingVehiclemodels/peer/SkyWay.swift"
 
 ```swift
 // Enter your APIkey and Domain
 // Please check this page. >> https://skyway.io/ds/
 private let kAPIkey:String = "yourAPIkey"
 private let kDomain:String = "yourDomain"
 ```
 1. Select target(Romo or Double) and Build
 
### How to use
 1. Check Internet connection on iOS Device
 1. Connect iOS device to Romo or Double
 1. Run Romo/Double application
 1. The app is ready after DrivingVehicle's splash screen disappears

-----

Romo/Doubleに接続するiOS端末用アプリ。

現在Swift2に対応しています。Swift1には対応していません。  

### ビルド方法
 1. "DrivingVehicle.xcodeproj"を開く
 1. 必要なframeworkをダウンロードして指定のフォルダにコピー
    1. "SkyWay.framework"を[SkyWay](http://nttcom.github.io/skyway/)からダウンロード
    1. "RMCore.framework"、"RMCharacter.framework"、"RMCharacter.bundle"を[RomoのSDKページ](https://github.com/Romotive/Romo/tree/master/SDK/Public/frameworks)からSDKをダウンロードする
    1. "DoubleControlSDK.framework"を[DoubleのSDKページ](https://github.com/doublerobotics/Basic-Control-SDK-iOS)をクローンまたはダウンロード
    1. 上に記載のファイルを./DrivingVehicle/frameworksにコピー
 1. 各フレームワークをTarget(Romo及びDouble)に追加
    1. "SkyWay.framework"、"RMCore.framework"、"RMCharacter.framework"、"DoubleControlSDK.framework"をBuildPhasesの"Link Binary With Libraries"に追加する
    1. "RMCharacter.bundle"をBuild Phasesの"Copy Bundle Resources"に追加する
 1. "DrivingVehicle/models/peer/SkyWay.swift"の上部にあるkAPIKeyとkDomainにAPIkeyとDomainを入力する
 
 ```swift
 // Enter your APIkey and Domain
 // Please check this page. >> https://skyway.io/ds/
 private let kAPIkey:String = "yourAPIkey"
 private let kDomain:String = "yourDomain"
 ```
 1. ターゲットをRomoまたはDoubleのどちらかを選択してビルド

### 利用方法
 1. iOSのインターネット接続を確認する
 1. RomoまたはDoubleに接続する
 1. RomoまたはDoubleアプリを起動する
 1. DrivingVehicleのスプラッシュ画面が消えたら完了
