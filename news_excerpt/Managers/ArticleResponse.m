//
//  ArticleResponse.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 24/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "ArticleResponse.h"

@implementation ArticleResponse

+ (NSString *)resultKeyPathForJSONDictionary:(NSDictionary *)JSONDictionary {
    return @"articles";
}

+ (id)transformJSONObject:(id)JSONObject
{
    NSDictionary *categoriesLookup = [[JSONObject[@"categories"] rac_sequence] foldLeftWithStart:[NSMutableDictionary dictionary] reduce:^id(NSMutableDictionary *lookup, NSDictionary *category) {
        lookup[category[@"id"]] = category;
        return lookup;
    }];
    
    NSArray *articles = [[[JSONObject[@"articles"] rac_sequence] map:^id(id value) {
        NSMutableDictionary *article = [NSMutableDictionary dictionaryWithDictionary:value];
        NSArray *categoriesIds = value[@"category_ids"];
        article[@"categories"] = [[[categoriesIds rac_sequence] map:^id(id value) {
            return categoriesLookup[value];
        }] array];
        return article;
    }] array];
    
    return @{ @"articles": articles };
}

@end
