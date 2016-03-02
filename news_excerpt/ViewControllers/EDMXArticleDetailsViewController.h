//
//  EDMXArticleDetailsViewController.h
//  Firstfestival
//
//  Created by Alex Bush on 7/30/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDMXArticleDetailsViewModel;

@interface EDMXArticleDetailsViewController : UIViewController

@property (nonatomic, strong, readonly) EDMXArticleDetailsViewModel *viewModel;

- (id)initWithViewModel:(EDMXArticleDetailsViewModel *)viewModel;

@end
