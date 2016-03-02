//
//  EDMXArticleDetailsViewModel.m
//  Firstfestival
//
//  Created by Alex Bush on 7/30/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleDetailsViewModel.h"
#import "EDMXArticle.h"
#import "EDMXSaveArticleActionViewModel.h"

@interface EDMXArticleDetailsViewModel ()

@property (nonatomic, assign, readwrite, getter = isLoading) BOOL loading;

@end

@implementation EDMXArticleDetailsViewModel

@synthesize saveArticleActionViewModel = _saveArticleActionViewModel;

- (id)initWithModel:(EDMXArticle *)model {
    self = [super init];
	if (self == nil) return nil;
    
	_model = model;
    
	return self;
}

- (NSURL *)url {
    return self.model.url;
}

- (UIImage *)shareImage {
    NSURL *url;
    if (self.model.isFeatured)
        url = [self.model featuredImageUrl];
    else
        url = [self.model imageUrl];
    
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}

#pragma mark - Private

- (EDMXSaveArticleActionViewModel *)saveArticleActionViewModel {
    if (!_saveArticleActionViewModel) {
        _saveArticleActionViewModel = [[EDMXSaveArticleActionViewModel alloc] initWithArticle:self.model];
    }
    return _saveArticleActionViewModel;
}

@end