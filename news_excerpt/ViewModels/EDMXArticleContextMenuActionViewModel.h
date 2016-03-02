//
//  EDMXArticleContextMenuActionViewModel.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 01/08/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "RVMViewModel.h"

@class EDMXArticleContextMenuActionViewModel;

@protocol EDMXArticleContextMenuActionDelegate<NSObject>

- (void)actionCompleted:(EDMXArticleContextMenuActionViewModel *)actionViewModel;

@end

@interface EDMXArticleContextMenuActionViewModel : RVMViewModel

@property (nonatomic, strong) id model;
@property (nonatomic, strong) id<EDMXArticleContextMenuActionDelegate> delegate;
@property (nonatomic, copy) NSString *iconImageName;
@property (nonatomic, copy) NSString *actionTitle;
@property (nonatomic, assign) BOOL inProgress;

- (void)action;
- (void)updateModel:(id)actionValue;
- (void)completeAction;

@end