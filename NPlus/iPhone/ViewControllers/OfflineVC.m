//
//  OfflineVC.m
//  NPlus
//
//  Created by Anh Le Duc on 7/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "OfflineVC.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"


#import "DownloadedVC.h"
#import "DownloadingVC.h"
#import "DownloadManager.h"
@interface OfflineVC ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>{
    BOOL _isEdit, _isCheckAll;
    NSInteger bagdeCount;
    NSNotification *tempNoti;
}
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *pages;
@end

@implementation OfflineVC

-(NSString *)screenNameGA{
    return @"Offline";
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
	return @"playing_download";
}

- (NSString *)activeTabImageName
{
	return @"playing_download_hover";
}

- (NSString *)tabTitle
{
	return @"Offline";
}

- (void)setBackgroundForNavigationBar{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"personal_bg_header"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isEdit = NO;
    _isCheckAll = NO;
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *barDelete = [[UIBarButtonItem alloc] initWithCustomView:_btnEdit];
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
    self.navigationItem.rightBarButtonItem = barDelete;
    self.navigationItem.leftBarButtonItem = barBack;
    
    [_btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [_btnBack setImage:imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateNormal];
//    [_btnBack setImage:imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateHighlighted];
    [_btnEdit setImage:imageNameWithMaskWhiteColor(@"icon_delete") forState:UIControlStateNormal];
    [_btnEdit setImage:imageNameWithMaskWhiteColor(@"icon_delete") forState:UIControlStateHighlighted];
    
//    [_btnDownloaded setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
//    [_btnDownloaded setTitleColor:RGB(76, 183, 255) forState:UIControlStateHighlighted];
//    [_btnDownloaded setTitleColor:RGB(76, 183, 255) forState:UIControlStateSelected];
//    
//    [_btnDownloading setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
//    [_btnDownloading setTitleColor:RGB(76, 183, 255) forState:UIControlStateHighlighted];
//    [_btnDownloading setTitleColor:RGB(76, 183, 255) forState:UIControlStateSelected];
    
    self.pages = [[NSMutableArray alloc] init];
    
    DownloadedVC *downloadedVC = [[DownloadedVC alloc] initWithNibName:@"DownloadedVC" bundle:nil];
    [self.pages addObject:downloadedVC];
    DownloadingVC *downloadingVC = [[DownloadingVC alloc] initWithNibName:@"DownloadingVC" bundle:nil];
    [self.pages addObject:downloadingVC];
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
    CGRect frame = _viewEdit.frame;
    frame.size.width = SCREEN_WIDTH;
    frame.origin.y = self.view.frame.size.height + 100;
    _viewEdit.frame = frame;
    _viewEdit.layer.borderWidth = 0.5f;
    _viewEdit.layer.borderColor = RGB(223, 223, 223).CGColor;
    [self.view addSubview:_viewEdit];
    
    [_btnCheckAll setTitleColor:RGB(104, 104, 104) forState:UIControlStateNormal];
    [_btnDelete setTitleColor:RGB(242, 68, 44) forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incrementBagde:) name:kIncrementBagdeDownloadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDiskSpace) name:kUpdateDiskSpaceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationLoadData:) name:kDidLoadDownloadedVideoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationLoadData:) name:kDidLoadDownloadingVideoNotification object:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateBagde) userInfo:nil repeats:NO];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kIncrementBagdeDownloadNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateDiskSpaceNotification object:nil];
}

- (void)receiveNotificationLoadData:(NSNotification *)data {

//    tempNoti = data;
    id vc = [self.pageViewController.viewControllers firstObject];
    NSDictionary *dict = [data userInfo];
    NSString *key = [[dict allKeys]lastObject];
    if ([key isEqualToString:kDidLoadDownloadedVideoNotification]) {
        BOOL isHadData = [[dict objectForKey:key]boolValue];
        if (!isHadData) {
            _isEdit = NO;
        }
        if ([vc isKindOfClass:[DownloadedVC class]]) {
            DownloadedVC *downloadedVC = (DownloadedVC*)vc;
            if ([downloadedVC.dataSources count] <= 0) {
                [self showEditView:NO];
            }
            _btnEdit.hidden = !isHadData;
        }
    } else if ([key isEqualToString:kDidLoadDownloadingVideoNotification]) {
        BOOL isHadData = [[dict objectForKey:key]boolValue];
        if (!isHadData) {
            _isEdit = NO;
        }
        if ([vc isKindOfClass:[DownloadingVC class]]) {
            DownloadingVC *downloadingVC = (DownloadingVC *)vc;
            if ([downloadingVC.dataSources count] <= 0) {
                [self showEditView:NO];
            }
            _btnEdit.hidden = !isHadData;
        }
    }
}

