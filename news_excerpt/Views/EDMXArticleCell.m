//
//  EDMXArticleTableViewCell.m
//  Firstfestival
//
//  Created by Alex Bush on 7/18/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleCell.h"
#import "EDMXArticleContextMenuViewController.h"
#import "EDMXArticleViewModel.h"
#import "EDMXArticle.h"
#import "MZFormSheetController.h"
#import "EDMXArticleContextMenuViewModel.h"

@interface EDMXArticleCell()

@property (weak, nonatomic) IBOutlet UILabel *newsSourceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIImageView *savedCheckBoxImageView;

@end

@implementation EDMXArticleCell

- (void)awakeFromNib
{
    [self.menuButton setImage:[[UIImage imageNamed:@"article_expand_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    @weakify(self);
    self.menuButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.delegate didSelectContextMenuFor:self.articleViewModel];
        return [RACSignal empty];
    }];
}

- (void)setArticleViewModel:(EDMXArticleViewModel *)articleViewModel {
    _articleViewModel = articleViewModel;
    self.articleNameLabel.text = self.articleViewModel.article.title;
    self.newsSourceNameLabel.text = self.articleViewModel.article.newsSourceName;
    self.dateLabel.text = self.articleViewModel.publishedAtDateString;
    [self.articleImageView setImageWithURL:self.articleViewModel.articleImageUrl];
    
    if ([articleViewModel isSaved])
        self.savedCheckBoxImageView.image = [UIImage imageNamed:@"article_saved"];
    else
        self.savedCheckBoxImageView.image = nil;
}

@end
