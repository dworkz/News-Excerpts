//
//  EDMXResponse.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 30/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXResponse.h"

@implementation EDMXResponse

+ (instancetype)responseWithHTTPResponse:(NSHTTPURLResponse *)HTTPResponse JSONObject:(id)JSONObject resultClass:(Class)resultClass {
    JSONObject = [self transformJSONObject:JSONObject];
    return [super responseWithHTTPResponse:HTTPResponse JSONObject:JSONObject resultClass:resultClass];
}

+ (id)transformJSONObject:(id)JSONObject {
    return JSONObject;
}

@end
