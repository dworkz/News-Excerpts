//
//  EDMXSaveArticleActionViewModel.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 01/08/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleContextMenuActionViewModel.h"

@class EDMXArticle;

@protocol EDMXArticleSaveActionDelegate<EDMXArticleContextMenuActionDelegate>

@optional
- (void)saveActionCompleted:(BOOL)isSaved;

@end

@interface EDMXSaveArticleActionViewModel : EDMXArticleContextMenuActionViewModel

@property (nonatomic, strong, readonly) EDMXArticle *model;
@property (nonatomic, strong) id<EDMXArticleSaveActionDelegate> delegate;

- (id)initWithArticle:(EDMXArticle *)article;

- (BOOL)isSaved;

@end
