//
//  EDMXArticleShareActionViewModel.m
//  Firstfestival
//
//  Created by Alex Bush on 8/2/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleShareActionViewModel.h"
#import "EDMXArticle.h"

@implementation EDMXArticleShareActionViewModel

- (id)initWithArticle:(EDMXArticle *)article {
    self = [super init];
    if (self) {
        self.model = article;
    }
    return self;
}

- (NSString *)actionTitle {
    return @"Share article";
}

- (NSString *)iconImageName {
    return @"context_share";
}

- (UIImage *)shareImage {
    NSURL *url;
    if (self.model.isFeatured)
        url = [self.model featuredImageUrl];
    else
        url = [self.model imageUrl];
    
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}

@end