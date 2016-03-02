//
//  EDMXArticleContextMenuViewModel.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 01/08/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleContextMenuViewModel.h"
#import "EDMXArticle.h"
#import "EDMXArticleContextMenuActionViewModel.h"
#import "EDMXCategory.h"
#import "EDMXSaveArticleActionViewModel.h"
#import "EDMXFavoriteCategoryActionViewModel.h"
#import "EDMXArticleShareActionViewModel.h"

@interface EDMXArticleContextMenuViewModel()

@property (nonatomic, strong) NSArray *actionViewModels;

@property (nonatomic, assign) NSInteger mode;

@end

@implementation EDMXArticleContextMenuViewModel

- (NSArray *)actionViewModels {
    if (!_actionViewModels) {
        NSMutableArray *actions = [NSMutableArray array];
        if (self.mode == EDMXArticleContextMenuModeFull) [actions addObject:[self saveArticleAction]];
        if (self.mode == EDMXArticleContextMenuModeFull) [actions addObject:[self shareArticleAction]];
        NSArray *orderedCategories = [self.article.categories sortedArrayUsingDescriptors:@[
            [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES comparator:^NSComparisonResult(NSString *type1, NSString *type2) {
            if ([type1 isEqualToString:@"NewsSource"]) {
                return NSOrderedAscending;
            }
            if ([type1 isEqualToString:@"Artist"]) {
                return NSOrderedDescending;
            }
            if ([type1 isEqualToString:@"Party"] && [type2 isEqualToString:@"NewsSource"]) {
                return NSOrderedDescending;
            }
            if ([type1 isEqualToString:@"Party"] && [type2 isEqualToString:@"Artist"]) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }],
            [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]
                                                                                            ]];
        [actions addObjectsFromArray:[[[orderedCategories rac_sequence] map:^id(EDMXCategory *category) {
            return [self categoryActionWithCategory:category];
        }] array]];
        _actionViewModels = [actions copy];
    }
    return _actionViewModels;
}

- (id)initWithModel:(EDMXArticle *)article {
    self = [super init];
    if (self) {
        _article = article;
        _mode = EDMXArticleContextMenuModeFull;
    }
    return self;
}

- (id)initWithModel:(EDMXArticle *)article mode:(EDMXArticleContextMenuMode)mode {
    self = [self initWithModel:article];
    if (self) {
        _mode = mode;
    }
    return self;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    if (self.mode == EDMXArticleContextMenuModeShort)
        return self.article.categories.count;
    else
        return 2 + self.article.categories.count;
}

- (EDMXArticleContextMenuActionViewModel *)actionViewModelByIndexPath:(NSIndexPath *)indexPath {
    return self.actionViewModels[indexPath.row];
}

- (NSIndexPath *)indexPathForActionViewModel:(EDMXArticleContextMenuActionViewModel *)actionViewModel {
    return [NSIndexPath indexPathForRow:[self.actionViewModels indexOfObject:actionViewModel] inSection:0];
}

- (EDMXSaveArticleActionViewModel *)saveArticleAction {
    return [[EDMXSaveArticleActionViewModel alloc] initWithArticle:self.article];
}

- (EDMXArticleShareActionViewModel *)shareArticleAction {
    return [[EDMXArticleShareActionViewModel alloc] initWithArticle:self.article];
}

- (EDMXFavoriteCategoryActionViewModel *)categoryActionWithCategory:(EDMXCategory *)category {
    return [[EDMXFavoriteCategoryActionViewModel alloc] initWithCategory:category];
}


@end
