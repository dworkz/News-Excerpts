//
//  EDMXNewsViewModel.h
//  Firstfestival
//
//  Created by Alex Bush on 7/17/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "RVMViewModel.h"

typedef NS_ENUM(NSInteger, NewsScope) {
    NewsScopeAll = 0,
    NewsScopeMy,
    NewsScopeSaved
};

@class EDMXNewsViewModel;

@protocol NewsViewModelDelegate

- (void)newsViewModelDidChangeSearchResults;

@end

@class EDMXArticle;
@class EDMXArticleViewModel;
@class EDMXArticleDetailsViewModel;

@interface EDMXNewsViewModel : RVMViewModel

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) id<NewsViewModelDelegate> newsViewModelDelegate;
@property (nonatomic, copy) NSString *query;
@property (nonatomic, assign) NewsScope scope;

@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, assign, readonly, getter = isLoadingHead) BOOL loadingHead;
@property (nonatomic, assign, readonly, getter = isLoadingTail) BOOL loadingTail;
@property (nonatomic, assign, readonly, getter = isSearching) BOOL searching;


- (BOOL)fetchLocalData;
- (void)loadHead;
- (void)loadTail;

- (EDMXArticle *)articleAtIndexPath:(NSIndexPath *)indexPath;
- (EDMXArticleViewModel *)articleViewModelForIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (EDMXArticleDetailsViewModel *)articleDetailsViewModelForIndexPath:(NSIndexPath *)indexPath;

@end