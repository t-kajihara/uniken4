//
//  NWObserver.swift
//  uniken4App
//
//  Created by User on 2015/10/17.
//  Copyright © 2015年 uniken4. All rights reserved.
//

import Foundation

protocol NWObserver{
    func onMessage(dict: Dictionary<String, AnyObject>)
}