- (void)updateBagde{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bagdeCount = 0;
    if ([defaults objectForKey:SETTING_BAGDE]) {
        bagdeCount = [[defaults objectForKey:SETTING_BAGDE] integerValue];
    }
    [self.akTabBarController setBadgeValue:(bagdeCount == 0) ? nil : [NSString stringWithFormat:@"%ld", (long)bagdeCount] forItemAtIndex:3];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateDiskSpace];
    [self setBackgroundForNavigationBar];
    NSInteger count = [[[DownloadManager sharedInstance] getListVideoDownload] count];
    if (count > 0) {
        [self.pageViewController setViewControllers:@[self.pages[1]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        _btnDownloading.selected = YES;
        _btnDownloaded.selected = NO;
        [self selectedViewLeft:NO];
    }else{
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        _btnDownloaded.selected = YES;
        _btnDownloading.selected = NO;
        [self selectedViewLeft:YES];
    }
}

- (void)selectedViewLeft:(BOOL)s{
    _viewLeft.hidden = !s;
    _viewRight.hidden = s;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButtonCheckAll:) name:kOfflineCheckAllNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButtonDelete:) name:kOfflineCountItemCheckNotification object:nil];
    [self.akTabBarController setBadgeValue:nil forItemAtIndex:3];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:0] forKey:SETTING_BAGDE];
    [defaults synchronize];
    bagdeCount = 0;
    
    [self updateFrameForEditView];
}

- (void)updateFrameForEditView{
    CGRect frame = _viewEdit.frame;
    frame.origin.y = self.view.bounds.size.height;
    _viewEdit.frame = frame;
    
    _viewDiskSpace_Bottom.constant = self.akTabBarController.tabBar.bounds.size.height;
    [_viewDiskSpace layoutIfNeeded];
}

- (void)incrementBagde:(NSNotification*)notification{
    bagdeCount++;
    [self.akTabBarController setBadgeValue:[NSString stringWithFormat:@"%ld", (long)bagdeCount] forItemAtIndex:3];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:bagdeCount] forKey:SETTING_BAGDE];
    [defaults synchronize];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.akTabBarController showTabBarAnimated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOfflineCheckAllNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOfflineCountItemCheckNotification object:nil];
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

- (IBAction)btnBack_Tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDownloaded_Tapped:(id)sender {
    id vc = [self.pageViewController.viewControllers objectAtIndex:0];
    if ([vc isKindOfClass:[DownloadingVC class]]) {
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        if ([vc respondsToSelector:@selector(onEdit:)]) {
            [vc onEdit:NO];
        }
        _isEdit = NO;
        [self showEditView:_isEdit];
        _btnDownloaded.selected = YES;
        _btnDownloading.selected = NO;
        _isCheckAll = NO;
        [_btnCheckAll setTitle:@"Chọn tất cả" forState:UIControlStateNormal];
        [_btnDelete setTitle:@"Xóa" forState:UIControlStateNormal];
        [self selectedViewLeft:YES];
    }
    
}

