//
//  GenreController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/12/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "GenreController.h"
#import "DetailGenreController.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "MyNavigationItem.h"
#import "FWTPopoverView.h"
#import "VideoResultController.h"
#import "TopKeywordCell.h"
#import "MyNavigationItem.h"
#import "ChannelResultController.h"
#import "ArtistResultController.h"

@interface GenreController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    UITableView *tbKeyword;
    BOOL _isReload;
    MyNavigationItem *myNavi;
    BOOL isShowPopup;
    BOOL isShowFilter;
    FWTPopoverView *popoverView;
    NSInteger selectIndex;
    NSMutableArray *arrayKeywords;
    BOOL isSearching;
    VideoResultController *videoVC;
    ChannelResultController *channelVC;
    ArtistResultController *artistVC;
    NSString *_keyword;;
    NSTimer *timerDelayTextChange;
    BOOL isSearchDelay;
}

@end

@implementation GenreController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil listGenres:(NSMutableArray*)listGenres indexTab:(NSUInteger)index {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _listGenres = listGenres;
        selectIndex = index;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.buttonBarView.shouldCellsFillAvailableWidth = NO;
    self.isProgressiveIndicator = NO;
    self.buttonBarView.selectedBar.backgroundColor = UIColorFromRGB(0x00adef);
    [_headerView addSubview:self.buttonBarView];
    [self updateNavigationBar];
    if (!self.isSearch) {
        _viewParentGenre.translatesAutoresizingMaskIntoConstraints = YES;
        _viewParentGenre.frame = CGRectMake(0, -_viewParentGenre.frame.size.height , SCREEN_SIZE.width, _viewParentGenre.frame.size.height);
        _viewParentGenre.alpha = 0;
        [self.view addSubview:_viewParentGenre];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatedSelectedBar:) name:@"updateSelectedBar" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidePopup) name:@"hideGenreView" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidePopup) name:kDidPlayVideo object:nil];
        _type = [Utilities getTypeGenre];
    } else {
        //self.currentIndex = 0;
        arrayKeywords = [[NSMutableArray alloc]init];
        tbKeyword = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 0)];
        tbKeyword.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tbKeyword registerNib:[UINib nibWithNibName:@"TopKeywordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"topKeywordCell"];
        tbKeyword.delegate = self;
        tbKeyword.dataSource = self;
        tbKeyword.scrollEnabled = NO;
        tbKeyword.backgroundColor = UIColorFromRGB(0xfcfcfc);
        [self.view addSubview:tbKeyword];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatedSelectedBar:) name:@"updateSelectedBarSearch" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.akTabBarController hideTabBarAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
    if (self.isSearch) {
        [self trackScreen:@"iOS.Search"];
        APPDELEGATE.rootNavController.navigationBarHidden = YES;
        if (!_isReload) {
            _isReload = YES;
            _headerView.hidden = YES;
            self.containerView.hidden = YES;
            [self loadTopKeyword];
        }
    } else {
        if (selectIndex != 0 && _listGenres) {
            _headerView.hidden = YES;
            self.containerView.hidden = YES;
            [self showProgressHUDWithTitle:nil];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isSearch) {
        if (selectIndex != 0 && _listGenres) {
            [self didSelectTabViewAtIndex:selectIndex animation:NO];
            [self performSelector:@selector(showContentAfterDelay) withObject:nil afterDelay:0.3];
        }
    }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.isSearch) {
        _viewAll.hidden = YES;
        for (NSLayoutConstraint *contraint in _headerView.constraints) {
            if ([contraint.firstItem isEqual:self.buttonBarView] && [contraint.secondItem isEqual:_headerView] && contraint.constant == 80) {
                contraint.constant = 0;
                [_headerView setNeedsLayout];
                [_headerView layoutIfNeeded];
                [self pagerTabStripViewController:self updateIndicatorFromIndex:self.currentIndex toIndex:0];
                break;
            }
        }
    } else {
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)hidePopup {
    if (isShowPopup) {
        isShowPopup = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _viewParentGenre.frame = CGRectMake(0, -_viewParentGenre.frame.size.height, SCREEN_SIZE.width, _viewParentGenre.frame.size.height);
            _viewParentGenre.alpha = 0.0;
        } completion:^(BOOL finished) {
            isShowPopup = NO;
            [_btnTitleGenre setImage: isShowPopup ? [UIImage imageNamed:@"icon-thulai-v2"] : [UIImage imageNamed:@"icon-view-more-v2"] forState:UIControlStateNormal];
        }];
    }
    if (isShowFilter) {
        [self hidePopupFillter];
    }
}
- (void)hidePopupFillter {
    [popoverView dismissPopoverAnimated:YES];
    popoverView = nil;
    isShowFilter = NO;
}
- (void)showContentAfterDelay {
    [self dismissHUD];
    _headerView.hidden = NO;
    self.containerView.hidden = NO;
}

