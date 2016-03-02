//
//  EDMXFavoritization.h
//  Firstfestival
//
//  Created by Alex Bush on 7/31/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

@interface EDMXFavoritization : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)   NSNumber *remoteId;

@end
