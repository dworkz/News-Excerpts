//
//  EDMXCategory.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 30/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXCategory.h"

@implementation EDMXCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"remoteId"        : @"id",
             @"favoritizationId": @"favoritization_id",
             @"name"             : @"name",
             @"type"            : @"type"
    };
}

+ (NSString *)managedObjectEntityName {
    return @"Category";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
             @"isFavorited": [NSNull null]
    };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"remoteId"];
}

- (BOOL)isFavorited {
    return self.favoritizationId != nil;
}

@end
