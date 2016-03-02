//
//  EDMXArticle.h
//  Firstfestival
//
//  Created by Alex Bush on 7/17/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

typedef NS_ENUM(NSInteger, ArticleState) {
    ArticleStatePending,
    ArticleStateApproved,
    ArticleStateRejected
};

@interface EDMXArticle : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, copy)   NSNumber *remoteId;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *body;
@property (nonatomic, copy)   NSURL *imageUrl;
@property (nonatomic, copy)   NSNumber *newsSourceId;
@property (nonatomic, copy)   NSNumber *favoritizationId;
@property (nonatomic, copy)   NSString *newsSourceName;
@property (nonatomic, copy)   NSURL *url;
@property (nonatomic, copy)   NSNumber *rating;
@property (nonatomic, copy)   NSDate *approvedAt;
@property (nonatomic, copy)   NSDate *publishedAt;
@property (nonatomic, copy)   NSDate *publishedAtDate;
@property (nonatomic, assign) ArticleState state;
@property (nonatomic, copy)   NSDate *createdAt;
@property (nonatomic, copy)   NSDate *updatedAt;
@property (nonatomic, copy)   NSArray *categories;
@property (nonatomic, assign) BOOL isFeatured;
@property (nonatomic, copy)   NSURL *featuredImageUrl;
@property (nonatomic, assign) BOOL isSaved;

@end