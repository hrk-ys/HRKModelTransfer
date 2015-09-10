//
//  HRKModelTransferJob.h
//
//  Created by Hiroki Yoshifuji on 2015/09/10.
//  Copyright (c) 2015年 hiroki.yoshifuji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "HRKDateTimeTransfer.h"

@interface HRKModelTransferParser : NSObject

@property (nonatomic) BOOL save;
@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) HRKDateTimeTransfer*    dateTimeTransfer;


-(instancetype)initWithContext:(NSManagedObjectContext*)context withSave:(BOOL)save;

-(id)perse:(id)JSONDictionary;
-(id)perseWithModelName:(NSString*)modelName JSONObject:(id)JSONObject;

@end
