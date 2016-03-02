//
//  EDMXArticleViewModel.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 31/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleViewModel.h"
#import "EDMXArticle.h"

@implementation EDMXArticleViewModel

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *__dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __dateFormatter = [[NSDateFormatter alloc] init];
        __dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        __dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return __dateFormatter;
}

- (NSString *)publishedAtDateString {
    return [NSString stringWithFormat:@"%@", [[EDMXArticleViewModel dateFormatter] stringFromDate:self.article.publishedAt]];
}

- (NSURL *)articleImageUrl {
    return self.article.isFeatured ? self.article.featuredImageUrl : self.article.imageUrl;
}

- (id)initWithModel:(EDMXArticle *)article {
    self = [super init];
	
    if (self == nil) return nil;
	
    _article = article;
	
    return self;
}

- (BOOL)isSaved {
    return self.article.isSaved;
}

@end
