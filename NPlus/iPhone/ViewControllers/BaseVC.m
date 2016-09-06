//
//  BaseVC.m
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "BaseVC.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "RelatedVC.h"
#import "EGORefreshTableHeaderView.h"

@interface BaseVC ()

@end

@implementation BaseVC
@synthesize noDataView = _noDataView;
@synthesize errorView = _errorView;
@synthesize loadingDataView = _loadingDataView;
@synthesize dataSources = _dataSources;
@synthesize curPage = _curPage;
@synthesize isLoadMore = _isLoadMore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)trackScreen:(NSString *)screen {
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:screen];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
- (void)trackEvent:(NSString *)event {
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction
           value:event];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"TeVi_Action" action:@"Action" label:event value:nil] build]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
//    if (!IS_IPAD) {
//        if (IOS_NEWER_OR_EQUAL_TO_7 && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//            self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
//            self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
//        }
//        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//        self.navigationController.navigationBar.translucent = YES;
//        self.navigationController.navigationBarHidden = NO;
//        self.navigationItem.hidesBackButton = YES;
//    }
    _curPage = kFirstPage;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLoginNotify) name:kDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLogoutNotify) name:kDidLoginNotification object:nil];
    
}

- (void)didLoginNotify {};
- (void)didLogoutNotify {};

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if (!IS_IPAD) {
        self.screenName = [NSString stringWithFormat:@"iOS.%@", [self screenNameGA]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
    [self myDealloc];
}

-(NSString *)screenNameGA{
    return [NSString stringWithFormat:@"%@", [self class]];
}

#pragma mark Helper
- (void) myDealloc
{
    if ([self.dataView isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *) self.dataView;
        tableView.delegate = nil;
        tableView.dataSource = nil;
        [tableView removeFromSuperview];
        self.dataView = nil;
    }
    if ([self.dataView isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *tableView = (UICollectionView *) self.dataView;
        tableView.delegate = nil;
        tableView.dataSource = nil;
        [tableView removeFromSuperview];
        self.dataView = nil;
    }
    if (self.dataSources)
    {
        [self.dataSources removeAllObjects];
        self.dataSources = nil;
    }
}

- (void)reloadTableViewDataSource
{
    _reloading = YES;
    _curPage = kFirstPage;
    if (IS_IPAD) {
        [self loadData];
    } else {
        [self loadDataIsAnimation:NO];
    }
    
   // [self finishLoadData];
}
- (void)loadData{};
- (void)loadDataIsAnimation:(BOOL)isAnimation{}
-(void) loadMore
{
    _curPage++;
    if (IS_IPAD) {
        [self loadData];
    } else {
        [self loadDataIsAnimation:NO];
    }
}


- (void)doneLoadingTableViewData
{
	_reloading = NO;
}

-(void)finishLoadData{
    [self removeBackgroundFooter];
    if ([self.dataView respondsToSelector:@selector(reloadData)])
    {
        [self.dataView performSelector:@selector(reloadData)];
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y + scrollView.frame.size.height  > (scrollView.contentSize.height - CELL_HEIGHT_MORE))
	{
        if(_isLoadMore)
		{
            [self loadMore];
            _isLoadMore = NO;
		}
	}
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!IS_IPAD) {
        //[self setBackgroundFooter];
    }
}


- (void)setBackgroundHeader{
    if (_backgroundHeader && [_backgroundHeader superview]) {
        [_backgroundHeader removeFromSuperview];
    }
    _backgroundHeader = [[UIView alloc] initWithFrame:
                         CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                    self.view.frame.size.width, self.view.bounds.size.height)];
    _backgroundHeader.backgroundColor = RGB(235, 235, 235);
    [self.dataView addSubview:_backgroundHeader];
}

