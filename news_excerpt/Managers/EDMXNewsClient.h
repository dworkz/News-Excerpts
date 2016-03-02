//
//  EDMXNewsClient.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 24/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXClient.h"
#import "EDMXUser.h"

@class EDMXUser;

@interface EDMXNewsClient : EDMXClient

- (RACSignal *)getNewsForUser:(EDMXUser *)user withScope:(NSString *)scope query:(NSString *)query offset:(NSNumber *)offset;

@end
