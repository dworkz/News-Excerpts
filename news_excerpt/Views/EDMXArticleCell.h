//
//  EDMXArticleTableViewCell.h
//  Firstfestival
//
//  Created by Alex Bush on 7/18/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDMXArticleViewModel;

@protocol EDMXArticleCellDelegate <NSObject>
- (void)didSelectContextMenuFor:(EDMXArticleViewModel *)articleViewModel;
@end

@class EDMXArticleViewModel;

@interface EDMXArticleCell : UITableViewCell

@property (nonatomic, strong) EDMXArticleViewModel *articleViewModel;
@property (nonatomic, weak) id<EDMXArticleCellDelegate> delegate;

@end
