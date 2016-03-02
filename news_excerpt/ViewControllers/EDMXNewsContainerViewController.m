//
//  EDMXNewsContainerViewController.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 29/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXNewsContainerViewController.h"
#import "EDMXNewsViewController.h"
#import "EDMXNewsViewModel.h"
#import "EDMXUser.h"
#import "UIViewController+EDMXSignIn.h"
#import "UIColor+Extantion.h"

@interface EDMXNewsContainerViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *articlesViewContainer;
@property (nonatomic, strong, readwrite) EDMXNewsViewModel *viewModel;

@end

@implementation EDMXNewsContainerViewController

- (id)initWithViewModel:(EDMXNewsViewModel *)viewModel {
    if (self = [super init])
    {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNabBar];
    if (self.childViewControllers.count == 0) {
        EDMXNewsViewController *newsViewController = [[EDMXNewsViewController alloc] initWithViewModel:self.viewModel];
        [newsViewController willMoveToParentViewController:self];
        [self addChildViewController:newsViewController];
        UIView *newsRootView = newsViewController.view;
        newsRootView.frame = self.articlesViewContainer.bounds;
        [self.articlesViewContainer addSubview:newsRootView];
        [newsViewController didMoveToParentViewController:self];
    }
    @weakify(self);
    RAC(self.viewModel, scope) = [[self.segmentedControl rac_newSelectedSegmentIndexChannelWithNilValue:@(0)] filter:^BOOL(id value) {
        @strongify(self);
        return [self ableToChangeScope:[value integerValue]];
    }];
    
    
    self.segmentedControl.tintColor = [UIColor edmxLightBlueColor];
}

- (BOOL)ableToChangeScope:(NewsScope)scope {
    if (scope == NewsScopeAll || [EDMXUser isSignedIn]) {
        return YES;
    }
    [self presentSignInViewControllerInViewController:self withBlock:^{
        self.segmentedControl.selectedSegmentIndex = self.viewModel.scope = [EDMXUser isSignedIn] ? scope : NewsScopeAll;
    }];
    self.segmentedControl.selectedSegmentIndex = NewsScopeAll;
    return NO;
}

@end
