//
//  EDMXArticleDetailsContextMenuViewController.m
//  Firstfestival
//
//  Created by Alex Bush on 8/2/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleDetailsContextMenuViewController.h"
#import "MZFormSheetController.h"
#import "EDMXArticleDetailsContextMenuActionCell.h"
#import "EDMXArticleContextMenuViewModel.h"

@interface EDMXArticleDetailsContextMenuViewController ()

@end

@implementation EDMXArticleDetailsContextMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EDMXArticleDetailsContextMenuActionCell" bundle:nil] forCellReuseIdentifier:@"ArticleDetailsContextMenuActionCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDMXArticleContextMenuActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleDetailsContextMenuActionCell"];
    
    
    EDMXArticleContextMenuActionViewModel *actionViewModel = [self.viewModel actionViewModelByIndexPath:indexPath];
    actionViewModel.delegate = self;
    cell.actionViewModel = actionViewModel;
    return cell;
}

- (IBAction)onCloseButtonClick:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

@end