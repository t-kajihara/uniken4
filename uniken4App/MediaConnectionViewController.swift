//
//  MediaConnectionViewController.swift
//  uniken4App
//
//  Created by User on 2015/10/17.
//  Copyright © 2015年 uniken4. All rights reserved.
//

import UIKit
import AVFoundation

enum ViewTag: Int
{
    case TAG_ID = 1000
    case TAG_WEBRTC_ACTION
    case TAG_REMOTE_VIDEO
    case TAG_LOCAL_VIDEO
}

enum AlertType
{
    case ALERT_ERROR
    case ALERT_CALLING
}


class MediaConnectionViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var myLabel: UILabel!
    var i: Int = 0
    var peer:       SKWPeer!
    var ownPeerID:  String!
    var msLocal:    SKWMediaStream!
    var msRemote:   SKWMediaStream!
    var mediaConn:  SKWMediaConnection!
    var bConnected: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.ownPeerID = nil
        self.bConnected = false
        
        if self.navigationController != nil {
            self.navigationController!.delegate = self
        }
        
        //////////////////////////////////////////////////////////////////////
        //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓  START: peer 初期設定  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓//
        //////////////////////////////////////////////////////////////////////
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        peer = appDelegate.peer
        
        SetPeerCallBacks(peer)
        
        //////////////////////////////////////////////////////////////////////
        //↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑   END : peer 初期設定  ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑//
        //////////////////////////////////////////////////////////////////////
        
        
        //////////////////////////////////////////////////////////////////////
        //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓  START: LocalStream取得  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓//
        //////////////////////////////////////////////////////////////////////
        
        SKWNavigator.initialize(peer)
        let constraints: SKWMediaConstraints = SKWMediaConstraints()
        constraints.maxHeight = 960
        constraints.maxWidth  = 540
        constraints.cameraPosition = SKWCameraPositionEnum.CAMERA_POSITION_BACK     // バックカメラを使う
//        constraints.cameraPosition = SKWCameraPositionEnum.CAMERA_POSITION_BACK     // フロントカメラを使う
        msLocal = SKWNavigator.getUserMedia(constraints)
        
        //////////////////////////////////////////////////////////////////////
        //↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑   END : LocalStream取得  ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑//
        //////////////////////////////////////////////////////////////////////
        
        
        //////////////////////////////////////////////////////////////////////
        //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓  START: カメラViewの初期設定  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓//
        //////////////////////////////////////////////////////////////////////
        
        if self.navigationItem.title == nil{
            self.navigationItem.title = "MediaConnection"
        }
        var rcScreen: CGRect = self.view.bounds
        print("iOS ver." + String(NSFoundationVersionNumber))
        if NSFoundationVersionNumber_iOS_6_1 < NSFoundationVersionNumber{
            
            var fValue: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
            rcScreen.origin.y = fValue
            if self.navigationController != nil{
                if self.navigationController!.navigationBarHidden {
                    fValue = self.navigationController!.navigationBar.frame.size.height
                    rcScreen.origin.y += fValue
                }
            }
        }
        
        // 相手の画面
        var rcRemote: CGRect = CGRectZero
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            // iPad
            rcRemote.size.width = 480.0
            rcRemote.size.height = 480.0
        }else{
            //iPhone
            rcRemote.size.width = rcScreen.size.width
            rcRemote.size.height = rcScreen.size.height
        }
        rcRemote.origin.x = (rcScreen.size.width - rcRemote.size.width)/2.0
        rcRemote.origin.y = (rcScreen.size.height - rcRemote.size.height)/2.0
        rcRemote.origin.y -= 8.0
        
        // 自分の画面
        var rcLocal: CGRect = CGRectZero
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            // iPad
            rcLocal.size.width = rcScreen.size.width / 5.0
            rcLocal.size.height = rcScreen.size.height / 5.0
        }else{
            //iPhone
            rcLocal.size.width = rcScreen.size.height/5.0
            rcLocal.size.height = rcScreen.size.width
        }
        rcLocal.origin.x = rcScreen.size.width - rcLocal.size.width - 8.0
        rcLocal.origin.y = rcScreen.size.height - rcLocal.size.height - 8.0
        if self.navigationController != nil {
            rcLocal.origin.y -= self.navigationController!.toolbar.frame.size.height
        }
        
        //////////////////////////////////////////////////////////////////////
        //↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑   END : カメラViewの初期設定  ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑//
        //////////////////////////////////////////////////////////////////////
        
        
        //////////////////////////////////////////////////////////////////////
        //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓  START: SKWVideoを追加  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓//
        //////////////////////////////////////////////////////////////////////
        
        // 相手のVideo
        var vwRemote: SKWVideo = SKWVideo(frame: rcRemote)
        self.view.addSubview(vwRemote)
        
        // 自分のVideo
        var vwLocal: SKWVideo = SKWVideo(frame: rcLocal)
