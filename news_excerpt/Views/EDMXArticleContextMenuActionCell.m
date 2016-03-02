//
//  EDMXArticleContextMenuActionCell.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 01/08/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleContextMenuActionCell.h"
#import "EDMXArticleContextMenuActionViewModel.h"

@interface EDMXArticleContextMenuActionCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *actionTitleLabel;

@end

@implementation EDMXArticleContextMenuActionCell

- (void)setActionViewModel:(EDMXArticleContextMenuActionViewModel *)actionViewModel {
    _actionViewModel = actionViewModel;
    self.iconView.image = self.actionViewModel.iconImageName ? [UIImage imageNamed:self.actionViewModel.iconImageName] : nil;
    if (self.actionViewModel.inProgress) {
        [self.activityIndicatorView startAnimating];
    }
    else {
        [self.activityIndicatorView stopAnimating];
    }
    self.actionTitleLabel.text = self.actionViewModel.actionTitle;
}

@end
