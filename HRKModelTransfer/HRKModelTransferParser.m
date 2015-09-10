//
//  HRKModelTransferJob.m
//
//  Created by Hiroki Yoshifuji on 2015/09/10.
//  Copyright (c) 2015年 hiroki.yoshifuji. All rights reserved.
//

#import "HRKModelTransferParser.h"
#import "HRKModelTransfer.h"

#import <ActiveSupportInflector/NSString+ActiveSupportInflector.h>

@implementation HRKModelTransferParser

-(HRKModelTransferParser*)initWithContext:(NSManagedObjectContext*)context withSave:(BOOL)save;
{
    self = [super init];
    if (self) {
        
        _context = context;
        _save    = save;
        
    }
    return self;
}


-(id)perse:(id)JSONDictionary
{
    NSMutableDictionary* ret = @{}.mutableCopy;
    
    NSArray* keys = [JSONDictionary allKeys];
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        
        id value = JSONDictionary[key];
        NSObject* result;
        if ([value isKindOfClass:NSArray.class]) {
            
            result = [[self _parse:key value:value] array];
            
        } else {
            
            result = [self _parseOne:key value:value];
        }
        
        ret[key] = result;
    }];
    
    return ret;
}

-(id)perseWithModelName:(NSString*)modelName JSONObject:(id)JSONObject
{
    if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        return [self perseWithModelName:modelName JSONDictionary:(NSDictionary*)JSONObject];
    }
    
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        return [self perseWithModelName:modelName JSONArray:(NSArray*)JSONObject];
    }
    
    return nil;   
}

-(id)perseWithModelName:(NSString*)modelName JSONDictionary:(NSDictionary*)JSONDictionary
{
    return [self _parseOne:modelName value:JSONDictionary];
}

-(NSArray*)perseWithModelName:(NSString*)modelName JSONArray:(NSArray*)JSONArray
{
    NSMutableArray* ret = @[].mutableCopy;
    
    [JSONArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [ret addObject:[self _parseOne:modelName value:obj]];
    }];
    return ret;
}


- (NSOrderedSet*)_parse:(NSString*)key value:(NSArray*)values {
    
    NSMutableOrderedSet* orderedSet = [NSMutableOrderedSet new];
    NSString* singleKey = key.singularizeString;
    [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id model = [self _parseOne:singleKey value:obj];
        [orderedSet addObject:model];
    }];
    
    return orderedSet;
}

- (id)_parseOne:(NSString*)key value:(NSDictionary*)value {
    
    NSString* modelName = [HRKModelTransfer modelNameFromKey:key];
    
    NSEntityDescription* entry = [NSEntityDescription entityForName:modelName inManagedObjectContext:_context];
    NSAssert(entry, @"not found modelname:%@", modelName);
    
    NSManagedObject* model;
    if (!_save) {
        model = [[NSManagedObject alloc] initWithEntity:entry insertIntoManagedObjectContext:nil];
    } else {
        NSInteger rowId = [value[@"id"] integerValue];
    
        model = [self fetchModel:modelName withId:rowId];
        if (model == nil) {
            model = [[NSManagedObject alloc] initWithEntity:entry insertIntoManagedObjectContext:_context];
        }
    }
    
    [value.allKeys enumerateObjectsUsingBlock:^(NSString* key, NSUInteger idx, BOOL *stop) {
        
        [self mapping:key value:value[key] toModel:model];
        
    }];
    
    
    return model;
}

- (void)mappingRelationship:(NSRelationshipDescription*)relationship name:(NSString*)name value:(NSObject*)value toModel:(NSManagedObject*)model {
    
    if (value == [NSNull null]) {
        [model setValue:nil forKey:name];
        return;
    }
    
    if ([value isKindOfClass:[NSArray class]]) {
        [model setValue:[self _parse:name value:(NSArray*)value] forKey:name];
        return;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        [model setValue:[self _parseOne:name value:(NSDictionary*)value] forKey:name];
        return;
    }
    
    NSAssert(false, @"unknown relationship value (%@, %@)", name, value);
}


- (void)mappingAttribute:(NSAttributeDescription*)attribute name:(NSString*)name value:(NSObject*)value toModel:(NSManagedObject*)model {
    
    if (value == [NSNull null]) {
        [model setValue:nil forKey:name];
        return;
    }
    
    switch (attribute.attributeType) {
        case NSInteger16AttributeType:
        case NSInteger32AttributeType:
        case NSInteger64AttributeType:
        case NSDecimalAttributeType:
            
            if ([value isKindOfClass:[NSNumber class]]) {
                [model setValue:value forKey:name];
            } else if ([value isKindOfClass:[NSString class]]) {
                [model setValue:[NSNumber numberWithInteger:[(NSString*)value integerValue]] forKey:name];
            }
            
            return;
            
        case NSDoubleAttributeType:
        case NSFloatAttributeType:
            
            if ([value isKindOfClass:[NSNumber class]]) {
                [model setValue:value forKey:name];
            } else if ([value isKindOfClass:[NSString class]]) {
                [model setValue:[NSNumber numberWithDouble:[(NSString*)value doubleValue]] forKey:name];
            }
            
            return;
            
        case NSStringAttributeType:
        case NSTransformableAttributeType:
            
            [model setValue:value forKey:name];
            
            return;
            
        case NSDateAttributeType:
            
            [model setValue:[_dateTimeTransfer transfer:value] forKey:name];
            return;
            
        default:
            break;
    }
    
    NSAssert(false, @"unknown attribute value (%@, %@)", name, value);
}

- (void)mapping:(NSString*)name value:(NSObject*)value toModel:(NSManagedObject*)model {
    
    NSRelationshipDescription* relation = model.entity.relationshipsByName[name];
    if (relation != nil) {
        [self mappingRelationship:relation name:name value:value toModel:model];
        return;
    }
    
    NSAttributeDescription* attribute = model.entity.attributesByName[name];
    if (attribute != nil) {
        [self mappingAttribute:attribute name:name value:value toModel:model];
        return;
    }
    
//    NSAssert(false, @"unknown attribute %@ %@", name, value);
}

- (NSManagedObject*)fetchModel:(NSString*)modelName withId:(NSInteger)rowId
{
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:modelName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id = %d", rowId]];
    [request setIncludesSubentities:NO];

    NSError* error;
    NSArray* rows = [_context executeFetchRequest:request error:&error];

    if (rows && rows.count > 0) {
        return rows[0];
    }

    return nil;
}

@end