- (void)setBackgroundFooter{
    CGFloat height = 0;
    if ([self getContentSize] > self.dataView.frame.size.height) {
        height = [self getContentSize];
    }else{
        height = [self getContentSize];
    }
    if (_backgroundFooter && [_backgroundFooter superview]) {
        // reset position
        _backgroundFooter.frame = CGRectMake(0.0f,
                                              height,
                                              self.dataView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _backgroundFooter = [[UIView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.dataView.frame.size.width, self.view.bounds.size.height)];
        if (IS_IPAD) {
//            [_backgroundFooter setBackgroundColor:RGB(60, 83, 94)];
            [_backgroundFooter setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_video"]]];
            
        }else{
            _backgroundFooter.backgroundColor = RGB(235, 235, 235);
        }
        [self.dataView addSubview:_backgroundFooter];
    }
}

- (void)removeBackgroundFooter{
    if (_backgroundFooter && [_backgroundFooter superview]) {
        [_backgroundFooter removeFromSuperview];
    }
    _backgroundFooter = nil;
}

- (float)getContentSize{
    if ([self.dataView isKindOfClass:[UICollectionView class]]) {
        return [((UICollectionView*)self.dataView) contentSize].height;
    }else if([self.dataView isKindOfClass:[UITableView class]]){
        return [((UITableView*)self.dataView) contentSize].height;
    }
    return 0;
}

-(void) showConnectionErrorView: (BOOL) error
{
    if (self.errorView == nil)
    {
        if (IS_IPAD) {
            self.errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_SIZE.width, self.view.frame.size.height - 65 - 60)];
//            self.errorView.center = self.view.center;
            self.errorView.backgroundColor = [UIColor whiteColor];
        }else{
            self.errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, self.view.frame.size.height)];
            //self.errorView.center = self.view.center;
            self.errorView.backgroundColor = [UIColor clearColor];
        }
        
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 55)];
        imageview.center = self.errorView.center;
        imageview.image = [UIImage imageNamed:@"icon-matketnoi"];
        [imageview setTag:100];
        [self.errorView addSubview:imageview];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.errorView.bounds;
        [button addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
        [self.errorView addSubview:button];
        [self.view addSubview:self.errorView];
    }
    self.dataView.hidden = error;
    self.errorView.hidden = !error;
}

-(void) showConnectionErrorView: (BOOL) error isFull:(BOOL) isFull
{
    if (isFull) {
        if (self.errorView == nil)
        {
            self.errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            self.errorView.backgroundColor = [UIColor whiteColor];
            
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 55)];
            imageview.center = self.errorView.center;
            imageview.image = [UIImage imageNamed:@"icon-matketnoi"];
            [imageview setTag:100];
            [self.errorView addSubview:imageview];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = self.errorView.bounds;
            [button addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
            [self.errorView addSubview:button];
            [self.view addSubview:self.errorView];
        }else{
            [self.errorView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }
        
        UIImageView* errorImage = (UIImageView*)[self.errorView viewWithTag:100];
        [errorImage setCenter:self.errorView.center];
        self.dataView.hidden = error;
        self.errorView.hidden = !error;
    }else{
        [self showConnectionErrorView:error];
    }
    
}

- (void) showNoDataView: (BOOL) show
{
    if (self.noDataView == nil) {
        if (IS_IPAD) {
            self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }else{
            self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, self.view.frame.size.height)];
        }
        self.noDataView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:self.noDataView atIndex:0];
        
        UILabel *text = [[UILabel alloc] initWithFrame:self.noDataView.bounds];
        text.text = @"Chưa có dữ liệu";
        if (IS_IPAD) {
            text.textColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
            text.font = [UIFont fontWithName:kFontRegular size:18.0];
        }else{
            text.textColor = [UIColor colorWithWhite:0.4f alpha:1.0f];
            text.font = [UIFont italicSystemFontOfSize:18];
        }
        text.backgroundColor = [UIColor clearColor];
        text.textAlignment = NSTextAlignmentCenter;
        [self.noDataView addSubview:text];
    }
    self.dataView.hidden = show;
    self.noDataView.hidden = !show;
}

-(void)showLoadingDataView:(BOOL)show{
    if (self.loadingDataView == nil) {
        if (IS_IPAD) {
            self.loadingDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }else{
            self.loadingDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, self.view.frame.size.height)];
        }
        self.loadingDataView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.loadingDataView];
        UIActivityIndicatorView* loadView;
        if (IS_IPAD) {
            loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }else{
            loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        loadView.center = self.loadingDataView.center;
        [loadView startAnimating];
        [self.loadingDataView addSubview:loadView];
    }
    self.dataView.hidden = show;
    self.loadingDataView.hidden = !show;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (IS_IPAD) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}




@end
