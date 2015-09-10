# HRKModelTransfer

JSONをCoreDataのNSManagedObjectに変換して保存する

## 使い方

### key名からModelを自動で取得する場合

```
// API Response
{
    "users" : [
    	{
    		"id": 1000001,
    		"name": "hoge_user_1",
    		"created_at": 123456789,
    		"updated_at": 123456789,
    		"posts": [
    			{
    				"id": 2000001,
    				"content": "var",
		    		"created_at": 123456789,
    				"updated_at": 123456789,
    			}
    		]
    	},
    	{
    		"id": 1000002,
    		"name": "foo_user_2",
    		"created_at": 123456789,
    		"updated_at": 123456789,
    	},
    ],
    "articles" : [
    	{...}
    ]
}
```

```
MagicalRecord.setupCoreDataStackWithInMemoryStore()
     
HRKModelTransfer.setup()
var manager = AFHTTPRequestOperationManager()

manager.GET("http://example.com/resources.json", parameters: nil, success: { (operation:AFHTTPRequestOperation, responseObject:AnyObject) -> Void in
    var models = HRKModelTransfer.transfer(responseObject)
    var users    = models["users"] as! [User]
    var articles = models["articles"] as! [Articles]
    
}) { (AFHTTPRequestOperation, NSError) -> Void in
}        
```


### モデル名を指定する場合

ResponseからはModelが判別できない場合

```
// API Response
[
   	{
   		"id": 1000001,
   		"name": "hoge_user_1",
   		"created_at": 123456789,
   		"updated_at": 123456789,
   		"posts": [
   			{
   				"id": 2000001,
   				"content": "var",
	    		"created_at": 123456789,
   				"updated_at": 123456789,
   			}
   		]
   	},
   	{
   		"id": 1000002,
   		"name": "foo_user_2",
   		"created_at": 123456789,
   		"updated_at": 123456789,
   	},
]
```

```
manager.GET("http://example.com/users.json", parameters: nil, success: { (operation:AFHTTPRequestOperation, responseObject:AnyObject) -> Void in

	var users:[User] = HRKModelTransfer.transferWithModelName("User", JSONObject: responseObject) as! [User]
    
}) { (AFHTTPRequestOperation, NSError) -> Void in
}        
```

