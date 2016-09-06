//
//  RankVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/31/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "CategoryVC_iPad.h"
#import "Genre.h"
#import "CuaTuiVC_iPad.h"
#import "UIImageEffects.h"
#import "ShareTask.h"

#define COLUMN_NUMS 7
#define PADDING 0
#define PADDING_Y 5

@interface CuaTuiVC_iPad ()

@end

@implementation CuaTuiVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [btnDone.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//    [btnDone.layer setBorderWidth:1.0f];
//    [btnDone.layer setCornerRadius:5.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfo) name:kDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDiskSpace) name:kUpdateDiskSpaceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kDidLogoutNotification object:nil];
    
//    [btnTabLiked.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
//    [btnTabViewLater.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbNotiLoginFacebook setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [btnNewFeed.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [btnLichSu.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [btnXemSau.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [btnFollow.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [btnNotification.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [btnCaiDat.titleLabel setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    
    [btnNewFeed sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

- (void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
    [self displayInfo];
    [self updateDiskSpace];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doSelectedMenu:(id)sender {
    UIButton* btn = sender;
    if (btnMenuCurrent) {
        if (btnMenuCurrent.tag == btn.tag) {
            return;
        }
    }
    [btnMenuCurrent setSelected:NO];
    [self selectedWithButton:btnMenuCurrent];
    btnMenuCurrent = btn;
    [btnMenuCurrent setSelected:YES];
    [self selectedWithButton:btnMenuCurrent];
    
}

- (void) selectedWithButton:(UIButton*) btnMenu
{
    if (!btnMenu.selected) {
        switch (btnMenu.tag) {
            case Follow:
                if ([self.view.subviews containsObject:channelLikedVC.view]) {
                    [channelLikedVC.view removeFromSuperview];
                }
                break;
            case XemSau:
                if ([self.view.subviews containsObject:xemsauVC.view]) {
                    [xemsauVC.view removeFromSuperview];
                }
                break;
            case Notification:
                if ([self.view.subviews containsObject:notificationVC.view]) {
                    [notificationVC.view removeFromSuperview];
                }
                break;
            case NewFeed:
                if ([self.view.subviews containsObject:newFeedVC.view]) {
                    [newFeedVC.view removeFromSuperview];
                }
                break;
            case History:
                if ([self.view.subviews containsObject:historyVC.view]) {
                    [historyVC.view removeFromSuperview];
                }
                break;
            default:
                break;
        }
    }else{
        switch (btnMenu.tag) {
            case Follow:
            {
                if (!channelLikedVC) {
                    channelLikedVC = [[LikedChannelVC_iPad alloc] initWithNibName:@"LikedChannelVC_iPad" bundle:nil];
                    [channelLikedVC setDelegate:self];
                    
                }else{
                    [channelLikedVC loadData];
                }
                [channelLikedVC.view setFrame:CGRectMake(menuView.frame.size.width, 0, channelLikedVC.view.frame.size.width, channelLikedVC.view.frame.size.height)];
                [self.view addSubview:channelLikedVC.view];
            }
                break;
            case XemSau:
            {
                if (!xemsauVC) {
                    xemsauVC = [[VideoViewLaterVC_iPad alloc] initWithNibName:@"VideoViewLaterVC_iPad" bundle:nil];
                    [xemsauVC setDelegate:self];
                }else{
                    [xemsauVC loadData];
                }
                [xemsauVC.view setFrame:CGRectMake(menuView.frame.size.width, 0, xemsauVC.view.frame.size.width, xemsauVC.view.frame.size.height)];
                [self.view addSubview:xemsauVC.view];
            }
                break;
            case Notification:
            {
                if (!notificationVC) {
                    notificationVC = [[NotificationVC_iPad alloc] initWithNibName:@"NotificationVC_iPad" bundle:nil];
                    [notificationVC setDelegate:self];
                }else{
                    [notificationVC loadData];
                }
                [notificationVC.view setFrame:CGRectMake(menuView.frame.size.width, 0, notificationVC.view.frame.size.width, notificationVC.view.frame.size.height)];
                [self.view addSubview:notificationVC.view];
            }
                break;
            case NewFeed:
            {
                if (!newFeedVC) {
                    newFeedVC = [[NewFeedVC_iPad alloc] initWithNibName:@"NewFeedVC_iPad" bundle:nil];
                    [newFeedVC setDelegate:self];
                }else{
                    [newFeedVC loadData];
                }
                [newFeedVC.view setFrame:CGRectMake(menuView.frame.size.width, 0, newFeedVC.view.frame.size.width, newFeedVC.view.frame.size.height)];
                [self.view addSubview:newFeedVC.view];
            }
                break;
            case History:
            {
                if (!historyVC) {
                    historyVC = [[HistoryVC_iPad alloc] initWithNibName:@"HistoryVC_iPad" bundle:nil];
                    [historyVC setDelegate:self];
                }else{
                    [historyVC loadData];
                }
                [historyVC.view setFrame:CGRectMake(menuView.frame.size.width, 0, historyVC.view.frame.size.width, historyVC.view.frame.size.height)];
                [self.view addSubview:historyVC.view];
            }
                break;
            default:
                break;
        }
    }
}



- (void) showTabCuaTui:(BOOL) isShow{
    fromRootVC = YES;
    if (isShow) {
        [btnTabLiked sendActionsForControlEvents:UIControlEventTouchUpInside];
    }else{
        [btnTabViewLater sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)displayInfo{
    [_btnInfoUser setUserInteractionEnabled:!APPDELEGATE.user];
    if (APPDELEGATE.user) {
        User* user = APPDELEGATE.user;
        NSURL *url = [NSURL URLWithString: user.avatar];
        [_btnInfoUser setTitle:user.userName forState:UIControlStateNormal];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
            if (!error) {
                UIImage *img = [image scaledToSize:CGSizeMake(90, 90)];
                [_btnAvatar setImage:img forState:UIControlStateNormal];
                [_btnAvatar setImage:img forState:UIControlStateHighlighted];
                _btnAvatar.imageView.layer.cornerRadius = 45.0f;
                _btnAvatar.imageView.layer.borderWidth = 1.0f;
                _btnAvatar.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
                [_btnInfoUser setTitle:user.displayName forState:UIControlStateNormal];
                [_btnInfoUser.titleLabel setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
                [btnTabLiked sendActionsForControlEvents:UIControlEventTouchUpInside];
            }else{
                [self userNotLogin];
            }
        }];
    }else{
        [self userNotLogin];

    }
    [menuView setHidden:(!APPDELEGATE.user)];
    [loginView setHidden:(APPDELEGATE.user != nil)];
}

- (void) userNotLogin{
    _btnAvatar.imageView.layer.cornerRadius = 45.0f;
    _btnAvatar.imageView.layer.borderWidth = 1.0f;
    [_btnAvatar.imageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_btnAvatar setImage:[UIImage imageNamed:@"default-dienvien-ipad"] forState:UIControlStateNormal];
    [_btnAvatar setImage:[UIImage imageNamed:@"default-dienvien-ipad"] forState:UIControlStateHighlighted];
    [_btnInfoUser setTitle:@"Đăng nhập" forState:UIControlStateNormal];
}

- (void) logout{
    [self userNotLogin];
    [menuView setHidden:(!APPDELEGATE.user)];
    [loginView setHidden:(APPDELEGATE.user != nil)];
    if (btnMenuCurrent.tag == 0) { // tui thich
        [channelLikedVC.view removeFromSuperview];
    }else{
        [xemsauVC.view removeFromSuperview];
    }
    
}

- (void) shareFacebookWithItem:(id) item{
    BOOL share = YES;
    if ([item isKindOfClass:[Video class]]) {
        Video* video = (Video*) item;
        if ([video.link_share isEqualToString:@""]) {
            [APPDELEGATE showToastWithMessage:@" Hiện chưa có link chia sẻ cho video này." position:@"bottom" type:errorImage];
            share = NO;
        }
    }else if([item isKindOfClass:[Channel class]]){
        Channel* channel = (Channel*)item;
        if ([channel.linkShare isEqualToString:@""]) {
            [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho kênh này." position:@"bottom" type:errorImage];
            share = NO;
        }
    }else if([item isKindOfClass:[Artist class]]){
        Artist* artist = (Artist*)item;
        if ([artist.shortLink isEqualToString:@""]) {
            [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho nghệ sĩ này." position:@"bottom" type:errorImage];
            share = NO;
        }
    }
    if (share) {
        [[ShareTask sharedInstance] setViewController:self];
        [[ShareTask sharedInstance] shareFacebook:item];
    }
}

- (IBAction) doLogin:(id)sender{
    if (!APPDELEGATE.user) {
        [[FacebookLoginTask sharedInstance] setTheTask:kTaskLogin];
        [[FacebookLoginTask sharedInstance] setDelegate:self];
        [[FacebookLoginTask sharedInstance] loginFacebook];
    }
}



- (void) showLoginWithTask:(NSString*) task andObject:(id) item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginWithTask:andObject:)]) {
        [self.delegate showLoginWithTask:task andObject:item];
    }
}


- (IBAction) doShowSettingVC:(id)sender{
    UIButton* btn = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showSettingView:)]) {
        [self.delegate showSettingView:!btn.selected];
    }
}