- (IBAction)btnDownloading_Tapped:(id)sender {
    id vc = [self.pageViewController.viewControllers objectAtIndex:0];
    if ([vc isKindOfClass:[DownloadedVC class]]) {
        [self.pageViewController setViewControllers:@[self.pages[1]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        if ([vc respondsToSelector:@selector(onEdit:)]) {
            [vc onEdit:NO];
        }
        _isEdit = NO;
        [self showEditView:_isEdit];
        _btnDownloading.selected = YES;
        _btnDownloaded.selected = NO;
        _isCheckAll = NO;
        [_btnCheckAll setTitle:@"Chọn tất cả" forState:UIControlStateNormal];
        [_btnDelete setTitle:@"Xóa" forState:UIControlStateNormal];
        [self selectedViewLeft:NO];
    }
    
}

- (IBAction)btnEdit_Tapped:(id)sender {
    _isEdit = !_isEdit;
    [self showEditView:_isEdit];
    id vc = [self.pageViewController.viewControllers firstObject];
    if ([vc respondsToSelector:@selector(onEdit:)]) {
        [vc onEdit:_isEdit];
    }
    [_btnCheckAll setTitle:@"Chọn tất cả" forState:UIControlStateNormal];
    [_btnDelete setTitle:@"Xóa" forState:UIControlStateNormal];
    _isCheckAll = NO;
}

- (IBAction)btnCheckAll_Tapped:(id)sender {
    _isCheckAll = !_isCheckAll;
    id vc = [self.pageViewController.viewControllers firstObject];
    if ([vc respondsToSelector:@selector(onCheckAll:)]) {
        [vc onCheckAll:_isCheckAll];
    }
}

- (IBAction)btnDelete_Tapped:(id)sender {
    id vc = [self.pageViewController.viewControllers firstObject];
    if ([vc respondsToSelector:@selector(onDelete)]) {
        [vc onDelete];
    }
//    if ([vc isKindOfClass:[DownloadingVC class]]) {
//        DownloadingVC *downloadingVC = (DownloadingVC *)vc;
//        if ([downloadingVC.dataSource count] <= 0) {
//            [self showEditView:NO];
//        }
//    } else if ([vc isKindOfClass:[DownloadingVC class]]) {
//        DownloadedVC *downloadedVC = (DownloadedVC*)vc;
//        if ([downloadedVC.dataSource count] <= 0) {
//            [self showEditView:NO];
//        }
//    }
}

- (void)showEditView:(BOOL)isEdit{
    if (isEdit) {
        CGRect frame = _viewEdit.frame;
        frame.origin.y = self.view.frame.size.height - 50;
        [UIView animateWithDuration:0.3f animations:^{
            _viewEdit.frame = frame;
        }];
        [self.akTabBarController hideTabBarAnimated:NO];
    }else{
        CGRect frame = _viewEdit.frame;
        frame.origin.y = self.view.frame.size.height;
        [UIView animateWithDuration:0.3f animations:^{
            _viewEdit.frame = frame;
        }completion:^(BOOL finished) {
            if (finished) {
                [self.akTabBarController showTabBarAnimated:NO];
            }
        }];
        
    }
    if (_isEdit) {
        [_btnEdit setTitle:@"Xong" forState:UIControlStateNormal];
        [_btnEdit setTitle:@"Xong" forState:UIControlStateHighlighted];
        [_btnEdit setImage:[UIImage new] forState:UIControlStateNormal];
        [_btnEdit setImage:[UIImage new] forState:UIControlStateHighlighted];
        [UIView animateWithDuration:0.3f animations:^{
            _viewDiskSpace.alpha = 0.0f;
        }];
    }else{
        [_btnEdit setTitle:@"" forState:UIControlStateNormal];
        [_btnEdit setTitle:@"" forState:UIControlStateHighlighted];
        [_btnEdit setImage:imageNameWithMaskWhiteColor(@"icon_delete") forState:UIControlStateNormal];
        [_btnEdit setImage:imageNameWithMaskBlueColor(@"icon_delete") forState:UIControlStateHighlighted];
        [UIView animateWithDuration:0.3f animations:^{
            _viewDiskSpace.alpha = 1.0f;
        }];
    }
}

- (void)updateButtonCheckAll:(NSNotification*)notification{
    NSDictionary *userInfo = notification.userInfo;
    BOOL isCheckAll = [[userInfo objectForKey:@"checkAll"] boolValue];
    if (isCheckAll) {
        [_btnCheckAll setTitle:@"Hủy chọn tất cả" forState:UIControlStateNormal];
    }else{
        [_btnCheckAll setTitle:@"Chọn tất cả" forState:UIControlStateNormal];
    }
    _isCheckAll = isCheckAll;
}

- (void)updateButtonDelete:(NSNotification*)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSInteger count = [[userInfo objectForKey:@"count"] integerValue];
    if (count > 0 ) {
        [_btnDelete setTitle:[NSString stringWithFormat:@"Xóa (%d)", (int)count] forState:UIControlStateNormal];
    }else{
        [_btnDelete setTitle:@"Xóa" forState:UIControlStateNormal];
    }
    
}

- (void)updateDiskSpace{
    _viewDiskSpace.backgroundColor = RGB(221, 221, 221);
    _lbInfoSpace.textColor = RGB(95, 95 ,95);
    _lbInfoSpace.text = [self getDiskSpaceInfo];
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        [_propressSpace setTintColor:RGB(177, 177, 177)];
        [_propressSpace setTrackTintColor:RGB(211, 211, 211)];
    }
    
    _propressSpace.progress = 1 - [self getDiskSpaceInfoFloat];
}

-(NSString *)getDiskSpaceInfo{
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
    }else
        return nil;
    
    NSString *infostr = [NSString stringWithFormat:@"Tổng dung lượng %.2fG/Khả dụng %.2fG", ((totalSpace/1024.0f)/1024.0f)/1024.0f, ((totalFreeSpace/1024.0f)/1024.0f)/1024.0f];
    return infostr;
    
}

-(float)getDiskSpaceInfoFloat{
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
    }else
        return 0;
    float total = ((totalSpace/1024.0f)/1024.0f)/1024.0f;
    float free = ((totalFreeSpace/1024.0f)/1024.0f)/1024.0f;
    return free/total;
    
}


@end
