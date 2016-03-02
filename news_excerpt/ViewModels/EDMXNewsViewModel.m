//
//  EDMXNewsViewModel.m
//  Firstfestival
//
//  Created by Alex Bush on 7/17/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXNewsViewModel.h"
#import "EDMXArticle.h"
#import "EDMXNewsClient.h"
#import <Overcoat/ReactiveCocoa+Overcoat.h>
#import "ArticleResponse.h"
#import "EDMXArticleViewModel.h"
#import "EDMXArticleDetailsViewModel.h"
#import "DateOfDateTimeSortDescriptor.h"

#define SEARCH_QUERY_MIN_LENGTH 3

@interface EDMXNewsViewModel ()

@property (nonatomic, strong) EDMXNewsClient *client;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;

@property (nonatomic, assign, readwrite, getter = isLoading) BOOL loading;
@property (nonatomic, assign, readwrite, getter = isLoadingHead) BOOL loadingHead;
@property (nonatomic, assign, readwrite, getter = isLoadingTail) BOOL loadingTail;
@property (nonatomic, assign, readwrite, getter = isSearching) BOOL searching;
@property (nonatomic, strong) RACDisposable *loadDataDisposable;

@property (nonatomic, copy) NSString *newsScope;

@end

@implementation EDMXNewsViewModel

#pragma mark Getters

- (EDMXNewsClient *)client
{
    if (!_client) {
        _client = [[EDMXNewsClient alloc] initWithManagedObjectContext:self.persistenceController.managedObjectContext                   
                                                  sessionConfiguration:nil];
    }
    return _client;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                        managedObjectContext:self.persistenceController.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    }
    
    return _fetchedResultsController;
}

- (NSFetchRequest *)fetchRequest
{
    if (!_fetchRequest) {
        _fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Article"];
        _fetchRequest.sortDescriptors = @[
                                          [NSSortDescriptor sortDescriptorWithKey:@"isFeatured" ascending:NO],
                                          [NSSortDescriptor sortDescriptorWithKey:@"publishedAtDate" ascending:NO],
                                          [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO],
                                          [NSSortDescriptor sortDescriptorWithKey:@"publishedAt" ascending:NO]
        ];
        _fetchRequest.predicate = self.predicate;
    }
    return _fetchRequest;
}

#pragma mark Ctor

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    RACSignal *querySignal = [[RACObserve(self, query)  throttle:1] filter:^BOOL(id value) {
        return value != nil;
    }];
    
    RAC(self, newsScope) = [RACObserve(self, scope) map:^id(NSNumber *scopeNumber) {
        NewsScope scope = [scopeNumber integerValue];
        switch (scope) {
            case NewsScopeAll:
                return @"all";
            case NewsScopeMy:
                return @"my";
            case NewsScopeSaved:
                return @"saved";
        }
    }];
    
    RACSignal *scopeSignal = RACObserve(self, newsScope);
    
    @weakify(self);
    
    [[RACSignal merge:@[querySignal, scopeSignal]] subscribeNext:^(id _) {
        @strongify(self);
        if (self.loadDataDisposable) {
            [self.loadDataDisposable dispose];
            self.loadDataDisposable = nil;
        }
        
        [self localSearch];
        self.searching = YES;
        @weakify(self);
        self.loadDataDisposable = [[self remoteSearch] subscribeNext:^(ArticleResponse *x) {
            @strongify(self);
            self.searching = NO;
            [self localSearch];
        } error:^(NSError *error) {
            @strongify(self);
            NSLog(@"remote search error with query %@", error);
            self.searching = NO;
        }];
    }];
    
    RAC(self, loading) = [RACSignal combineLatest:@[RACObserve(self, loadingHead), RACObserve(self, loadingTail), RACObserve(self, searching)] reduce:^(NSNumber *loadingHead, NSNumber *loadingTail, NSNumber *searching){
        return @(loadingHead.boolValue || loadingTail.boolValue || searching.boolValue);
    }];
    
    return self;
}

