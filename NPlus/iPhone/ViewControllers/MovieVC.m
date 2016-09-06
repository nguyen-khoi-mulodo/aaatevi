//
//  MovieVC.m
//  NPlus
//
//  Created by Anh Le Duc on 7/31/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "MovieVC.h"
#import "ListItemVC.h"
#import "Genre.h"
//#import "ServiceAPIController.h"
static NSString *gID = @"0";

@interface MovieVC ()<ListItemDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *pages;
@end

@implementation MovieVC
@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;
@synthesize curTab = _curTab;
-(NSString *)screenNameGA{
    return @"Genre.Movie";
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.containerView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.pageViewController) {
        [self.pageViewController.view setFrame:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
    }
    self.containerView.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = NO;
    _viewTab.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = _viewTab;
    UIBarButtonItem *barSearch = [[UIBarButtonItem alloc] initWithCustomView:_btnSearch];
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
    self.navigationItem.rightBarButtonItem = barSearch;
    self.navigationItem.leftBarButtonItem = barBack;
    
    [_btnHot setSelected:YES];
    [_btnAll setSelected:NO];
    _btnHot.userInteractionEnabled = NO;
    _btnAll.userInteractionEnabled = YES;
    [_btnBack setTitleColor:COLOR_MAIN_GRAY forState:UIControlStateNormal];
    [_btnBack setTitleColor:COLOR_MAIN_BLUE forState:UIControlStateHighlighted];
    
    _curTab = kTabHot;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    self.pageViewController.view.clipsToBounds = NO;
    [self addChildViewController:self.pageViewController];
    [self.containerView addSubview:self.pageViewController.view];
    [self addPageControl];
    [self updateSegmentControl];
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = NO;
        }
    }
}

- (void)addPageControl{
    NSMutableArray *pages = [NSMutableArray new];
    ListItemVC *viewController = [[ListItemVC alloc] initWithNibName:@"ListItemVC" bundle:nil];
    viewController.delegate = self;
    viewController.isHot = YES;
    [viewController.view setBackgroundColor:RGB(235, 235, 235)];
    [pages addObject:viewController];
    viewController = [[ListItemVC alloc] initWithNibName:@"ListItemVC" bundle:nil];
    viewController.delegate = self;
    viewController.isHot = NO;
    [viewController.view setBackgroundColor:RGB(235, 235, 235)];
    [pages addObject:viewController];
    [self setPages:pages];
}


- (void)updateSegmentControl{
    if ([self.pages count]>0) {
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
    }
}



- (NSMutableArray *)pages
{
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}


- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    
//    [self.pageControl setSelectedSegmentIndex:[self.pages indexOfObject:[viewController.viewControllers lastObject]] animated:YES];
}


- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pages count]) {
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark - Callback

- (IBAction)changeTab:(UIButton*)sender
{
    if (_curTab == kTabHot) {
        _curTab = kTabAll;
        [self selectedTabHot:NO];
    }else{
        _curTab = kTabHot;
        [self selectedTabHot:YES];
    }
    [self.pageViewController setViewControllers:@[self.pages[_curTab]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:NULL];
}

- (IBAction)btnBack_Tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectedTabHot:(BOOL)isSelected{
    [_btnHot setSelected:isSelected];
    [_btnAll setSelected:!isSelected];
    _btnHot.userInteractionEnabled = !isSelected;
    _btnAll.userInteractionEnabled = isSelected;
}

#pragma mark - hot view controller delegate
-(void)loadDataWithCurPage:(NSInteger)cPage withViewController:(ListItemVC *)controller{
    if (controller.dataSources.count == 0) {
        [controller showConnectionErrorView:NO];
        [controller showLoadingDataView:YES];
    }
    
    [[APIController sharedInstance] getShowByGenre:@"5177" withPage:[NSString stringWithFormat:@"%ld", (long)cPage] withSort:controller.isHot ? @"0" : @"1" completed:^(NSArray *results, BOOL isMore, NSString* genreID, NSString* strSort) {
        controller.isLoadMore = isMore;
        if (cPage == kFirstPage) {
            [controller.dataSources removeAllObjects];
            [controller.dataSources addObjectsFromArray:results];
        }else{
            [controller.dataSources addObjectsFromArray:results];
        }
        [controller finishLoadData];
        [controller showLoadingDataView:NO];
        if (controller.dataSources.count == 0) {
            [controller showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if (controller.dataSources.count == 0) {
            [controller showLoadingDataView:NO];
            if (APPDELEGATE.internetConnnected) {
                [controller showConnectionErrorView:NO];
                [controller showNoDataView:YES];
            }else{
                [controller showNoDataView:NO];
                [controller showConnectionErrorView:YES];
            }
        }
    }];
}

-(void)loadGenreWithViewController:(ListItemVC *)viewController{
    [[APIController sharedInstance] getListSubGenre:@"5177" completed:^(NSArray *results) {
//        Genre *genre = [[Genre alloc] init];
//        genre.genre_id = @"5177";
//        genre.genre_name  = @"Tất cả";
//        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:results];
//        [arr insertObject:genre atIndex:0];
        [viewController setShowGenre:results];
    } failed:^(NSError *error) {
        
    }];
}

-(void)loadDataWithCurPage:(NSInteger)cPage withGenreId:(NSString *)genre_id withViewController:(ListItemVC *)controller{
    gID = genre_id;
    if (controller.dataSources.count == 0) {
        [controller showConnectionErrorView:NO];
        [controller showLoadingDataView:YES];
    }
    [[APIController sharedInstance] getShowByGenre:genre_id withPage:[NSString stringWithFormat:@"%ld", (long)cPage] withSort:controller.isHot ? @"0" : @"1" completed:^(NSArray *results, BOOL isMore, NSString* genreID, NSString* strSort) {
        if (![gID isEqualToString:genreID]) {
            return;
        }
        controller.isLoadMore = isMore;
        if (cPage == kFirstPage) {
            [controller.dataSources removeAllObjects];
            [controller.dataSources addObjectsFromArray:results];
        }else{
            [controller.dataSources addObjectsFromArray:results];
        }
        [controller finishLoadData];
        [controller showLoadingDataView:NO];
        if (controller.dataSources.count == 0) {
            [controller showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if (controller.dataSources.count == 0) {
            [controller showLoadingDataView:NO];
            if (APPDELEGATE.internetConnnected) {
                [controller showConnectionErrorView:NO];
                [controller showNoDataView:YES];
            }else{
                [controller showNoDataView:NO];
                [controller showConnectionErrorView:YES];
            }
        }
    }];
}

@end
