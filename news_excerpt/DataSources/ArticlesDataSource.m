//
//  ArticlesDataSource.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 25/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "ArticlesDataSource.h"
#import "MTLManagedObjectAdapter.h"
#import "EDMXArticle.h"
#import "EDMXArticleCell.h"
#import "EDMXFeaturedArticleCell.h"
#import "EDMXNewsViewModel.h"
#import "EDMXArticleViewModel.h"

@interface ArticlesDataSource()

@property (nonatomic, strong) EDMXNewsViewModel *viewModel;

@end

@implementation ArticlesDataSource

- (id)initWithViewModel:(EDMXNewsViewModel *)viewModel {
    _viewModel = viewModel;
    return [super initWithFetchedResultsController:viewModel.fetchedResultsController cellReuseIdentifier:nil configureCellBlock:nil];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel articleViewModelForIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDMXArticleViewModel *articleViewModel = [self.viewModel articleViewModelForIndexPath:indexPath];
    
    EDMXArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:articleViewModel.article.isFeatured ? FeaturedArticleCellIdentifier : ArticleCellIdentifier
                                                            forIndexPath:indexPath];
    cell.delegate = self.cellDelegate;
    cell.articleViewModel = articleViewModel;
    return cell;
}


@end
