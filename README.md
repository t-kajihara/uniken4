# uniken4
2015 ユニシス研究会<br>

#1. 必要なライブラリ、フレームワーク
AudioToolbox.framework<br>
AVFoundation.framework<br>
CoreMedia.framework<br>
CoreVideo.framework<br>
VideoToolbox.framework<br>
CoreGraphoics.framework<br>
Foundation.framework<br>
GLKit.framework<br>
SystemConfiguration.framework<br>
libc++.tbd<br>
libstdc++.6.0.9.tbd<br>
libsqlite3.tbd<br>
libicucore.tbd<br>

#2. SkyWay iOS SDKのインポート
SkyWay.frameworkをXcodeプロジェクトに追加後、SkyWay iOS SDKのヘッダファイルをインポートしてください。また、Build SettingsのLinking > Other Linker Flagsに-ObjCoを設定してください。<br>
Xcode7以上は、Build SettingsのBuild Options > Enable BitcodeをNOに設定してください。<br>


20151018->Swiftでp2p通信 自分のカメラ取得成功 by Kajihara