- (MBProgressHUD *)showProgressHUDWithTitle:(NSString *)title {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = title;
    [hud hide:YES afterDelay:20];
    return hud;
}
- (void)dismissHUD {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)loadTopKeyword {
    [[APIController sharedInstance] getTopKeyWordsCompleted:^(int code, NSArray *results) {
        if (code == kAPI_SUCCESS) {
            arrayKeywords = (NSMutableArray*)results;
            if (arrayKeywords.count <= 5) {
                tbKeyword.frame = CGRectMake(0, 0, SCREEN_SIZE.width, _headerKeyword.frame.size.height + arrayKeywords.count*44 + 6);
            } else {
                tbKeyword.frame = CGRectMake(0, 0, SCREEN_SIZE.width, _headerKeyword.frame.size.height + 5*44 + 6);
            }
            [tbKeyword reloadData];
        }
    } failed:^(NSError *error) {
        
    }];
}


- (void)updateNavigationBar {
    if (self.isSearch) {
        if (!myNavi) {
            myNavi = [[MyNavigationItem alloc]initWithController:self type:2];
            myNavi.txfSearchField.delegate = self;
            myNavi.txfSearchField.returnKeyType = UIReturnKeySearch;
            [myNavi.txfSearchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }

    } else {
        if (!myNavi) {
            myNavi = [[MyNavigationItem alloc]initWithController:self type:9];
            UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:_btnFilter];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                             target:nil action:nil];
            negativeSpacer.width = -20;
            
            self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBarItem];
            self.navigationItem.titleView = _btnTitleGenre;
        }
        if ([_genre.genreName isEqualToString:@"Short Film"]) {
            _genre.genreName = @"Phim ngắn";
        }
        [_btnTitleGenre setTitle:[NSString stringWithFormat:@"%@",_genre.genreName] forState:UIControlStateNormal];
        [_btnFilter setTitle:[_type isEqualToString:@"Hot"] ? @"Hot":@"Mới" forState:UIControlStateNormal];
    }
}

- (void)updatedSelectedBar:(NSNotification*)notif {
    [self.buttonBarView reloadData];
    NSDictionary *dict = [notif userInfo];
    NSInteger toIndex = [[dict objectForKey:@"toIndex"]integerValue];
    if (!self.isSearch) {
        if (toIndex == 0) {
            _lineSelected.hidden = NO;
            [_btnSelectAll setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
        } else {
            _lineSelected.hidden = YES;
            [_btnSelectAll setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        }
    }
}

- (IBAction)btnTitleGenreTapped:(id)sender {
    if (isShowFilter) {
        [self hidePopupFillter];
    }
    if (!isShowPopup) {
        isShowPopup = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _viewParentGenre.frame = CGRectMake(0, 0, SCREEN_SIZE.width, _viewParentGenre.frame.size.height);
            _viewParentGenre.alpha = 1;
        } completion:^(BOOL finished) {
            isShowPopup = YES;
            [_btnTitleGenre setImage: isShowPopup ? [UIImage imageNamed:@"icon-thulai-v2"] : [UIImage imageNamed:@"icon-view-more-v2"] forState:UIControlStateNormal];
        }];
        [_btnTVShow setTitleColor:[_genre.genreId isEqualToString:ID_GENRE_TVSHOW ] ? UIColorFromRGB(0x00adef):UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        [_btnRelax setTitleColor:[_genre.genreId isEqualToString:ID_GENRE_GIAITRI ] ? UIColorFromRGB(0x00adef):UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        [_btnShortFilm setTitleColor:[_genre.genreId isEqualToString:ID_GENRE_PHIMNGAN ] ? UIColorFromRGB(0x00adef):UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        
    } else {
        [self hidePopup];
    }
}

- (IBAction)btnSelectAllTapped:(id)sender {
    [self pagerTabStripViewController:self updateIndicatorFromIndex:self.currentIndex toIndex:0];
    [self moveToViewControllerAtIndex:0];
}
- (IBAction)buttonParentGenreTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    Genre *genre = [[Genre alloc]init];
    switch (btn.tag) {
        case 0:
            genre.genreId = ID_GENRE_PHIMNGAN;
            genre.genreName = kGENRE_SHORT_FILM;
            break;
        case 1:
            genre.genreId =ID_GENRE_TVSHOW;
            genre.genreName = kGENRE_TV_SHOW;
            break;
        case 2:
            genre.genreId =ID_GENRE_GIAITRI;
            genre.genreName = kGENRE_RELAX;
            break;
        default:
            break;
    }
    if ([_genre.genreId isEqualToString:genre.genreId]) {
        [self btnTitleGenreTapped:_btnTitleGenre];
        return;
    }
    switch (btn.tag) {
        case 0:
            [self trackScreen:@"iOS.Shortfilm"];
            break;
        case 1:
            [self trackScreen:@"iOS.TVShow"];
            break;
        case 2:
            [self trackScreen:@"iOS.Relax"];
            break;
        default:
        break;
    }
    
    _genre = genre;
    [[APIController sharedInstance]getListGenresWithParentId:genre.genreId completed:^(int code, NSArray *results) {
        if (results) {
            _listGenres = (NSMutableArray*)results;
            self.currentIndex = 0;
            [self reloadPagerTabStripView];
            [self pagerTabStripViewController:self updateIndicatorFromIndex:self.currentIndex toIndex:0];
        }
    } failed:^(NSError *error) {
        
    }];
    [self updateNavigationBar];
    [self btnTitleGenreTapped:_btnTitleGenre];
    
}
- (IBAction)btnFilterTapped:(id)sender {
    if (isShowPopup) {
        [UIView animateWithDuration:0.3 animations:^{
            _viewParentGenre.frame = CGRectMake(0, -_viewParentGenre.frame.size.height, SCREEN_SIZE.width, _viewParentGenre.frame.size.height);
            _viewParentGenre.alpha = 0.0;
        } completion:^(BOOL finished) {
            isShowPopup = NO;
            [_btnTitleGenre setImage: isShowPopup ? [UIImage imageNamed:@"icon-thulai-v2"] : [UIImage imageNamed:@"icon-view-more-v2"] forState:UIControlStateNormal];
        }];
    }
    if (!popoverView) {
        popoverView = [[FWTPopoverView alloc] init];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*40, 70, 40)];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:i == 0 ? @"Mới":@"Hot" forState:UIControlStateNormal];
            [btn setTitleColor:[btn.titleLabel.text isEqualToString:_type] ? UIColorFromRGB(0x00adef):UIColorFromRGB(0xffffff)forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:kFontRegular size:15];
            btn.tag = i;
            if (i == 0) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, btn.frame.size.height-0.5, btn.frame.size.width, 0.5)];
                line.backgroundColor = RGBA(240, 240, 240, 0.1);
                [btn addSubview:line];
            }
            
            [popoverView.contentView addSubview:btn];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 5.0;
            [btn addTarget:self action:@selector(btnTypeFilterTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        popoverView.adjustPositionInSuperviewEnabled = NO;
        popoverView.contentSize = CGSizeMake(70, 2*40);
        [popoverView presentFromRect:CGRectMake(SCREEN_SIZE.width- _btnFilter.frame.size.width/2 - 5, -10, 0, 0)
                                       inView:self.view
                      permittedArrowDirection:FWTPopoverArrowDirectionUp
                                     animated:YES];
        isShowFilter = YES;
    } else {
        [self hidePopupFillter];
    }
}

