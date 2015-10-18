//
//  ViewController.swift
//  uniken4App
//
//  Created by User on 2015/10/16.
//  Copyright © 2015年 uniken4. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Socket_IO_Client_Swift  //追加

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var socket: SocketIOClient!
    var lm: CLLocationManager!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var labelLatitude: UILabel!
    @IBOutlet weak var labelLongitude: UILabel!
    @IBOutlet weak var mv: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ↓Socket Code Block↓
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = appDelegate.socket
        
        socket.on("from_server") { (data, emitter) in
            if let message = data as? [String] {
                self.myLabel.text = message[0]
            }
        }
        // ↑Socket Code Block↑
        
        // ↓Mapkit Code Block↓
        lm = CLLocationManager()
        lm.delegate = self
        lm.distanceFilter = 10                                     //距離のフィルタ
        lm.desiredAccuracy = kCLLocationAccuracyBestForNavigation  //精度
        
        //セキュリティステータスを取得
        let status = CLLocationManager.authorizationStatus()
        //認証が得られていない場合は、認証ダイアログを表示
        if(status == CLAuthorizationStatus.NotDetermined){
            lm.requestAlwaysAuthorization()
        }
        
        //位置情報の更新を開始
        lm.startUpdatingLocation()
        
        mv.delegate = self
        
        // ↑Mapkit Code Block↑
    }
    
    // ↓Mapkit Code Block↓
        
    // 位置情報取得成功時
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got Location")
        // 配列から現在座標を取得
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        let myLocation:CLLocationCoordinate2D = myLastLocation.coordinate

        self.labelLatitude.text = String(myLocation.latitude)
        self.labelLongitude.text = String(myLocation.longitude)
        
        // 縮尺.
        let myLatDist : CLLocationDistance = 2000
        let myLonDist : CLLocationDistance = 2000
        
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation, myLatDist, myLonDist);
        
        // MapViewに反映.
        mv.setRegion(myRegion, animated: true)
    }
    
    // 位置情報取得失敗時
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error")
    }
    
    // 認証が変更された時に呼び出されるメソッド
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case .AuthorizedWhenInUse:
            print("AuthorizedWhenInUse")
        case .Authorized:
            print("Authorized")
        case .Denied:
            print("Denied")
        case .Restricted:
            print("Restricted")
        case .NotDetermined:
            print("NotDetermined")
        default:
            print("etc.")
        }
    }

    // Regionが変更された時に呼び出されるメソッド
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }
    
    // ↑Mapkit Code Block↑

    @IBAction func pushButton(sender: UIButton) {
        socket.emit("from_client", "button pushed!!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

