//
//  EDMXFeaturedArticleCell.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 31/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXFeaturedArticleCell.h"

@interface EDMXFeaturedArticleCell()

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *exclusiveContentLabel;

@end

@implementation EDMXFeaturedArticleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSMutableAttributedString* exclusiveContentString = [[NSMutableAttributedString alloc] initWithString: @"FEATURED CONTENT"];
    [exclusiveContentString addAttribute:NSKernAttributeName value:@(4.0) range:NSMakeRange(0, exclusiveContentString.length)];
    self.exclusiveContentLabel.attributedText = exclusiveContentString;
    
}

@end