- (void)btnTypeFilterTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 0) {
        _type = @"Mới";
        [Utilities setTypeGenre:NEW_TYPE];
    } else if (btn.tag == 1) {
        _type = @"Hot";
        [Utilities setTypeGenre:HOT_TYPE];
    }
    
    [_btnFilter setTitle:_type forState:UIControlStateNormal];
    [popoverView dismissPopoverAnimated:YES];
    popoverView = nil;
    isShowFilter = NO;
    
    for (int i = 0; i <self.pagerTabStripChildViewControllers.count; i ++) {
        UIViewController *vc = [self.pagerTabStripChildViewControllers objectAtIndex:i];
        if ([vc isKindOfClass:[DetailGenreController class]]) {
            DetailGenreController *child = (DetailGenreController*)vc;
            child.type = _type;
            if (i == self.currentIndex) {
                [child loadDataIsAnimation:NO];
            }
        }
    }
}

#pragma mark - UITableView

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerKeyword.frame.size.height;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _headerKeyword;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrayKeywords.count > 5) {
        if (indexPath.row == 4) {
            return 50;
        }
    } else {
        if (indexPath.row == arrayKeywords.count - 1) {
            return 50;
        }
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrayKeywords.count > 5) {
        return 5;
    }
    return arrayKeywords.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *topKeywordCell = @"topKeywordCell";
    TopKeywordCell *cell = (TopKeywordCell*)[tbKeyword dequeueReusableCellWithIdentifier:topKeywordCell];
    if (!cell) {
        cell = [Utilities loadView:[TopKeywordCell class] FromNib:@"TopKeywordCell"];
    }
    
    if (indexPath.row < arrayKeywords.count && indexPath.row < 5) {
        TopKeyword* item = [arrayKeywords objectAtIndex:indexPath.row];
        cell.keyword = item;
        [cell loadContentWithIndex:indexPath.row];
    }
    cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (arrayKeywords.count > indexPath.row && indexPath.row < 5) {
        [self trackEvent:@"iOS_top_keywords"];
        TopKeyword* item = [arrayKeywords objectAtIndex:indexPath.row];
        if (item.itemkey && ![item.itemkey isEqualToString:@""]) {
            if ([item.type isEqualToString:@"channel"]) {
                Channel *cn = [[Channel alloc]init];
                cn.channelId = item.itemkey;
                [APPDELEGATE didSelectChannelCellWith:cn isPush:NO];
            }else if([item.type isEqualToString:@"video"]){
                Video* video = [[Video alloc] init];
                video.video_id = item.itemkey;
                [APPDELEGATE didSelectVideoCellWith:video];
            }else if([item.type isEqualToString:@"artist"]){
                Artist* artist = [[Artist alloc] init];
                artist.artistId = [item.itemkey intValue];
                [APPDELEGATE didSelectArtistCellWith:artist];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"commit editing");
}


#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _headerView.hidden = NO;
    self.containerView.hidden = NO;
    tbKeyword.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _headerView.hidden = NO;
    self.containerView.hidden = NO;
    tbKeyword.hidden = YES;
}