- (IBAction) doShowShopVC:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showShopView:)]) {
        [self.delegate showShopView:YES];
    }
}

//- (void) setSelectedWithButtonSetting:(BOOL) selected{
//    [btnSetting setSelected:selected];
//}

//- (void) historyViewClose{
//    if (btnSetting.selected) {
//        [btnSetting setSelected:NO];
//    }
//}

- (IBAction) doEdit:(id) sender{
//    UIButton* btn = sender;
//    [downloadVC loadCategoryType:download_type andSreenType:downloadScreen andSubScreenType:(btnSubMenuCurrent == btnTabDownloaded) ? downloadedScreen : downloadingScreen andIsEdit:(btn == btnDelete)];
//    [btnDelete setHidden:(btn == btnDelete)];
//    [btnDone setHidden:!btnDelete.hidden];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//-(IBAction)indexChanged:(UISegmentedControl *)sender
//{
//    [self showListWithWithSegmentIndex:(int)self.segmentedControl.selectedSegmentIndex];
//}
//
//- (void) showListWithWithSegmentIndex:(int) index{
//    switch (_categoryType) {
//        case film_type:
//            _genreIDCurrent = ID_CATE_FILM;
//            break;
//        case funny_type:
//            _genreIDCurrent = ID_CATE_HAIKICH;
//            break;
//        case tv_type:
//            _genreIDCurrent = ID_CATE_TVSHOW;
//            break;
//        case cartoon_type:
//            _genreIDCurrent = ID_CATE_CARTOON;
//            break;
//        case music_type:
//            _genreIDCurrent = ID_CATE_AMNHAC;
//            break;
//        default:
//            break;
//    }
//    if (index == 0) {
//        [self.categoryView setHidden:YES];
//        [loadingList stopAnimating];
//        [self loadPage];
//        [UIView animateWithDuration:0.5f animations:^(void){
//            [subListVideoVC.view setFrame:CGRectMake(subListVideoVC.view.frame.origin.x, self.headerView.frame.origin.y + self.headerView.frame.size.height + PADDING, subListVideoVC.view.frame.size.width, SCREEN_HEIGHT - self.headerView.frame.origin.y - self.headerView.frame.size.height - PADDING)];
//        }];
//    }else if(index == 1){
//        [UIView animateWithDuration:0.5f animations:^(void){
//            [subListVideoVC.view setFrame:CGRectMake(subListVideoVC.view.frame.origin.x, self.categoryView.frame.origin.y + self.categoryView.frame.size.height + PADDING, subListVideoVC.view.frame.size.width, SCREEN_HEIGHT - self.categoryView.frame.origin.y - self.categoryView.frame.size.height - PADDING)];
//        } completion:^(BOOL finished) {
//            [self.categoryView setHidden:NO];
//            if (!listGenres) {
//                [loadingList startAnimating];
//                [[APIController sharedInstance] getListSubGenre:[NSString stringWithFormat:@"%d", _genreIDCurrent] completed:^(NSArray *results) {
//                    listGenres = [NSMutableArray arrayWithArray:results];
//                    [self drawListGenreWithList:results];
//                    [loadingList stopAnimating];
//                } failed:^(NSError *error) {
//                    
//                }];
//            }
//        }];
//    }
//}
//
//- (void) drawListGenreWithList:(NSArray*) list{
//    for (UIView* view in self.subCategoryScrollView.subviews) {
//        [view removeFromSuperview];
//    }
//    float dX = 10.0f;
//    float dY = 3.0f;
//    float height = 30.0f;
//    float contentWidth = 0.0f;
//    for (int i = 0; i < list.count + 1; i++) {
//        NSString* name = @"Tất cả";
//        int genreID = -1;
//        switch (_categoryType) {
//            case film_type:
//                genreID = ID_CATE_FILM;
//                break;
//            case funny_type:
//                genreID = ID_CATE_HAIKICH;
//                break;
//            case tv_type:
//                genreID = ID_CATE_TVSHOW;
//                break;
//            case cartoon_type:
//                genreID = ID_CATE_CARTOON;
//                break;
//            case music_type:
//                genreID = ID_CATE_AMNHAC;
//                break;
//            default:
//                break;
//        }
//        if (i > 0) {
//            Genre* genre = [list objectAtIndex:i - 1];
//            name = genre.genre_name;
//            genreID = [genre.genre_id intValue];
//        }
//        CGSize size = [name sizeWithFont:[UIFont systemFontOfSize:13.0f]];
//        UIButton* btnGener = [[UIButton alloc] initWithFrame:CGRectMake(contentWidth + dX, dY, size.width + 5, height)];
//        contentWidth += dX + btnGener.frame.size.width;
//        [btnGener setTitle:name forState:UIControlStateNormal];
//        [btnGener setBackgroundColor:[UIColor clearColor]];
//        [btnGener setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [btnGener setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:235/255.0 alpha:1.0f] forState:UIControlStateHighlighted];
//        [btnGener setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:235/255.0 alpha:1.0f] forState:UIControlStateSelected];
//        [btnGener.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        [btnGener.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
//        [btnGener addTarget:self action:@selector(doSelectGenre:) forControlEvents:UIControlEventTouchUpInside];
//        [btnGener setTag:genreID];
//        if (i == 0) {
//            [btnGener sendActionsForControlEvents:UIControlEventTouchUpInside];
//        }
//        [self.subCategoryScrollView addSubview:btnGener];
//    }
//
//    [self.subCategoryScrollView setContentSize:CGSizeMake(contentWidth, self.subCategoryScrollView.frame.size.height)];
//    [self.subCategoryScrollView setContentOffset:CGPointZero];
//}
//
//
//- (void) doSelectGenre:(id) sender{
//    UIButton* btn = sender;
//    if (subButtonCurrent) {
//        [subButtonCurrent.layer setBorderColor:[[UIColor clearColor] CGColor]];
//        [subButtonCurrent.layer setBorderWidth:0.0f];
//        [subButtonCurrent setSelected:NO];
//    }
//    
//    subButtonCurrent = btn;
//    [subButtonCurrent.layer setBorderColor:[[UIColor colorWithRed:20/255.0 green:155/255.0 blue:235/255.0 alpha:1.0f] CGColor]];
//    [subButtonCurrent.layer setBorderWidth:1.0f];
//    [subButtonCurrent.layer setCornerRadius:5.0f];
//    [subButtonCurrent setSelected:YES];
//    _genreIDCurrent = (int)subButtonCurrent.tag;
//    [self loadPage];
//}
//
//- (void) loadPage{
//    [subListVideoVC loadPageWithGenreID:_genreIDCurrent andSort:(int) self.segmentedControl.selectedSegmentIndex andCategoryType:_categoryType andSreenType:categoryScreen];
//}
//
//- (IBAction) doSearch:(id)sender{
//    if (self.parentDelegate && [self.parentDelegate respondsToSelector:@selector(showSearchVC)]) {
//        [self.parentDelegate showSearchVC];
//    }
//}

- (void)updateDiskSpace{
//    _viewDiskSpace.backgroundColor = RGB(221, 221, 221);
//    [_viewDiskSpace setBackgroundColor:[UIColor clearColor]];
//    _lbInfoSpace.textColor = RGB(95, 95 ,95);
    [_lbInfoSpace setTextColor:[UIColor whiteColor]];
    _lbInfoSpace.text = [self getDiskSpaceInfo];
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        [_propressSpace setTintColor:RGB(20, 159, 240)];
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
