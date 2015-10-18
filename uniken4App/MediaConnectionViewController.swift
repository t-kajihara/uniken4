//
//  MediaConnectionViewController.swift
//  uniken4App
//
//  Created by User on 2015/10/17.
//  Copyright © 2015年 uniken4. All rights reserved.
//

import UIKit
import AVFoundation

class MediaConnectionViewController: UIViewController{
    
    @IBOutlet weak var myLabel: UILabel!
    var videoOutpu: AVCaptureMovieFileOutput!
    var i: Int = 0
    var peer:       SKWPeer!
    var ownPeerID:  String!
    var mslocal:    SKWMediaStream!
    var msRemote:   SKWMediaStream!
    var mediaConn:  SKWMediaConnection!
    var bConnected: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        peer = appDelegate.peer
        
        SetPeerCallBacks(peer)
        
        

        
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
                
                self.mediaConn.answer(self.mslocal)
                
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
        if mediaConn != nil{
            return
        }
        
        //////////////////////////////////////////////////////////////////////
        //////////////////  START: Media Event Callback Set  /////////////////
        //////////////////////////////////////////////////////////////////////
        // EVENT: STREAM
        mediaConn.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_STREAM) {obj in
            if obj.isKindOfClass(SKWMediaStream) == true{
                print("Media Stream receve " + String(obj))
                var stream: SKWMediaStream = obj as! SKWMediaStream
                //stream 接続
                
            }
        }
        
        // EVENT: CLOSE
        mediaConn.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_CLOSE) {obj in
            print("Media Stream close " + String(obj))
        }
        
        // EVENT: ERROR
        mediaConn.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_ERROR) {obj in
            print("Media Stream error " + String(obj))
        }
        //////////////////////////////////////////////////////////////////////
        //////////////////   END : Media Event Callback Set  /////////////////
        //////////////////////////////////////////////////////////////////////
    }
    
    // 相手のMediaStreamを取得
    func setRemoteView(stream: SKWMediaStream!) {
        if bConnected {
            return
        }
        bConnected = true
        self.msRemote = stream
//        self.updateActionButtonTitle()
        dispatch_async(dispatch_get_main_queue(), {
//            var vwRemote: SKWVideo = self.view.viewWithTag(TAG_REMOTE_VIDEO)
//            if nil != vwRemote {
//                vwRemote.setHidden(false)
//                vwRemote.setUserInteractionEnabled(true)
//                vwRemote.addSrc(_msRemote, track: 0)
//            }
            
        })
    }
    
    
    @IBAction func push(sender: UIButton) {
        i++
        self.myLabel.text = "push " + String(i)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