- (void) OnTextChange {
    if (videoVC) {
        videoVC.pageIndex = 1;
        [videoVC searchVideoByKeyWord:_keyword isNewSearch:YES];
    }
    
    if (channelVC) {
        channelVC.pageIndex = 1;
        [channelVC searchChannelByKeyWord:_keyword isNewSearch:YES];
    }
    if (artistVC) {
        artistVC.pageIndex = 1;
        [artistVC searchArtistByKeyWord:_keyword isNewSearch:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *trimmedKeyword = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedKeyword isEqualToString:_keyword]) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(OnTextChange) object:nil];
    if (timerDelayTextChange)
    {
        if ([timerDelayTextChange isValid])
        {
            [timerDelayTextChange invalidate];
            //[NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
        timerDelayTextChange=nil;
    }
    _keyword = searchText;
    timerDelayTextChange = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(OnTextChange) userInfo:nil repeats:NO];
}

- (void)textFieldDidChange:(UITextField *)textField {
    _keyword = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    
    if (!isSearchDelay) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(OnTextChange) object:nil];
        if (timerDelayTextChange)
        {
            if ([timerDelayTextChange isValid])
            {
                [timerDelayTextChange invalidate];
            }
            timerDelayTextChange=nil;
        }
        timerDelayTextChange = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(OnTextChange) userInfo:nil repeats:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *trimmedKeyword = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if ([trimmedKeyword isEqualToString:@""]) {
//        isSearchDelay = YES;
//    } else {
//        isSearchDelay = NO;
//    }
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - XLPagerTabStripViewControllerDataSource
- (NSArray*)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    NSMutableArray * childViewControllers = [[NSMutableArray alloc]init];
    if (!self.isSearch) {
        if (_listGenres) {
            for (int i = 0; i < _listGenres.count; i++) {
                Genre *genre = (Genre*)[_listGenres objectAtIndex:i];
                DetailGenreController *child = [[DetailGenreController alloc]initWithNibName:@"HomeVC" bundle:nil];
                child.genre = genre;
                child.type = _type;
                if (selectIndex != 0 && _listGenres) {
                    child.isNotLoading = YES;
                }
                [childViewControllers addObject:child];
            }
        }
    } else {
        if (_listSearch) {
            videoVC = [[VideoResultController alloc]initWithNibName:@"HomeVC" bundle:nil];
            channelVC = [[ChannelResultController alloc]initWithNibName:@"HomeVC" bundle:nil];
            artistVC = [[ArtistResultController alloc]initWithNibName:@"HomeVC" bundle:nil];
            videoVC.title = @"Video";
            channelVC.title = @"Kênh";
            artistVC.title = @"Nghệ sĩ";
            [childViewControllers addObject:videoVC];
            [childViewControllers addObject:channelVC];
            [childViewControllers addObject:artistVC];
        }
    }
    

//    if (!_isReload){
        return (NSArray*)childViewControllers;
//    }
//    NSMutableArray * childViewControllers = [NSMutableArray arrayWithObjects:child1, child2, child3, child4, child5, nil];
//    NSUInteger count = [childViewControllers count];
//    for (NSUInteger i = 0; i < count; ++i) {
//        // Select a random element between i and end of array to swap with.
//        NSUInteger nElements = count - i;
//        NSUInteger n = (arc4random() % nElements) + i;
//        [childViewControllers exchangeObjectAtIndex:i withObjectAtIndex:n];
//    }
//    NSUInteger nItems = 1 + (rand() % 5);
//    return [childViewControllers subarrayWithRange:NSMakeRange(0, nItems)];
}

-(void)reloadPagerTabStripView
{
    //_isReload = YES;
    self.isProgressiveIndicator = (rand() % 2 == 0);
    self.isElasticIndicatorLimit = (rand() % 2 == 0);
    [super reloadPagerTabStripView];
}
@end
