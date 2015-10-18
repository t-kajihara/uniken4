//
//  AppDelegate.swift
//  uniken4App
//
//  Created by User on 2015/10/16.
//  Copyright © 2015年 uniken4. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift  //追加

// Enter your APIkey and Domain
// Please check this page. >> https://skyway.io/ds/
let kAPIkey = "ad1c9cc0-c1ed-4e9b-a5fe-fcf9d275042a"
let kDomain = "54.92.61.229"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var socket: SocketIOClient!
    var peer:   SKWPeer!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //////////////////////////////////////////////////////////////////////////////////
        ///////////////////// START: Set Socket Initialize Block   ///////////////////////
        //////////////////////////////////////////////////////////////////////////////////
        socket = SocketIOClient(socketURL: "http://54.92.61.229:3000/socket.io/", opts: nil)
        
        // イベントコールバックの設定
        socket.on("connect") { data in
            print("socket connected!!")
        }
        socket.on("disconnect") { data in
            print("socket disconnected!!")
        }
        socket.connect()
        //////////////////////////////////////////////////////////////////////////////////
        /////////////////////  EBD : Socket Initialize Block   ///////////////////////////
        //////////////////////////////////////////////////////////////////////////////////
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

