//
//  HRKModelTransfer.h
//
//  Created by Hiroki Yoshifuji on 2015/09/10.
//  Copyright (c) 2015年 hiroki.yoshifuji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HRKModelTransfer : NSObject

/*
 CoreDataの参照先を登録
 */
+ (void)setup;
+ (void)setupWithContext:(NSManagedObjectContext *)context;

/*
 変換を行う
 */
+ (id)transfer:(id)JSONDictionary;
+ (id)transfer:(id)JSONDictionary save:(BOOL)save;

/*
 Modelオブジェクトを指定した変換
 */
+(id)transferWithModelName:(NSString*)modelName JSONObject:(id)JSONObject;
+(id)transferWithModelName:(NSString*)modelName JSONObject:(id)JSONObject save:(BOOL)save;

+ (NSString*)modelNameFromKey:(NSString*)key;

@end
