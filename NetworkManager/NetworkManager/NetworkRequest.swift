//
//  NetworkRequest.swift
//  NetworkManager
//
//  Created by XPan on 2017/8/4.
//  Copyright © 2017年 XPan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@objc enum MethodType : NSInteger {
    case get
    case post
}
class NetworkRequest: NSObject {
    //单例 MZGogal 的请求都包含了MZHttpReuestBody  如果不想要body 用NetworkRequest的share单例子
    static let share : NetworkRequest = NetworkRequest()
    ///设置请求超时
    public var timeoutInterval : TimeInterval = 30
    
    ///获取类名 在该类中只用来打印信息方便区别
    fileprivate let className = type(of: self)
    
    fileprivate var  manager : SessionManager!
    
    
    override init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = self.timeoutInterval
        self.manager = SessionManager(configuration: config)

       
    }
    
    
    
    //MARK:  get post 请求
    
    
    /**
     数据请求方法 不带version参数
     
     *  @param urlString 请求Url
     *  @param method 请求方式
     *  @param parameters 请求的参数
     *  @param successClousure 成功的回调
     *  @param failureClousure错误的回调
     */
    @discardableResult
    public func requestDataWithUrl(_ urlString: String, method: MethodType, parameters: [String : Any]? = nil, successClousure: @escaping (_ response : NetworkResponse)->(), failClousure: @escaping (_ error : Error)->()) -> DataRequest{
        
        switch method {
        case .get:
            
            return self.request(urlString: urlString, method: .get, parameters: parameters, successClousure: successClousure, failClousure: failClousure)
            
        case .post:
            return self.request(urlString: urlString, method: .post, parameters:parameters, successClousure: successClousure, failClousure: failClousure)
            
        }
    }
    
    
    /**
     数据请求方法 带有version参数
     
     *  @param urlString 请求Url
     *  @param method 请求方式
     *  @param version 请求当前版本 version 拼接在url后面 若不需要拼接则传nil
     *  @param parameters 请求的参数
     *  @param successClousure 成功的回调
     *  @param failureClousure错误的回调
     */
    @discardableResult
    public func requestDataWithVersion(_ version: String? = nil , urlString: String , method: MethodType, parameters: [String : Any]? = nil, successClousure: @escaping (_ response : NetworkResponse)->(), failClousure: @escaping (_ error : Error)->()) -> DataRequest{
        
        
        switch method {
        case .get:
            
            return  self.request(urlString: urlString, version: version, method: .get, parameters: parameters, successClousure: successClousure, failClousure: failClousure)
            
        case .post:
            return  self.request(urlString: urlString, version: version, method: .post, parameters:parameters, successClousure: successClousure, failClousure: failClousure)
            
        }
        
    }
    
    /**
     数据请求方法 配置header body
     
     *  @param urlString 请求Url
     *  @param method 请求方式
     *  @param version 请求当前版本 version 拼接在url后面 若不需要拼接则传nil
     *  @param parameters 请求的参数
     *  @param header 需要配置的header
     *  @param body 需要配置的应用指定body
     *  @param successClousure 成功的回调
     *  @param failureClousure错误的回调
     */
    @discardableResult
    public func requestDataWithBody(_ body: NetworkBody? = nil, urlString: String, version: String? = nil , method: MethodType, parameters: [String : Any]? = nil, headers: NetworkHeader? = nil,  successClousure: @escaping (_ response : NetworkResponse)->(), failClousure: @escaping (_ error : Error)->()) -> DataRequest{
        
        switch method {
        case .get:
            
            return  self.request(urlString: urlString, version: version, method: .get, parameters: parameters, headers: headers, body:body, successClousure: successClousure, failClousure: failClousure)
            
        case .post:
            return  self.request(urlString: urlString, version: version, method: .post, parameters:parameters, headers: headers, body:body, successClousure: successClousure, failClousure: failClousure)
            
        }
        
    }
    
    
    
    /// Alamofire请求数据 version 拼接在url后面 若不需要拼接则传nil
    @discardableResult
    func request(urlString: String, version: String? = nil, method: HTTPMethod = .get, parameters: [String : Any]? = nil, headers: NetworkHeader? = nil, body: NetworkBody? = nil, successClousure: @escaping (_ response : NetworkResponse)->(), failClousure: @escaping (_ error : Error)->()) -> DataRequest{
        
        var buildUrl = urlString
        if version != nil {
            buildUrl = urlString + version!
        }
        
        var paramDic  = parameters
        if body != nil && body?.body != nil {
            if let parameters = parameters {
                //mz 将parameters转换成json字符串存到key为data 同时生产签名 其他应用直接合并字典 或者根据具体情况进行拓展
                for item in parameters {
                    paramDic?[item.key] = body?.body?[item.key]
                }
            }
        }
        //        print("urlString \(urlString)")
        //        print("paramDic: \(paramDic)")
        
        var header : HTTPHeaders? = nil
        if headers != nil && headers?.headers != nil {
            header = (headers?.headers)!
        }
        
        return self.manager.request(buildUrl, method: method, parameters:paramDic, headers: header).responseJSON { (response) in
            switch response.result {
            case .success:
                print("\(self.className): \(response)")   // result of response serialization
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let networkResponse = NetworkResponse.model(with: value) //YYKit NSObject+YYModel.h
                    //                    print("code : \(networkResponse?.code)")
                    //                    print("msg  : \(networkResponse?.msg)")
                    //                    print("data : \(networkResponse?.data)")
                    successClousure(networkResponse!)
                }
            case .failure(let error):
                failClousure(error)
                print("\(self.className):\(error)")
            }
        }
        
    }
    
    
    //MARK: 下载
    /**
     下载文件
     
     @param urlString 请求地址
     @param parameters 参数
     @param savedPath 保存 在磁盘的位置
     @param successClousure 下载成功回调
     @param failClousure 下载失败回调
     @param progress 实时下载进度回调
     */
    @discardableResult
    public func downloadFileWithUrl(_ urlString: String, parameters: [String : Any]? = nil, savedPath : String , successClousure: @escaping (_ response : URLResponse? ,_ filePath : URL?)->(), failClousure: @escaping (_ error : Error)->() ,progressClousure: @escaping (_ progress : Progress) ->()) -> DownloadRequest{
        
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let fileURL = URL(fileURLWithPath: savedPath)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        return  self.manager.download(urlString, to: destination).response { response in
            
            print("\(self.className): \(response)")
            if response.error != nil{
                failClousure(response.error!)
            }else{
                successClousure(response.response, response.destinationURL)
            }
            
            }.downloadProgress { (progress) in
                print("\(self.className) Progress: \(progress.fractionCompleted)")
                progressClousure(progress)
        }
        
    }
    
    /**
     下载文件 需要header body
     
     @param urlString 请求地址
     @param parameters 参数
     @param savedPath 保存 在磁盘的位置
     @param successClousure 下载成功回调
     @param failClousure 下载失败回调
     @param progress 实时下载进度回调
     */
    @discardableResult
    public func downloadFileWithBody(_ body: NetworkBody? = nil, urlString: String, savedPath : String , parameters: [String : Any]? = nil, headers: NetworkHeader? = nil, successClousure: @escaping (_ response : URLResponse? ,_ filePath : URL?)->(), failClousure: @escaping (_ error : Error)->() ,progressClousure: @escaping (_ progress : Progress) ->()) -> DownloadRequest{
        
        var paramDic  = parameters
        if body != nil && body?.body != nil {
            if let parameters = parameters {
                //mz 将parameters转换成json字符串存到key为data 同时生产签名 其他应用直接合并字典
                for item in parameters {
                    paramDic?[item.key] = body?.body?[item.key]
                }
            }
        }
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let fileURL = URL(fileURLWithPath: savedPath)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            
        }
        
        
        var header : HTTPHeaders? = nil
        if headers != nil && headers?.headers != nil {
            header = (headers?.headers)!
        }
        
        return self.manager.download(urlString, parameters: parameters, headers : header, to: destination).response { response in
            
            print("\(self.className): \(response)")
            if response.error != nil{
                failClousure(response.error!)
            }else{
                successClousure(response.response, response.destinationURL)
            }
            
            }.downloadProgress { (progress) in
                print("\(self.className) Progress: \(progress.fractionCompleted)")
                progressClousure(progress)
        }
        
    }
    
    //MARK:  改变请求状态
    ///取消
    public func cancelAll(){
        if #available(iOS 9.0, *) {
            self.manager.session.getAllTasks { (tasks) in
                for task in tasks {
                    task.cancel()
                }
            }
        }
    }
    
    static func cancleWith(request: Request){
        request.cancel()
    }
    
    ///恢复
    public func resumeAll(){
        if #available(iOS 9.0, *) {
            self.manager.session.getAllTasks { (tasks) in
                for task in tasks {
                    task.resume()
                }
            }
        }
    }
    static func resumeWith(request: Request){
        request.resume()
    }
    //暂停
    public func suspendAll(){
        if #available(iOS 9.0, *) {
            self.manager.session.getAllTasks { (tasks) in
                for task in tasks {
                    task.suspend()
                }
            }
        }
    }
    static func suspendWith(request: Request){
        request.suspend()
    }

}
