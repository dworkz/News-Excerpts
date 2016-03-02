//
//  EDMXCategory.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 30/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "Mantle.h"

@interface EDMXCategory : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, copy) NSNumber *remoteId;
@property (nonatomic, copy) NSNumber *favoritizationId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL isFavorited;

@end
