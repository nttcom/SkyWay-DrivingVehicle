##DrivingVehicle_Server
The server for the web app that connects to the DrivingVehicle application using WebRTC and controls the Romo/Double

###How to build
 1. Install [Node.js](https://nodejs.org/) to make the npm command available
 1. Install grunt-cli
 
 ```bash
 npm install -g grunt-cli
 ```
 
 1. Run the commands below
 
  ```bash
  DrivingVehicle$ cd  DrivingVehicle_Server
  DrivingVehicle_Server$ npm install
  DrivingVehicle_Server$ grunt setup
  ```

 1. Set _APIKey to your API key registered on SkyWay.io at the top of /dev/js/views/pages/index.ts and /dev/js/models/PeerManager.ts
 
 ```javascript
 //// inside index.ts and PeerManager.ts
 private _APIkey: string = "yourAPIkey";
 ```
 
 1. Run the command below and confirm that the dist directory is created

  ```bash
  DrivingVehicle_Server$ grunt build
  DrivingVehicle_Server$ cd dist
  ```

###How to use
 1. First, Run application of the iOS device
 1. Run the server (ex. python -m SimpleHTTPServer [on Mac]) on a [Domain registered on SkyWay.io](https://skyway.io/ds/)
 1. Access index.html in the dist folder using a Web browser (Chrome is recommended)
 1. Select the mode for the device you want to access<sup>*1</sup>
  - ALL: nomal mode(landscape, 16:9 is recommended)
  - Android: mode for Android(portrait、tested on Android Chrome 43)
  - Race: simple portrait mode (w/o photo function etc.)
 1. How to Control
  - q (Android: swiping up on the robot's view): look upward
  - a (Android: swiping down): look downward
  - u (except for Android): speed up
  - n (except for Android): slow down
  - up(↑): drive forward
  - down(↓): drive backward
  - left(←): rotate left
  - right(→): rotate right
  
  please check other key bindings in /dev/js/views/Inputs/Keyboard.ts

> *1. If the iOS device is not listed, please check below
>   - DrivingVehicle application
>    - Internet connection
>    - APIkey
>    - Domain
>   - DrivingVehicle_Server
>    - Internet connection
>    - APIkey
>    - Domain of server

　
---

DrivingVehicleで動作しているアプリに対してWebRTCで接続し、 コントロールを行うページ用のサーバ。

###ビルド方法
 1. [Node.js](https://nodejs.org/)をインストールし、npmコマンドを利用可能とする
 1. grunt-cliをインストール
 
 ```bash
 npm install -g grunt-cli
 ```
 
 1. 下記コマンドを実行

  ```bash
  DrivingVehicle$ cd  DrivingVehicle_Server
  DrivingVehicle_Server$ npm install
  DrivingVehicle_Server$ grunt setup
  ```

 1. /dev/js/views/pages/index.ts及び、/dev/js/models/PeerManager.ts内のAPIkeyを入力する
 
 ```javascript
 //// index.ts and PeerManager.ts内
 private _APIkey: string = "yourAPIkey";
 ```
 
 1. 下記コマンドを実行(distが作られているか確認)

  ```bash
  DrivingVehicle_Server$ grunt build
  DrivingVehicle_Server$ cd dist
  ```

###利用方法
 1. 先にiOS端末側のアプリを起動
 1. [SkyWayに登録したドメイン](https://skyway.io/ds/)でサーバを起動(例: Macならpython -m SimpleHTTPServer 等)
 1. distフォルダ内に作られたindex.htmlにWebブラウザ(Chrome推奨)でアクセス
 1. アクセスしたい端末のモード名を選択<sup>*1</sup>
  - ALL: 通常モード(横画面、16:9が最適)
  - ALL(mute): 通常モードのmuteバージョン
  - Android: Android用モード(縦画面、Android Chrome 43で動作確認済み)
  - Race: 縦画面モード(写真機能等は無し)
 1. 操作方法
  - q (Android: robot側の映像を↑にスワイプ): 上を向く
  - a (Android: ↓にスワイプ): 下を向く
  - u (Android以外): シフトアップ
  - n (Android以外): シフトダウン
  - 上(↑): 前進
  - 下(↓): 後退
  - 左(←): 左回転
  - 右(→): 右回転
  
　他のキー操作は /dev/js/views/Inputs/Keyboard.ts を見てください

> *1. もし表示されない場合は、以下を確認してください
>  - DrivingVehicleアプリ
>   - インターネット接続
>   - APIキー
>   - ドメイン
>  - DrivingVehicle_Server
>   - インターネット接続
>   - APIキー
>   - 動いているサーバのドメイン
