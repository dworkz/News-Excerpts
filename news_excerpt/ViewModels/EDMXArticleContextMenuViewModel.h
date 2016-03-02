//
//  EDMXArticleContextMenuViewModel.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 01/08/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "RVMViewModel.h"

typedef NS_ENUM(NSInteger, EDMXArticleContextMenuMode) {
    EDMXArticleContextMenuModeFull,
    EDMXArticleContextMenuModeShort
};

@class EDMXArticle;
@class EDMXArticleContextMenuActionViewModel;

@interface EDMXArticleContextMenuViewModel : RVMViewModel

@property (nonatomic, strong, readonly) EDMXArticle *article;
- (id)initWithModel:(EDMXArticle *)article;
- (id)initWithModel:(EDMXArticle *)article mode:(EDMXArticleContextMenuMode)mode;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (EDMXArticleContextMenuActionViewModel *)actionViewModelByIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForActionViewModel:(EDMXArticleContextMenuActionViewModel *)actionViewModel;

@end
