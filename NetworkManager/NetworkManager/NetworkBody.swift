//
//  NetworkBody.swift
//  NetworkManager
//
//  Created by XPan on 2017/8/4.
//  Copyright © 2017年 XPan. All rights reserved.
//

import UIKit

class NetworkBody: NSObject {
    ///业务
    public var sData : String?
    ///签名
    public var sign : String?
    ///最后输出的要合进请求参数的字典
    public var body : [String : Any]?
}
