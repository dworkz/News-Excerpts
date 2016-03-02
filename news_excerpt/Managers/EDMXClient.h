//
//  EDMXApiClient.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 24/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Overcoat/Overcoat.h>

@interface EDMXClient : OVCHTTPSessionManager

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context sessionConfiguration:(NSURLSessionConfiguration *)configuration;

@end
