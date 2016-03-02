//
//  EDMXFavoriteCategoryActionViewModel.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 01/08/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleContextMenuActionViewModel.h"

@class EDMXCategory;

@interface EDMXFavoriteCategoryActionViewModel : EDMXArticleContextMenuActionViewModel

@property (nonatomic, strong, readonly) EDMXCategory *model;

- (id)initWithCategory:(EDMXCategory *)category;

@end