//        self.localVideoView.tag = ViewTag.TAG_LOCAL_VIDEO.rawValue
//        self.localVideoView.addSubview(vwLocal)
        self.view.addSubview(vwLocal)
        
        vwLocal.addSrc(msLocal, track: 0)
        
        //////////////////////////////////////////////////////////////////////
        //↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑   END : SKWVideoを追加  ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑//
        //////////////////////////////////////////////////////////////////////
        
    }
    
    // Peerのイベントコールバック設定
    func SetPeerCallBacks(peer: SKWPeer!){
        if peer == nil {
            return
        }
        
        //////////////////////////////////////////////////////////////////////
        //////////////////  START: Peer Event Callback Set  //////////////////
        //////////////////////////////////////////////////////////////////////
        // EVENT: OPEN
        peer.on(SKWPeerEventEnum.PEER_EVENT_OPEN){obj in
            dispatch_async(dispatch_get_main_queue(), {
                if obj.isKindOfClass(NSString) == true {
                    print ("peer open ID is " + String(obj) )
                    self.ownPeerID = String(obj)
                    self.myLabel.text = "Your ID: " + self.ownPeerID
                }
            })
        }
        
        // EVENT: CALL
        peer.on(SKWPeerEventEnum.PEER_EVENT_CALL) {obj in
            if obj.isKindOfClass(SKWMediaConnection) == true {
                print("peer call")
                self.mediaConn = obj as! SKWMediaConnection
                
                // Media接続
                self.setMediaCallback(self.mediaConn)
                self.mediaConn.answer(self.msLocal)
                
            }
        }
        
        // EVENT: CLOSE
        peer.on(SKWPeerEventEnum.PEER_EVENT_CLOSE) {obj in
            print("peer close " + String(obj))
        }
        
        // EVENT: DISCONNECTED
        peer.on(SKWPeerEventEnum.PEER_EVENT_DISCONNECTED) {obj in
            print("peer disconnected " + String(obj))
        }
        
        // EVENT: ERROR
        peer.on(SKWPeerEventEnum.PEER_EVENT_ERROR) {obj in
            print("peer error " + String(obj))
        }
        //////////////////////////////////////////////////////////////////////
        //////////////////   END : Peer Event Callback Set ///////////////////
        //////////////////////////////////////////////////////////////////////
    }
    
    // mediaStreamのイベントコールバックの設定
    func setMediaCallback(mediaConn: SKWMediaConnection!){
        if mediaConn == nil{
            return
        }
        
        //////////////////////////////////////////////////////////////////////
        //////////////////  START: Media Event Callback Set  /////////////////
        //////////////////////////////////////////////////////////////////////
        // EVENT: STREAM
        mediaConn.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_STREAM) {obj in
//            if obj.isKindOfClass(SKWMediaStream) == true {
            if obj.isKindOfClass(SKWMediaStream) {
                print("Media Stream receve " + String(obj))
                var stream: SKWMediaStream = obj as! SKWMediaStream
                //stream 接続
                self.setRemoteView(stream)
            }
        }
        
        // EVENT: CLOSE
        mediaConn.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_CLOSE) {obj in
            print("Media Stream close " + String(obj))
            self.closedMedia()
        }
        
        // EVENT: ERROR
        mediaConn.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_ERROR) {obj in
            print("Media Stream error " + String(obj))
        }
        //////////////////////////////////////////////////////////////////////
        //////////////////   END : Media Event Callback Set  /////////////////
        //////////////////////////////////////////////////////////////////////
    }
    
    // 相手のMediaStreamを設定
    func setRemoteView(stream: SKWMediaStream!) {
        if bConnected! {
            return
        }
        bConnected = true
        msRemote = stream
//        self.updateActionButtonTitle()
        dispatch_async(dispatch_get_main_queue(), {
            var vwRemote: SKWVideo = self.view as! SKWVideo
//            if vwRemote != nil {
                vwRemote.addSrc(self.msRemote, track: 0)
//            }
            
        })
    }
    
    func unsetRemoteView(){
        if !bConnected {
            return
        }
        
        bConnected = false
        
        var vwRemote = self.view as! SKWVideo
        
        if msRemote != nil {
            //            if vwRemote != nil {
            vwRemote.removeSrc(msRemote, track: 0)
            //            }
            msRemote.close()
            msRemote = nil
        }
        
        //        if vwRemote != nil {
        dispatch_async(dispatch_get_main_queue(), {
            vwRemote.userInteractionEnabled = false
            vwRemote.hidden = false
        })
        //        }
        
    }
    
    func closedMedia(){
        self.unsetRemoteView()
        clearMediaCallbacks(mediaConn)
        
        mediaConn = nil
    }
    
    func clearMediaCallbacks(media: SKWMediaConnection!) {
        if media == nil {
            return
        }
        
        media.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_STREAM, callback: nil)
        media.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_CLOSE, callback: nil)
        media.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_ERROR, callback: nil)
    }
    
    
    
    // デストラクタ
    deinit{
        print("call deinit")
        msLocal = nil
        msRemote = nil
        ownPeerID = nil
        mediaConn = nil
        peer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func changeCamera(sender: UIButton) {
        // カメラの変更
        if msLocal == nil {
            return
        }
        
        var pos: SKWCameraPositionEnum = msLocal.getCameraPosition()
    
        if pos == SKWCameraPositionEnum.CAMERA_POSITION_BACK{
            pos = SKWCameraPositionEnum.CAMERA_POSITION_FRONT
        }
        else if pos == SKWCameraPositionEnum.CAMERA_POSITION_FRONT{
            pos = SKWCameraPositionEnum.CAMERA_POSITION_BACK
        }
        else{
            return
        }
        msLocal.setCameraPosition(pos)
        
    }
    
    @IBAction func push(sender: UIButton) {
        i++
        self.myLabel.text = "push " + String(i)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
