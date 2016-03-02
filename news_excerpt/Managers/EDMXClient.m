//
//  EDMXApiClient.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 24/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXClient.h"
#import "EDMXArticle.h"
#import "EDMXFavoritization.h"

@interface EDMXClient()

@end

@implementation EDMXClient

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", EDMXAPIBaseURLString, @"api/v3/"]];
    self = [super initWithBaseURL:url managedObjectContext:context sessionConfiguration:configuration];
    return self;
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"users/*/articles.json": [EDMXArticle class],
             @"favoritizations.json": [EDMXFavoritization class]
    };
}

@end
