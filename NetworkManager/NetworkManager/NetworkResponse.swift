//
//  NetworkResponse.swift
//  NetworkManager
//
//  Created by XPan on 2017/8/4.
//  Copyright © 2017年 XPan. All rights reserved.
//

import UIKit

class NetworkResponse: NSObject {
   
    public var code : NSString? //请求返回码
    public var msg  : NSString? //请求描述
    public var data : NSDictionary? //业务数据
}
