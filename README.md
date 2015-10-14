#DrivingVehicle

Sample application for controlling Romo/Double using WebRTC  
DrivingVehicle is composed of the two applications below.

###DrivingVehicle
App for iOS devices connected to the Romo/Double.  
After launching this app and connecting the iOS device to the Romo/Double, then you can control the Romo/Double from the control page on the DrivingVehicle_Server.

###DrivingVehicle_Server
The server for the web app that connects to the DrivingVehicle application using WebRTC to controls the Romo/Double.

###How to use
 1. Register an account on [SkyWay](http://nttcom.github.io/skyway/) and get an API key
 1. Clone or download this repository.
 1. Build and Run according to README of each applications
 
### NOTICE
This application requires v0.2.0+ of SkyWay iOS SDK.

---

Romo/DoubleをWebRTCで操作するサンプルアプリ  
DrivingVehicleは下記の二つのアプリによって構成されています。

###DrivingVehicle
Romo/Doubleに接続するiOS端末用アプリ。  
本アプリを動作させたiOS端末をRomo/Doubleに接続することで、DrivingVehicle_Serverで動作しているコントローラページから操作が可能。

###DrivingVehicle_Server
DrivingVehicleアプリにWebRTCで接続し、コントロールを行うページ用のサーバ。

###利用方法(はじめに)
 1. [SkyWay](http://nttcom.github.io/skyway/)でアカウントを作成し、APIkeyを取得
 1. このレポジトリをクローンまたはダウンロード
 1. 各アプリごとのREADMEに沿ってビルド/実行
 
### 注意事項
本アプリケーションはSkyWay iOS SDKのv0.2.0以降で動作します。

```
+-------------------------+           WebRTC              +--------------------+
|  DrivingVehicle_Server  | <---------------------------> |   DrivingVehicle   |
+-------------------------+                               +--------------------+
            |                                                       |
            |                                                       |
     +-------------+                                         +-------------+
     | Web Browser |                                         | Romo/Double |
     +-------------+                                         +-------------+
```