#pragma mark Public methods

- (BOOL)fetchLocalData {
    [NSFetchedResultsController deleteCacheWithName:nil];
    [self.fetchRequest setPredicate:self.predicate];
    NSError *fetchError;
    BOOL fetched = [self.fetchedResultsController performFetch:&fetchError];
    if(!fetched) {
        NSLog(@"Couldn't fetch:%@", fetchError);
    }
    return fetched;
}

- (void)loadHead {
    self.loadingHead = YES;
    @weakify(self);
    [[self loadDataSignalWithOffset:@(0)] subscribeError:^(NSError *error) {
        @strongify(self);
        self.loadingHead = NO;
    } completed:^{
        @strongify(self);
        self.loadingHead = NO;
    }];
}

- (void)loadTail {
    self.loadingTail = YES;
    @weakify(self);
    [[self loadDataSignalWithOffset:self.numberOfShownArticles] subscribeError:^(NSError *error) {
        @strongify(self);
        self.loadingTail = NO;
    } completed:^{
        @strongify(self);
        self.loadingTail = NO;
    }];
}

- (EDMXArticleViewModel *)articleViewModelForIndexPath:(NSIndexPath *)indexPath {
    EDMXArticle *article = [self articleAtIndexPath:indexPath];
    return [[EDMXArticleViewModel alloc] initWithModel:article];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (EDMXArticle *)articleAtIndexPath:(NSIndexPath *)indexPath {
    return [MTLManagedObjectAdapter modelOfClass:[EDMXArticle class] fromManagedObject:[self.fetchedResultsController objectAtIndexPath:indexPath] error:NULL];
}

- (EDMXArticleDetailsViewModel *)articleDetailsViewModelForIndexPath:(NSIndexPath *)indexPath {
    return [[EDMXArticleDetailsViewModel alloc] initWithModel:[self articleAtIndexPath:indexPath]];
}

#pragma mark Private methods

- (NSPredicate *)predicate {
    NSMutableString *predicateString = [NSMutableString stringWithString:@"state = %@ "];
    NSMutableArray *arguments = [NSMutableArray arrayWithArray:@[@(ArticleStateApproved)]];
    if (self.query.length >= SEARCH_QUERY_MIN_LENGTH) {
        [predicateString appendString:@"AND (title CONTAINS[cd] %@ OR categories.name CONTAINS[cd] %@) "];
        [arguments addObjectsFromArray:@[self.query, self.query]];
    }
    switch (self.scope) {
        case NewsScopeAll:
            break;
        case NewsScopeMy:
        {
            [predicateString appendString:@"AND ANY categories.favoritizationId != null "];
            break;
        }
        case NewsScopeSaved:
            [predicateString appendString:@"AND favoritizationId != null"];
            break;
        default:
            break;
    }
    return [NSPredicate predicateWithFormat:predicateString argumentArray:arguments];
}

- (NSNumber *)numberOfShownArticles {
    RACSequence *sectionsSequence = [self.fetchedResultsController.sections rac_sequence];
    return [sectionsSequence foldLeftWithStart:@(0)            
                                        reduce:^id(NSNumber *numberOfObjects, id<NSFetchedResultsSectionInfo> sectionInfo) {
        return @(numberOfObjects.integerValue + sectionInfo.numberOfObjects);
    }];
}

- (void)localSearch {
    if ([self fetchLocalData]) {
        [self.newsViewModelDelegate newsViewModelDidChangeSearchResults];
    }
}

- (RACSignal *)remoteSearch {
    return [self loadDataSignalWithOffset:@(0)];
}

- (RACSignal *)loadDataSignalWithOffset:(NSNumber *)offset {
    [NSFetchedResultsController deleteCacheWithName:nil];
    return [self.client getNewsForUser:[EDMXUser sharedInstance] withScope:self.newsScope query:self.query offset:offset];
}

@end