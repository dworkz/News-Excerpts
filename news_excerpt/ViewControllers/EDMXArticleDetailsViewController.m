//
//  EDMXArticleDetailsViewController.m
//  Firstfestival
//
//  Created by Alex Bush on 7/30/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleDetailsViewController.h"
#import "EDMXArticleDetailsViewModel.h"
#import "TSMiniWebBrowser.h"
#import "EDMXSaveArticleActionViewModel.h"
#import "EDMXArticleContextMenuViewController.h"
#import "EDMXArticleContextMenuViewModel.h"
#import "MZFormSheetController.h"
#import "EDMXUser.h"
#import "UIViewController+EDMXSignIn.h"
#import "EDMXArticleDetailsContextMenuViewController.h"
#import "EDMXArticle.h"

@interface EDMXArticleDetailsViewController ()<EDMXArticleContextMenuActionDelegate, EDMXArticleSaveActionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIView *articleDetailsViewContainer;

@property (nonatomic, strong) EDMXSaveArticleActionViewModel *saveActionViewModel;

@end

@implementation EDMXArticleDetailsViewController

- (id)initWithViewModel:(EDMXArticleDetailsViewModel *)viewModel {
    if (self = [super initWithNibName:@"EDMXArticleDetailsViewController" bundle:nil])
    {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNabBar];
    
    if (self.saveActionViewModel.isSaved)
        [self.saveButton setTitle:@"- Remove" forState:UIControlStateNormal];
    else
        [self.saveButton setTitle:@"+ Save" forState:UIControlStateNormal];
    
    [self addSaveAction];
    
    [self addShowFavoritesListAction];
    
    [self addShareAction];
    
    if (self.childViewControllers.count == 0) {
        TSMiniWebBrowser *browserVC = [[TSMiniWebBrowser alloc] initWithURL:[self.viewModel url]];
        browserVC.mode = TSMiniWebBrowserModeModal;
        browserVC.showActionButton = NO;
        [browserVC willMoveToParentViewController:self];
        [self addChildViewController:browserVC];
        UIView *browserRootView = browserVC.view;
        browserRootView.frame = self.articleDetailsViewContainer.bounds;
        [self.articleDetailsViewContainer addSubview:browserRootView];
        [browserVC didMoveToParentViewController:self];
    }
}

- (void)addSaveAction {
    @weakify(self);
    self.saveButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
        @strongify(self);
        if ([EDMXUser isSignedIn]) {
            [self.saveActionViewModel action];
        } else {
            [self presentSignInViewControllerInViewController:self withBlock:^{
                [self.saveActionViewModel action];
            }];
        }
        
        return [RACSignal empty];
    }];
}

- (void)addShowFavoritesListAction {
    @weakify(self);
    self.favoritesButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
        @strongify(self);
        if ([EDMXUser isSignedIn]) {
            [self showContextMenu];
        } else {
            [self presentSignInViewControllerInViewController:self withBlock:^{
                [self showContextMenu];
            }];
        }
        
        return [RACSignal empty];
    }];
}

- (void)addShareAction {
    @weakify(self);
    self.shareButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
        @strongify(self);
        
        [self showShareVC];
        
        return [RACSignal empty];
    }];
}

- (void)showShareVC {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[self.viewModel.model, self.viewModel.shareImage]
                                                        applicationActivities:nil];    
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:^{
                         
                     }];
}

- (void)actionCompleted:(EDMXArticleContextMenuActionViewModel *)actionViewModel {
    
}

- (void)saveActionCompleted:(BOOL)isSaved {
    if (isSaved)
        [self.saveButton setTitle:@"- Remove" forState:UIControlStateNormal];
    else
        [self.saveButton setTitle:@"+ Save" forState:UIControlStateNormal];
}

- (void)showContextMenu {
    EDMXArticleDetailsContextMenuViewController *vc = [[EDMXArticleDetailsContextMenuViewController alloc] initWithViewModel:
                                                       [[EDMXArticleContextMenuViewModel alloc] initWithModel:
                                                        self.viewModel.model mode:EDMXArticleContextMenuModeShort]];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
    formSheet.cornerRadius = 4.0;
    formSheet.portraitTopInset = 100.0;
    formSheet.landscapeTopInset = 100.0;
    formSheet.presentedFormSheetSize = CGSizeMake(300, 350);
    
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
}

#pragma mark - Private

- (void)setupNabBar {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBG"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [self backNavigationButton];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBG"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edmxTitle"]]];
}

- (void)onBackButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)backNavigationButton {
    return [[UIBarButtonItem alloc] initWithImage:[self backImage]
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(onBackButtonClick)];
}

- (UIImage *)backImage {
    return [UIImage imageNamed:@"back_button"];
}

- (EDMXSaveArticleActionViewModel *)saveActionViewModel {
    if (!_saveActionViewModel) {
        _saveActionViewModel = self.viewModel.saveArticleActionViewModel;
        _saveActionViewModel.delegate = self;
    }
    return _saveActionViewModel;
}

@end