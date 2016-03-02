//
//  EDMXNewsContainerViewController.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 29/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDMXV2BaseViewController.h"
#import "TGRFetchedResultsTableViewController.h"

@class EDMXNewsViewModel;

@interface EDMXNewsContainerViewController : UIViewController

- (id)initWithViewModel:(EDMXNewsViewModel *)viewModel;

@property (nonatomic, strong, readonly) EDMXNewsViewModel *viewModel;

@end
