//
//  EDMXNewsClient.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 24/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXNewsClient.h"
#import "ArticleResponse.h"
#import <Overcoat/ReactiveCocoa+Overcoat.h>

@implementation EDMXNewsClient

+ (Class)responseClass {
    return [ArticleResponse class];
}

- (RACSignal *)getNewsForUser:(EDMXUser *)user withScope:(NSString *)scope query:(NSString *)query offset:(NSNumber *)offset {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (scope) {
        parameters[@"scope"] = scope;
    }
    if (query) {
        parameters[@"query"] = query;
    }
    if (offset) {
        parameters[@"offset"] = offset;
    }
    NSString *url = [NSString stringWithFormat:@"users/%@/articles.json", user.userID];
    return [self rac_GET:url parameters:parameters];
}

@end
