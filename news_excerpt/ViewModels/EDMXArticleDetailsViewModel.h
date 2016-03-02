//
//  EDMXArticleDetailsViewModel.h
//  Firstfestival
//
//  Created by Alex Bush on 7/30/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "RVMViewModel.h"

@class EDMXArticle;
@class EDMXSaveArticleActionViewModel;

@interface EDMXArticleDetailsViewModel : RVMViewModel

@property (nonatomic, readonly, strong) EDMXArticle *model;

@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;

@property (nonatomic, strong, readonly) EDMXSaveArticleActionViewModel *saveArticleActionViewModel;

- (id)initWithModel:(EDMXArticle *)model;

- (NSURL *)url;

- (UIImage *)shareImage;

@end