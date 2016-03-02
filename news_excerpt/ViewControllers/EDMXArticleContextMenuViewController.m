//
//  EDMXArticleContextMenuViewController.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 31/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleContextMenuViewController.h"
#import "EDMXArticleContextMenuViewModel.h"
#import "EDMXArticleContextMenuActionCell.h"
#import "EDMXSaveArticleActionViewModel.h"
#import "EDMXFavoriteCategoryActionViewModel.h"
#import "EDMXArticleShareActionViewModel.h"

@interface EDMXArticleContextMenuViewController ()<UITableViewDataSource>

@end

@implementation EDMXArticleContextMenuViewController

- (id)initWithViewModel:(EDMXArticleContextMenuViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"EDMXArticleContextMenuActionCell" bundle:nil] forCellReuseIdentifier:@"ArticleContextMenuActionCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDMXArticleContextMenuActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleContextMenuActionCell"];
    

    EDMXArticleContextMenuActionViewModel *actionViewModel = [self.viewModel actionViewModelByIndexPath:indexPath];
    actionViewModel.delegate = self;
    cell.actionViewModel = actionViewModel;
    return cell;
}

- (void)showShareVC:(EDMXArticleShareActionViewModel *)viewModel {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[viewModel.model, viewModel.shareImage]
                                                        applicationActivities:nil];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:^{
                         
                     }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EDMXArticleContextMenuActionViewModel *actionViewModel = [self.viewModel actionViewModelByIndexPath:indexPath];
    [actionViewModel action];
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (void)actionCompleted:(EDMXArticleContextMenuActionViewModel *)actionViewModel {
    NSIndexPath *indexPath = [self.viewModel indexPathForActionViewModel:actionViewModel];
    
    if ([actionViewModel isKindOfClass:[EDMXArticleShareActionViewModel class]])
        [self showShareVC:(EDMXArticleShareActionViewModel *)actionViewModel];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
