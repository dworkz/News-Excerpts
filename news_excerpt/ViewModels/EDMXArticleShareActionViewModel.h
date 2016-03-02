//
//  EDMXArticleShareActionViewModel.h
//  Firstfestival
//
//  Created by Alex Bush on 8/2/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleContextMenuActionViewModel.h"

@class EDMXArticle;

@interface EDMXArticleShareActionViewModel : EDMXArticleContextMenuActionViewModel

@property (nonatomic, strong, readonly) EDMXArticle *model;

- (id)initWithArticle:(EDMXArticle *)article;

- (UIImage *)shareImage;

@end