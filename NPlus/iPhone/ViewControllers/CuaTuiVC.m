//
//  CuaTuiVC.m
//  NPlus
//
//  Created by Anh Le Duc on 7/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "CuaTuiVC.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "CuaTuiCell.h"
#import "LoginFormVC.h"
#import "NowPlayerVC.h"
#import "JSCustomBadge.h"
#import "LoginVC.h"
#import "VideoLikeVC.h"
#import "OfflineVC.h"
#import "SettingVC.h"
@interface CuaTuiVC ()<LoginDelegate, LoginDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, LoginFormDelegate, FacebookLoginTaskDelegate>{
    
}
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation CuaTuiVC

-(NSString *)screenNameGA{
    return @"CuaTui";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)tabImageName
{
	return @"menu_icon_cuatui";
}

- (NSString *)activeTabImageName
{
	return @"menu_icon_cuatui_hover";
}

- (NSString *)tabTitle
{
	return @"Cá nhân";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *barShop = [[UIBarButtonItem alloc] initWithCustomView:_btnShop];
    UIBarButtonItem *barSetting = [[UIBarButtonItem alloc] initWithCustomView:_btnSetting];
    UIBarButtonItem *barInfoUser = [[UIBarButtonItem alloc] initWithCustomView:_btnInfoUser];
    self.navigationItem.rightBarButtonItems = @[barSetting, barShop];
    self.navigationItem.leftBarButtonItem = barInfoUser;
    
    [_btnDownload setImage:imageNameWithMaskWhiteColor(@"playing_download") forState:UIControlStateNormal];
    [_btnDownload setImage:imageNameWithMaskWhiteColor(@"playing_download") forState:UIControlStateHighlighted];
    [_btnLike setImage:imageNameWithMaskWhiteColor(@"playing_like") forState:UIControlStateNormal];
    [_btnLike setImage:imageNameWithMaskWhiteColor(@"playing_like") forState:UIControlStateHighlighted];
    
    self.pages = [[NSMutableArray alloc] init];
    
    LoginFormVC *loginVC = [[LoginFormVC alloc] initWithNibName:@"LoginFormVC" bundle:nil];
    loginVC.navigationController.navigationBarHidden = YES;
    loginVC.delegate = self;
    [self.pages addObject:loginVC];
    VideoLikeVC *videoLike = [[VideoLikeVC alloc] initWithNibName:@"VideoLikeVC" bundle:nil];
    [self.pages addObject:videoLike];
    self.viewContainer.clipsToBounds = YES;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.viewContainer.frame.size.width, self.viewContainer.frame.size.height);
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.viewContainer addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = NO;
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfo) name:kDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationUserNotLogin) name:kUserNotLoginNotification object:nil];
}

- (void)receiveNotificationUserNotLogin {
    [self showLoadingDataView:NO];
}

- (void)myDealloc{
    [super myDealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLoginNotification object:nil];
}


- (void)setImageBackground{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"personal_bg_header"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setImageBackground];
    [self displayInfo];    
    [_cvMain registerNib:[UINib nibWithNibName:@"CuaTuiCell" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"cuaTuiCellId"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)btnLogin_Tapped:(id)sender {
    if (APPDELEGATE.user) {
        return;
    }
    LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    loginVC.delegate = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)btnDownload_Tapped:(id)sender {
    [self.akTabBarController setSelectedIndex:3];
}

- (IBAction)btnSetting_Tapped:(id)sender {
    SettingVC *settingVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - LoginVC delegate
-(void)loginFormVC:(LoginFormVC *)loginFormVC buttonLoginTapped:(UIButton *)button{
    if (APPDELEGATE.user) {
        [self displayInfo];
        return;
    }
    
//    [[FacebookLoginTask sharedInstance] setTheTask:kTaskLogin];
//    [[FacebookLoginTask sharedInstance] setDelegate:self];
//    [[FacebookLoginTask sharedInstance] loginFacebook];
    
    LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    loginVC.delegate = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)loginSuccessWithTask:(NSString *)task{
    [self displayInfo];
}

-(void)loginVC:(LoginVC *)loginVC withTask:(NSString *)task{
    [self displayInfo];
}



- (void)displayInfo{
    if (APPDELEGATE.user) {
        NSURL *url = [NSURL URLWithString: APPDELEGATE.user.avatar];
        [_btnInfoUser setTitle:APPDELEGATE.user.userName forState:UIControlStateNormal];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
            if (!error) {
                UIImage *img = [image scaledToSize:CGSizeMake(32, 32)];
                [_btnInfoUser setImage:img forState:UIControlStateNormal];
                [_btnInfoUser setImage:img forState:UIControlStateHighlighted];
                for (UIView *view in [_btnInfoUser subviews]) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView = (UIImageView*)view;
                        CGRect frame = imageView.frame;
                        frame.size.width = 32;
                        frame.size.height = 32;
                        imageView.frame = frame;
                        imageView.layer.cornerRadius = 16.0f;
                        [imageView setImage:image];
                    }
                }
            }else{
                [_btnInfoUser setImage:[UIImage imageNamed:@"avatar_default"] forState:UIControlStateNormal];
                [_btnInfoUser setImage:[UIImage imageNamed:@"avatar_default"] forState:UIControlStateHighlighted];
            }
            
        }];
        [self.pageViewController setViewControllers:@[self.pages[1]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }else{
        [_btnInfoUser setTitle:@"Đăng nhập" forState:UIControlStateNormal];
        [_btnInfoUser setImage:[UIImage imageNamed:@"avatar_default"] forState:UIControlStateNormal];
        [_btnInfoUser setImage:[UIImage imageNamed:@"avatar_default"] forState:UIControlStateHighlighted];
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
    }
}

- (void)setBadgeValue:(NSString *)badgeValue{
    JSCustomBadge *badge = (JSCustomBadge*) [_btnDownload viewWithTag:130];
    
    if(!badgeValue || !badgeValue.length) {
        [badge removeFromSuperview];
        return;
    }
    
    BOOL animateChange = NO;
    if(badge) {
        [badge autoBadgeSizeWithString:badgeValue];
    } else {
        badge = [JSCustomBadge customBadgeWithString:badgeValue
                                     withStringColor:[UIColor whiteColor]
                                      withInsetColor:[UIColor redColor]
                                      withBadgeFrame:YES
                                 withBadgeFrameColor:[UIColor redColor]
                                           withScale:0.6f
                                         withShining:NO];
        animateChange = YES;
    }
    
    int badgeWidth = badge.frame.size.width;
    int badgeHeight = badge.frame.size.height;
    
    CGRect tabFrame = _btnDownload.frame;
    
    badge.frame = CGRectMake(tabFrame.size.width / 2 + 5, 5,
                             badgeWidth, badgeHeight);
    badge.tag = 130;
    
    [_btnDownload addSubview:badge];
    if(animateChange) {
        badge.alpha = 0.0;
        badge.transform = CGAffineTransformMakeScale(0.2, 0.2);
        [UIView animateWithDuration:0.2
                         animations:^{
                             badge.alpha = 1.0f;
                             badge.transform = CGAffineTransformIdentity;
                         }];
    }
}

@end
