#import "EDMXNewsViewController.h"
#import "EDMXNewsViewModel.h"
#import "AFNetworking.h"
#import "RACAFNetworking.h"
#import "ArticlesDataSource.h"
#import "EDMXArticleCell.h"
#import "EDMXFeaturedArticleCell.h"
#import "EDMXArticle.h"
#import "EDMXArticleViewModel.h"
#import "EDMXArticleDetailsViewController.h"
#import "EDMXArticleContextMenuViewController.h"
#import "MZFormSheetController.h"
#import "EDMXArticleContextMenuViewModel.h"
#import "UIViewController+EDMXSignIn.h"
#import "EDMXUser.h"

@interface EDMXNewsViewController () <NewsViewModelDelegate, EDMXArticleCellDelegate>

@property (nonatomic, strong, readwrite) EDMXNewsViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, strong) EDMXArticleCell *articlePrototypeCell;
@property (nonatomic, strong) EDMXFeaturedArticleCell *featuredArticlePrototypeCell;

@end

@implementation EDMXNewsViewController

- (EDMXArticleCell *)articlePrototypeCell {
    return _articlePrototypeCell ? _articlePrototypeCell : (_articlePrototypeCell = [self.tableView dequeueReusableCellWithIdentifier:ArticleCellIdentifier]);
}

- (EDMXFeaturedArticleCell *)featuredArticlePrototypeCell {
    return _featuredArticlePrototypeCell ? _featuredArticlePrototypeCell : (_featuredArticlePrototypeCell = [self.tableView dequeueReusableCellWithIdentifier:FeaturedArticleCellIdentifier]);
}

- (id)initWithViewModel:(EDMXNewsViewModel *)viewModel {
    if (self = [super init])
    {
        self.viewModel = viewModel;
        self.viewModel.newsViewModelDelegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"EDMXArticleCell" bundle:nil] forCellReuseIdentifier:ArticleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"EDMXFeaturedArticleCell" bundle:nil] forCellReuseIdentifier:FeaturedArticleCellIdentifier];
    ArticlesDataSource *articlesDataSource = [[ArticlesDataSource alloc] initWithViewModel:self.viewModel];
    articlesDataSource.cellDelegate = self;
    self.dataSource = articlesDataSource;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self.viewModel action:@selector(loadHead) forControlEvents:UIControlEventValueChanged];
    
    RAC(self.viewModel, query) = self.searchField.rac_textSignal;
    
    @weakify(self);
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber *loading) {
        BOOL isLoading = [loading boolValue];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isLoading];
        @strongify(self);
        if (self.viewModel.isLoadingTail || self.viewModel.isSearching) {
            [self.loadingActivityIndicator startAnimating];
        }
        else {
            [self.loadingActivityIndicator stopAnimating];
        }
    }];

    [RACObserve(self.viewModel, loadingHead) subscribeNext:^(NSNumber *loadingHead) {
        BOOL isLoadingHead = [loadingHead boolValue];
        @strongify(self);
        if (isLoadingHead) {
            [self.refreshControl beginRefreshing];
        }
        else {
            [self.refreshControl endRefreshing];
        }
    }];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.searchField.leftView = paddingView;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)showContextMenu:(EDMXArticleViewModel *)viewModel {
    EDMXArticleContextMenuViewController *vc = [[EDMXArticleContextMenuViewController alloc] initWithViewModel:[[EDMXArticleContextMenuViewModel alloc] initWithModel:viewModel.article]];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    formSheet.cornerRadius = 4.0;
    formSheet.portraitTopInset = 130.0;
    formSheet.landscapeTopInset = 100.0;
    formSheet.presentedFormSheetSize = CGSizeMake(316, 250);
    
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
}

#pragma mark - NewsViewModelDelegate

- (void)newsViewModelDidChangeSearchResults {
    [self.tableView reloadData];
}

#pragma mark - EDMXArticleCellDelegate

- (void)didSelectContextMenuFor:(EDMXArticleViewModel *)articleViewModel {
    if ([EDMXUser isSignedIn]) {
        [self showContextMenu:articleViewModel];
    } else {
        [self presentSignInViewControllerInViewController:self withBlock:^{
            [self showContextMenu:articleViewModel];
        }];
    }   
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDMXArticleViewModel *articleViewModel = [self.dataSource itemAtIndexPath:indexPath];
    UIView *view = articleViewModel.article.isFeatured ? self.featuredArticlePrototypeCell.contentView : self.articlePrototypeCell.contentView;
    return view.bounds.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDMXArticleDetailsViewController *detailsVC = [[EDMXArticleDetailsViewController alloc] initWithViewModel:[self.viewModel articleDetailsViewModelForIndexPath:indexPath]];
    [self.navigationController pushViewController:detailsVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height <= self.view.bounds.size.height) {
        return;
    }
    
    CGFloat distanceToBottom = scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height);
    
    if (distanceToBottom <= self.tableView.rowHeight && !self.viewModel.loading && !self.refreshControl.refreshing) {
        [self.viewModel loadTail];
    }
}

@end