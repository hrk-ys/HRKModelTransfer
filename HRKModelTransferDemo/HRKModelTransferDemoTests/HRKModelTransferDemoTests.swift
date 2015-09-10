//
//  HRKModelTransferDemoTests.swift
//  HRKModelTransferDemoTests
//
//  Created by Hiroki Yoshifuji on 2015/09/10.
//  Copyright (c) 2015年 hiroki.yoshifuji. All rights reserved.
//

import UIKit
import XCTest

class HRKModelTransferDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        MagicalRecord.setupCoreDataStackWithInMemoryStore()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        MagicalRecord.cleanUp()
    }
    
    
    func testInflector() {
        let words   = ["users", "posts","post"];
        let expects = ["user",  "post", "post"];
        
        
        var i = 0
        for word in words {
            XCTAssertEqual(word.singularizeString(), expects[i], word)
            i++
        }
        XCTAssert(true, "word")
    }
    
    func testModelName() {
        
        XCTAssertEqual(HRKModelTransfer.modelNameFromKey("post"), "Post", "post => Post")
        XCTAssertEqual(HRKModelTransfer.modelNameFromKey("user_history"), "UserHistory", "user_history => UserHistory")
    }
    
    
    func testTransfferSimple() {
        
        HRKModelTransfer.setup()
       
        let str = "{\"user\":{\"id\":\"1000001\",\"name\":\"hoge\",\"created_at\":1441860512,\"updated_at\":1441860512}}"
        var ret = _transfer(str) as? NSDictionary
        
        var model = ret?["user"] as? NSManagedObject
        println(model)
        XCTAssertNotNil(model, "exists model")
        XCTAssertEqual(model!.entity.name!, "User", "entity name")
        XCTAssertEqual(model!.valueForKey("id")!.integerValue, 1000001, "attr id")
        XCTAssertEqual(model!.valueForKey("name")! as! String, "hoge", "attr name")
        XCTAssertEqual(model!.valueForKey("created_at")! as! NSDate, NSDate(timeIntervalSince1970: 1441860512), "attr created_at")
        XCTAssertEqual(model!.valueForKey("updated_at")! as! NSDate, NSDate(timeIntervalSince1970: 1441860512), "attr updated_at")
        
        let user = User.MR_findFirstByAttribute("id", withValue: 1000001)
        XCTAssertNotNil(user, "exists user")
    }
    
    func testTransfferNoSave() {
        
        HRKModelTransfer.setup()
        
        let str = "{\"user\":{\"id\":\"1000001\",\"name\":\"hoge\",\"created_at\":1441860512,\"updated_at\":1441860512}}"
        var ret = _transfer(str, save:false) as? NSDictionary
        
        var model = ret?["user"] as? NSManagedObject
        println(model)
        XCTAssertNotNil(model, "exists model")
        
        let user = User.MR_findFirstByAttribute("id", withValue: 1000001)
        XCTAssertNil(user, "exists user")
    }
    
    func testTransfferDictionary() {
        
        HRKModelTransfer.setup()
        
        let str = "{\"users\":[{\"id\":1000001,\"name\":\"hoge\",\"created_at\":1441876413,\"updated_at\":1441880013,\"posts\":[{\"id\":100002,\"content\":\"hoge\",\"created_at\":1441876413,\"updated_at\":1441880013},{\"id\":100003,\"content\":\"foo\",\"created_at\":1441876413,\"updated_at\":1441880013}]}]}"
        let ret = _transfer(str) as! NSDictionary
        let users = ret["users"] as? NSArray
        
        XCTAssertNotNil(users, "exists users")
        XCTAssertEqual(users!.count, 1, "users count")
        
        let user = users![0] as! NSManagedObject
        let posts = user.valueForKey("posts") as? NSOrderedSet
        XCTAssertNotNil(posts, "exists posts")
        XCTAssertEqual(posts!.count, 2, "posts count")
        
        let post = posts![0] as! NSManagedObject
        let creator = post.valueForKey("creator") as? NSManagedObject
        
        XCTAssertNotNil(creator, "exists creator")
        XCTAssertEqual(creator!, user, "equals user = creator")
        
        XCTAssert(true, "Pass")
        
    }
    
    func testTransfferArray() {
        
        HRKModelTransfer.setup()
        
        let str = "[{\"id\":1000001,\"name\":\"hoge\",\"created_at\":1441876413,\"updated_at\":1441880013,\"posts\":[{\"id\":100002,\"content\":\"hoge\",\"created_at\":1441876413,\"updated_at\":1441880013},{\"id\":100003,\"content\":\"foo\",\"created_at\":1441876413,\"updated_at\":1441880013}]}]"
        
        let JSONObject: AnyObject = self.JSONObjectFromString(str)!
        let ret = HRKModelTransfer.transferWithModelName("User", JSONObject: JSONObject) as? NSArray
        
        let users = ret
        
        XCTAssertNotNil(users, "exists users")
        XCTAssertEqual(users!.count, 1, "users count")
        
        let user = users![0] as! NSManagedObject
        let posts = user.valueForKey("posts") as? NSOrderedSet
        XCTAssertNotNil(posts, "exists posts")
        XCTAssertEqual(posts!.count, 2, "posts count")
        
        let post = posts![0] as! NSManagedObject
        let creator = post.valueForKey("creator") as? NSManagedObject
        
        XCTAssertNotNil(creator, "exists creator")
        XCTAssertEqual(creator!, user, "equals user = creator")
        
        XCTAssert(true, "Pass")
        
    }
       
    func _transfer(str:String, save:Bool = true) -> AnyObject? {
        let json: AnyObject? = self.JSONObjectFromString(str)
            
        let ret: AnyObject! = HRKModelTransfer.transfer(json, save:save)
        return ret;
    }
    
    func JSONObjectFromString(str:String) -> AnyObject? {
        return NSJSONSerialization.JSONObjectWithData(str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options: NSJSONReadingOptions.allZeros, error: nil)
    }

    
}
