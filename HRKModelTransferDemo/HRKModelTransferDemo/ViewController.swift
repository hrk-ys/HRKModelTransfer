//
//  ViewController.swift
//  HRKModelTransferDemo
//
//  Created by Hiroki Yoshifuji on 2015/09/10.
//  Copyright (c) 2015年 hiroki.yoshifuji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        MagicalRecord.setupCoreDataStackWithInMemoryStore()
        
        HRKModelTransfer.setup()
        var manager = AFHTTPRequestOperationManager()
        
        manager.GET("http://localhost:4567/users.json", parameters: nil, success: { (operation:AFHTTPRequestOperation, responseObject:AnyObject) -> Void in
//            var models:AnyObject = HRKModelTransfer.transfer(responseObject)
            
            var users:[User] = HRKModelTransfer.transferWithModelName("User", JSONObject: responseObject) as! [User]
            println(users)
        }) { (AFHTTPRequestOperation, NSError) -> Void in
        }
        
        manager.GET("http://localhost:4567/resource.json", parameters: nil, success: { (operation:AFHTTPRequestOperation, responseObject:AnyObject) -> Void in
            var models:AnyObject = HRKModelTransfer.transfer(responseObject)
            println(models)
        }) { (AFHTTPRequestOperation, NSError) -> Void in
        }    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

