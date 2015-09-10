//
//  HRKModelTransfer.m
//
//  Created by Hiroki Yoshifuji on 2015/09/10.
//  Copyright (c) 2015年 hiroki.yoshifuji. All rights reserved.
//

#import "HRKModelTransfer.h"

#import "HRKDateTimeTransfer.h"
#import "HRKModelTransferParser.h"

#import <MagicalRecord/MagicalRecord.h>

@interface HRKModelTransfer()

@property (nonatomic) NSManagedObjectContext* context;
@property (nonatomic) HRKDateTimeTransfer*    dateTimeTransfer;

@end

@implementation HRKModelTransfer



+ (HRKModelTransfer*)sharedInstance {
    
    static HRKModelTransfer* _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [HRKModelTransfer new];
    });
    
    return _instance;
}


+ (void)setup
{
    [self setupWithContext:[NSManagedObjectContext MR_context]];
}

+ (void)setupWithContext:(NSManagedObjectContext *)context
{
    HRKModelTransfer* transfer = [self sharedInstance];
    transfer.context = context;
    transfer.dateTimeTransfer = [HRKDateTimeTransfer new];
}






+ (id)transfer:(id)JSONObject
{
    return [self transfer:JSONObject save:YES];
}
+ (id)transfer:(id)JSONObject save:(BOOL)save
{
    return [[self sharedInstance] transfer:JSONObject save:save];
}

- (id)transfer:(id)JSONObject save:(BOOL)save{
    
    HRKModelTransferParser *parser = [[HRKModelTransferParser alloc] initWithContext:_context withSave:save];
    parser.dateTimeTransfer = _dateTimeTransfer;
    id ret = [parser perse:JSONObject];
    if (save) {
        [_context MR_saveToPersistentStoreAndWait];
    }
    return ret;
}








+(id)transferWithModelName:(NSString*)modelName JSONObject:(id)JSONObject
{
    return [self transferWithModelName:modelName JSONObject:JSONObject save:YES];
}

+(id)transferWithModelName:(NSString*)modelName JSONObject:(id)JSONObject save:(BOOL)save
{
    return [[self sharedInstance] transferWithModelName:modelName JSONObject:JSONObject save:save];
}

-(id)transferWithModelName:(NSString*)modelName JSONObject:(id)JSONObject save:(BOOL)save
{
    HRKModelTransferParser *parser = [[HRKModelTransferParser alloc] initWithContext:_context withSave:save];
    parser.dateTimeTransfer = _dateTimeTransfer;
    id ret = [parser perseWithModelName:modelName JSONObject:JSONObject];
    if (save) {
        [_context MR_saveToPersistentStoreAndWait];
    }
    return ret;   
}






+ (NSString*)modelNameFromKey:(NSString*)key {
    NSString* modelName = [key capitalizedString];
    modelName = [modelName stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [modelName stringByReplacingOccurrencesOfString:@"_" withString:@""];
}


@end
