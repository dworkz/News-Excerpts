//
//  ArticlesDataSource.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 25/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "TGRFetchedResultsDataSource.h"
#import "EDMXNewsViewModel.h"
#import "EDMXArticleCell.h"

#define ArticleCellIdentifier @"ArticleCell"
#define FeaturedArticleCellIdentifier @"FeaturedArticleCell"

@interface ArticlesDataSource : TGRFetchedResultsDataSource

@property (nonatomic, weak) id<EDMXArticleCellDelegate> cellDelegate;

- (id)initWithViewModel:(EDMXNewsViewModel *)viewModel;

@end
