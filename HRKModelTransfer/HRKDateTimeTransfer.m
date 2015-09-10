//
//  HRKDateTimeTransfer.m
//
//  Created by Hiroki Yoshifuji on 2015/09/10.
//  Copyright (c) 2015年 hiroki.yoshifuji. All rights reserved.
//

#import "HRKDateTimeTransfer.h"

@implementation HRKDateTimeTransfer

- (id)transfer:(NSObject*)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[(NSString*)value integerValue]];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber*)value integerValue]];
    }
    
    return nil;
}

@end
