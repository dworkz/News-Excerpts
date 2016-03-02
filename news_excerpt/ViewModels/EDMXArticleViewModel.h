//
//  EDMXArticleViewModel.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 31/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "RVMViewModel.h"

@class EDMXArticle;

@interface EDMXArticleViewModel : RVMViewModel

@property (nonatomic, readonly, strong) EDMXArticle *article;
@property (nonatomic, readonly, copy) NSString *publishedAtDateString;
@property (nonatomic, readonly, copy) NSURL *articleImageUrl;

- (id)initWithModel:(EDMXArticle *)article;

- (BOOL)isSaved;

@end
