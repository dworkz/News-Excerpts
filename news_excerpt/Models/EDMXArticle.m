//
//  EDMXArticle.m
//  Firstfestival
//
//  Created by Alex Bush on 7/17/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticle.h"
#import "EDMXCategory.h"

@class EDMXCategory;

@implementation EDMXArticle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"remoteId"        : @"id",
             @"imageUrl"        : @"image_url",
             @"newsSourceId"    : @"news_source_id",
             @"newsSourceName"  : @"news_source_name",
             @"favoritizationId": @"favoritization_id",
             @"url"             : @"url",
             @"approvedAt"      : @"approved_at",
             @"publishedAt"     : @"published_at",
             @"createdAt"       : @"created_at",
             @"updatedAt"       : @"updated_at",
             @"state"           : @"state",
             @"categories"      : @"categories",
             @"isFeatured"      : @"featured",
             @"featuredImageUrl": @"featured_image_url"
    };
}

+ (NSValueTransformer *)imageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)featuredImageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)isFeaturedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *__dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __dateFormatter = [[NSDateFormatter alloc] init];
        __dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"UTC"];
        __dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return __dateFormatter;
}

+ (NSValueTransformer *)approvedAtJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    }];
}

+ (NSValueTransformer *)publishedAtJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    }];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    }];
}

+ (NSValueTransformer *)stateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"pending": @(ArticleStatePending),
                                                                           @"approved": @(ArticleStateApproved),
                                                                           @"rejected": @(ArticleStateRejected)
                                                                           }];
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[EDMXCategory class]];
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"Article";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
             @"isSaved": [NSNull null]
    };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey {
    return @{
             @"categories": [EDMXCategory class]
    };
}

+ (NSValueTransformer *)imageUrlEntityAttributeTransformer {
    return [self urlEntityTransformer];
}

+ (NSValueTransformer *)featuredImageUrlEntityAttributeTransformer {
    return [self urlEntityTransformer];
}

+ (NSValueTransformer *)urlEntityAttributeTransformer {
    return [self urlEntityTransformer];
}

+ (NSValueTransformer *)urlEntityTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSString *(NSURL *url) {
        return [url description];
    } reverseBlock:^NSURL *(NSString *urlString) {
        return [NSURL URLWithString:urlString];
    }];
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"remoteId"];
}

- (BOOL)isSaved {
    return self.favoritizationId != nil;
}

- (NSDate *)publishedAtDate {
    return [self dateWithoutTimeOfDate:self.publishedAt];
}

#pragma mark - Private


 - (NSDate *)dateWithoutTimeOfDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return [calendar dateFromComponents:components];
}

@end