//
//  NPVideoPlayerDetailView.m
//  NPlus
//
//  Created by Le Duc Anh on 9/15/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "NPVideoPlayerDetailView.h"
#import "ChooseVideoVC.h"
@interface NPVideoPlayerDetailView()
{
    BOOL _isAnimation;
    NSInteger _currentTag;
}
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *pages;
@end
@implementation NPVideoPlayerDetailView
@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;
@synthesize delegate = _delegate;
@synthesize chooseVideo = _chooseVideo;
@synthesize detailVideo = _detailVideo;
@synthesize downloadVideo = _downloadVideo;
@synthesize isShow = _isShow;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isShow = NO;
        _isAnimation = NO;
        _currentTag = 0;
        UIImageView *backgroundViewDetail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 320)];
        [backgroundViewDetail setImage:[UIImage imageNamed:@"bg_popup_video_ngang"]];
        [self addSubview:backgroundViewDetail];
        
        self.btnTabChoose = [[UIButton alloc] initWithFrame:CGRectMake(0, 110, 30, 38)];
        [self.btnTabChoose setImage:[UIImage imageNamed:@"playing_danhmuc"] forState:UIControlStateNormal];
        [self.btnTabChoose setImage:[UIImage imageNamed:@"playing_danhmuc_hover"] forState:UIControlStateHighlighted];
        [self.btnTabChoose setImage:[UIImage imageNamed:@"playing_danhmuc_hover"] forState:UIControlStateSelected];
        [self.btnTabChoose addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
        self.btnTabChoose.tag = 100;
        [self addSubview:self.btnTabChoose];
        
        self.btnTabDetail = [[UIButton alloc] initWithFrame:CGRectMake(0, 110 + 38, 30, 38)];
        [self.btnTabDetail setImage:[UIImage imageNamed:@"playing_title"] forState:UIControlStateNormal];
        [self.btnTabDetail setImage:[UIImage imageNamed:@"playing_title_hover"] forState:UIControlStateHighlighted];
        [self.btnTabDetail setImage:[UIImage imageNamed:@"playing_title_hover"] forState:UIControlStateSelected];
        [self.btnTabDetail addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
        self.btnTabDetail.tag = 101;
        [self addSubview:self.btnTabDetail];
        
        self.btnTabDownload = [[UIButton alloc] initWithFrame:CGRectMake(0, 110 + 38 + 38, 30, 38)];
        [self.btnTabDownload setImage:[UIImage imageNamed:@"playing_download"] forState:UIControlStateNormal];
        [self.btnTabDownload setImage:[UIImage imageNamed:@"playing_download_hover"] forState:UIControlStateHighlighted];
        [self.btnTabDownload setImage:[UIImage imageNamed:@"playing_download_hover"] forState:UIControlStateSelected];
        [self.btnTabDownload addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
        self.btnTabDownload.tag = 102;
        [self addSubview:self.btnTabDownload];
        
        self.viewContainer = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 345, 320)];
        self.viewContainer.backgroundColor = [UIColor clearColor];
        self.viewContainer.tag = 999;
        [self addSubview:self.viewContainer];
        
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.pageViewController.view.frame = CGRectMake(0, 0, self.viewContainer.frame.size.width, self.viewContainer.frame.size.height);
        [self.pageViewController setDataSource:self];
        [self.pageViewController setDelegate:self];
        [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
//        [self addChildViewController:self.pageViewController];
        [self.viewContainer addSubview:self.pageViewController.view];
        [self addPageControl];
        [self updateSegmentControl];
        for (UIScrollView *view in self.pageViewController.view.subviews) {
            
            if ([view isKindOfClass:[UIScrollView class]]) {
                
                view.scrollEnabled = NO;
            }
        }
    }
    return self;
}

- (void)addPageControl{
    NSMutableArray *pages = [NSMutableArray new];
    _chooseVideo = [[ChooseVideoLandscapeVC alloc] initWithNibName:@"ChooseVideoLandscapeVC" bundle:nil];
    [_chooseVideo.view setBackgroundColor:[UIColor clearColor]];
    [pages addObject:_chooseVideo];
    _detailVideo = [[VideoDetailLandscapeVC alloc] initWithNibName:@"VideoDetailLandscapeVC" bundle:nil];
    [_detailVideo.view setBackgroundColor:[UIColor clearColor]];
    [pages addObject:_detailVideo];
    _downloadVideo = [[VideoDownloadLandscapeVC alloc] initWithNibName:@"VideoDownloadLandscapeVC" bundle:nil];
    [_downloadVideo.view setBackgroundColor:[UIColor clearColor]];
    [pages addObject:_downloadVideo];
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

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        NSLog(@"subview: %@ and tag: %li", [view class], (long)view.tag);
    }
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (void)toggleShowDetail{
    if (_isShow) {
        [self hideDetail];
    }else{
        [self showDetail];
    }
}

- (void)showDetail{
    if (_isAnimation || _isShow) {
        return;
    }
    _isAnimation = YES;
    self.frame = CGRectMake(CGRectGetWidth(self.superview.frame) - 30, 0, 375, 320);
    self.hidden = NO;
    CGRect frame = CGRectMake(CGRectGetWidth(self.superview.frame) - 375, 0, 375, 320);
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            _isShow = YES;
            _isAnimation = NO;
        }
    }];
}

- (void)hideDetail{
    if (_isAnimation || !_isShow) {
        return;
    }
    _isAnimation = YES;
    CGRect frame = CGRectMake(CGRectGetWidth(self.superview.frame) - 30, 0, 375, 320);
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            _isShow = NO;
            _isAnimation = NO;
        }
    }];
}

- (void)changeTab:(UIButton*)button{
    NSInteger tag = button.tag;
    if (_isShow && tag == _currentTag) {
        [self hideDetail];
        return;
    }
    [self.pageViewController setViewControllers:@[self.pages[tag-100]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:NULL];
    _currentTag = tag;
    [self showDetail];
    [[NSNotificationCenter defaultCenter] postNotificationName:kToggleShowTabVideoDetailLandscape object:nil];
}



@end
