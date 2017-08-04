//
//  ViewController.swift
//  NetworkManager
//
//  Created by XPan on 2017/8/4.
//  Copyright © 2017年 XPan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func otherClick(_ sender: Any) {
        
    }
    @IBAction func getClick(_ sender: Any) {
        NetworkRequest.share.request(urlString: "https://httpbin.org/get", successClousure: { (respose) in
            print(respose)
        }) { (err) in
            print(err)
        }
    }
    @IBAction func postClick(_ sender: Any) {
        NetworkRequest.share.requestDataWithUrl("https://httpbin.org/post", method: .post, successClousure: { (respose) in
            print(respose)
        }) { (er) in
            print(er)
        }
    }
    @IBAction func downClick(_ sender: Any) {
      let request =   NetworkRequest.share.downloadFileWithUrl("http://lotus.sp.iqiyi.com/ota?id=&pubplatform=6&pubarea=pcltdown_inner&qipuid=&u=&pu=", savedPath: "/Users/guanliyuan/Desktop/未命名文件夹/未命名文件夹/ppppppy", successClousure: { (respose, url) in
            print(respose)
        }, failClousure: { (er) in
            print(er)
        }) { (progress) in
             print(progress.completedUnitCount)
        }
      
    }
}

