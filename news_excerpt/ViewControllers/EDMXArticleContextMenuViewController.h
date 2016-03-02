//
//  EDMXArticleContextMenuViewController.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 31/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDMXArticleContextMenuActionViewModel.h"

@class EDMXArticleContextMenuViewModel;

@interface EDMXArticleContextMenuViewController : UIViewController <EDMXArticleContextMenuActionDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readonly) EDMXArticleContextMenuViewModel *viewModel;

- (id)initWithViewModel:(EDMXArticleContextMenuViewModel *)viewModel;

@end