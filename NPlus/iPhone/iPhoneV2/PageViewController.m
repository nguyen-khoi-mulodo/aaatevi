//
//  PageViewController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 7/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "PageViewController.h"
#import "WelcomeVC.h"

@interface PageViewController () {
    UIPageControl *pageControl;
    CGFloat yPageControl;
}

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    self.pageController.view.backgroundColor = [UIColor clearColor];
    
    WelcomeVC *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    for (UIView *subview in self.pageController.view.subviews) {
        if ([subview isKindOfClass:[UIPageControl class]]) {
            pageControl = (UIPageControl *)subview;
            pageControl.pageIndicatorTintColor = UIColorFromRGB(0xa4a4a4);
            pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x00adef);
            pageControl.backgroundColor = [UIColor clearColor];
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNoti) name:@"showButtonWelcome" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    yPageControl = pageControl.frame.origin.y;
}

- (void)receiveNoti {
    pageControl.hidden = YES;
    self.btnDone.hidden = NO;

}

- (WelcomeVC *)viewControllerAtIndex:(NSUInteger)index {
    
    WelcomeVC *childViewController = [[WelcomeVC alloc] initWithNibName:@"WelcomeVC" bundle:nil];
    childViewController.index = index;
    if (index == 4) {
        CGFloat w = 0.0f;
        CGFloat h = 0.0f;
        if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
            w = 150.0f;
            h = 30.0f;
            self.btnDone.titleLabel.font = [UIFont fontWithName:kFontRegular size:12];
        } else if (IS_IPHONE_6) {
            w = 176.0f;
            h = 34.0f;
            self.btnDone.titleLabel.font = [UIFont fontWithName:kFontRegular size:14];
        } else if (IS_IPHONE_6P) {
            w = 200.0f;
            h = 40.0f;
            self.btnDone.titleLabel.font = [UIFont fontWithName:kFontRegular size:17];
        }
        
        CGFloat x = (SCREEN_SIZE.width - w)/2;
        CGFloat y = SCREEN_SIZE.height - h - 10;
        self.btnDone.translatesAutoresizingMaskIntoConstraints = YES;
        self.btnDone.frame = CGRectMake(x, y, w, h);
        self.btnDone.clipsToBounds = YES;
        self.btnDone.layer.cornerRadius = 5;
//        pageControl.hidden = YES;
//        self.btnDone.hidden = NO;
        [self.view bringSubviewToFront:_btnDone];
    }
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(WelcomeVC *)viewController index];
    pageControl.hidden = NO;
    self.btnDone.hidden = YES;
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(WelcomeVC *)viewController index];
    index++;
    
    if (index == 5) {
//        pageControl.hidden = YES;
//        self.btnDone.hidden  = NO;
        return nil;
    } else {
        pageControl.hidden = NO;
        self.btnDone.hidden  = YES;
    }
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}
- (IBAction)btnAction:(id)sender {
    [APPDELEGATE start];
}

@end
