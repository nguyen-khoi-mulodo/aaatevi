//
//  DiscoveryVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 4/28/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "DiscoveryVC.h"
#import "TopKeyword.h"
#import "MyNavigationItem.h"
#import "GenreController.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"

#define Padding (IS_IPHONE_6P ? 92 : 84)

@interface DiscoveryVC () <UITextFieldDelegate> {
    MyNavigationItem *myNaviItem;
    UIButton *rightBarBtn;
    UITextField *txfSearchField;
    UIView *titleView;
}

@end

@implementation DiscoveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    myNaviItem = [[MyNavigationItem alloc]initWithController:self type:1];
    rightBarBtn = myNaviItem.rightBtn;
    [lbTitleTopKeys setFont:[UIFont fontWithName:kFontMedium size:17.0f]];
    [self.tbMain setContentInset:UIEdgeInsetsMake(0, 0, 55, 0)];
    listIds = [NSString stringWithFormat:@"%@-%@-%@", ID_GENRE_PHIMNGAN, ID_GENRE_TVSHOW, ID_GENRE_GIAITRI];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [_tbMain addSubview:refreshControl];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNoti) name:@"enableButton" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Khám phá";
    [self trackScreen:@"iOS.Discover"];
    [self.tbMain setContentOffset:CGPointMake(0, 0)];
    isUp = NO;
    APPDELEGATE.rootNavController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self.akTabBarController showTabBarAnimated:YES];
    [self getDiscoveryData];
    if (titleView) {
        titleView = nil;
        txfSearchField = nil;
        self.navigationItem.titleView = nil;
        rightBarBtn.hidden = NO;
    }
    [self enableButton:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!txfSearchField) {
        rightBarBtn.alpha = 1.0;
    }
}
- (NSString*)screenNameGA {
    return @"iOS.Discover";
}

#pragma mark Tab & Title

- (NSString *)tabImageName
{
    return @"main-explorer-v2";
}

- (NSString *)activeTabImageName
{
    return @"main-explorer-h-v2";
}

- (NSString *)tabTitle
{
    return @"Khám phá";
}

- (void)enableButton:(BOOL)enable {
    _btnRelax.userInteractionEnabled = enable;
    _btnShortFilm.userInteractionEnabled = enable;
    _btnTVShow.userInteractionEnabled = enable;
    _btnShortFilm.exclusiveTouch = YES;
    _btnTVShow.exclusiveTouch = YES;
    _btnRelax.exclusiveTouch = YES;
}

- (void)receiveNoti {
    [self enableButton:YES];
}

#pragma mark Load Data

- (void) getDiscoveryData {
    if (APPDELEGATE.internetConnnected) {
        [loadingTopKeys startAnimating];
        [[APIController sharedInstance] getTopKeyWordsCompleted:^(int code, NSArray *results) {
            if (code == kAPI_SUCCESS) {
                arrTopKeys = results;
                [[APIController sharedInstance] getMultiListGenres:listIds completed:^(int code, NSArray* results){
                    arrGenres = results;
                    [_tbMain reloadData];
                } failed:^(NSError *error){
                
                }];
            }
        } failed:^(NSError *error) {
            
        }];
        __viewNoConnection.hidden = YES;
    } else {
        __viewNoConnection.hidden = NO;
    }
}


#pragma mark TableView Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == tags) {
        return tagsView.frame.size.height;
    }else if(indexPath.row == genres){
        return genreView.frame.size.height + 10;
    }
    return 51 + [self getRowsGenreWithType:(int)indexPath.row] * 40 + 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == tags) {
        if (![cell.subviews containsObject:tagsView]) {
            [tagsView setTranslatesAutoresizingMaskIntoConstraints:YES];
            [tagsView setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, tagsView.frame.size.height)];
            [cell addSubview:tagsView];
            [tagsContent setFrame:CGRectMake(0, tagsContent.frame.origin.y, tagsView.frame.size.width, tagsContent.frame.size.height)];
        }
        [self initTagsView];
    }else if(indexPath.row == genres){
        if (![cell.subviews containsObject:genreView]) {
            [genreView setTranslatesAutoresizingMaskIntoConstraints:YES];
            [genreView setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, genreView.frame.size.height)];
            [cell addSubview:genreView];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, genreView.frame.size.height, SCREEN_SIZE.width, 1)];
            lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
            UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, genreView.frame.size.height + 1, SCREEN_SIZE.width, 10)];
            paddingView.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [cell addSubview:lineView];
            [cell addSubview:paddingView];
        }
    }else{
        static NSString* genreCellId = @"discoverGenreIdentifier";
        DiscoverGenreItemCell* genreItemCell = (DiscoverGenreItemCell*)[tableView dequeueReusableCellWithIdentifier:genreCellId];
        if (!genreItemCell) {
            genreItemCell = [Utilities loadView:[DiscoverGenreItemCell class] FromNib:@"DiscoverGenreItemCell"];
        }
        [genreItemCell setDelegate:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Genre* genre = nil;
        NSString* title = @"";
        int tag = 0;
        if (indexPath.row == shortfilm) {
            genre = [arrGenres objectAtIndex:0];
            title = @"Phim ngắn";
            tag = 0;
        }else if(indexPath.row == tvshow){
            genre = [arrGenres objectAtIndex:1];
            title = @"TV Show";
            tag = 1;
        }else if(indexPath.row == relax){
            genre = [arrGenres objectAtIndex:2];
            title = @"Giải Trí";
            tag = 2;
        }
        if (!genre) {
            [genreItemCell setTitle:title andTag:tag];
        }else{
            [genreItemCell setGenre:genre];
        }
        return genreItemCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {};

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void) initTagsView{
    if (tagsContent.subviews.count > 0) {
        for (UIView* v in tagsContent.subviews) {
            if (v.tag != 1000 && v.tag != 1001) {
                [v removeFromSuperview];
            }
        }
    }
    
    if (arrTopKeys.count > 0) {
        int col = 3;
        int row = 2;
        float dX = 15;
        float dY = 15;
        float width = tagsContent.frame.size.width;
        float height = tagsContent.frame.size.height;
        float W = (width - dX * (col + 1)) / col;
        float H = (height - dY * (row - 1)) / row;
        int index = 0;
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(dX * (j + 1) + W * j, dY * i + H * i, W, H)];
                [btn.layer setBorderColor:[UIColorFromRGB(0x00adef) CGColor]];
                [btn.layer setBorderWidth:1.0f];
                [btn.layer setCornerRadius:5.0f];
                [btn setClipsToBounds:YES];
                [btn.titleLabel setFont:[UIFont fontWithName:kFontRegular size:15.0]];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [btn setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
                [btn setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
                index = i * col + j;
                [btn setTag:index];
                [btn addTarget:self action:@selector(doSelectWithKey:) forControlEvents:UIControlEventTouchUpInside];
                TopKeyword* keyword = [arrTopKeys objectAtIndex:index];
                [btn setTitle:keyword.title forState:UIControlStateNormal];
                btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
                [tagsContent addSubview:btn];
            }
        }
        [loadingTopKeys stopAnimating];
    }
}

- (int) getRowsGenreWithType:(int) type{
    Genre* genre;
    if (type == shortfilm) {
        genre = [arrGenres objectAtIndex:0];
    }else if(type == tvshow){
        genre = [arrGenres objectAtIndex:1];
    }else if(type == relax){
        genre = [arrGenres objectAtIndex:2];
    }
    int countItems = (int)genre.childGenres.count;
    int rows = countItems / 3;
    if (countItems % 3 > 0) {
        rows ++;
    }
    return rows;
}

#pragma mark - Action

- (void) doSelectWithKey:(id) sender{
    [self trackEvent:@"iOS_top_keywords"];
    UIButton* btn = sender;
    TopKeyword* topKey = [arrTopKeys objectAtIndex:btn.tag];
    if ([topKey.type isEqualToString:@"channel"]) {
        Channel* channel = [[Channel alloc] init];
        channel.channelId = topKey.itemkey;
        [APPDELEGATE didSelectChannelCellWith:channel isPush:NO];
    }else if([topKey.type isEqualToString:@"video"]){
        Video* video = [[Video alloc] init];
        video.video_id = topKey.itemkey;
        [APPDELEGATE didSelectVideoCellWith:video];
    }else if([topKey.type isEqualToString:@"artist"]){
        Artist* artist = [[Artist alloc] init];
        artist.artistId = [topKey.itemkey intValue];
        [APPDELEGATE didSelectArtistCellWith:artist];
    }
}

- (void)didSelectGenre:(Genre*)parentGenre listGenres:(NSArray*)listGenres index:(NSInteger)index{
    
    [APPDELEGATE didSelectGenre:parentGenre listGenres:listGenres index:index];
}

- (IBAction)btnGenreAction:(id)sender {
    [self enableButton:NO];
    UIButton *btn = (UIButton*)sender;
    Genre *genre = [[Genre alloc]init];
    [Utilities setTypeGenre:NEW_TYPE];
    switch (btn.tag) {
        case 0:
            genre.genreId = ID_GENRE_PHIMNGAN;
            genre.genreName = kGENRE_SHORT_FILM;
            [self trackScreen:@"iOS.Shortfilm"];
            break;
        case 1:
            genre.genreId =ID_GENRE_TVSHOW;
            genre.genreName = kGENRE_TV_SHOW;
            [self trackScreen:@"iOS.TVShow"];
            break;
        case 2:
            genre.genreId =ID_GENRE_GIAITRI;
            genre.genreName = kGENRE_RELAX;
            [self trackScreen:@"iOS.Relax"];
            break;
        default:
            break;
    }
    [APPDELEGATE didSelectGenre:genre listGenres:nil index:0];
}


#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    GenreController *searchVC = [[GenreController alloc]initWithNibName:@"GenreController" bundle:nil];
    searchVC.isSearch = YES;
    searchVC.listSearch = [[NSMutableArray alloc]initWithArray:@[@"Video",@"Kênh",@"Nghệ sĩ"]];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    GenreController *searchVC = [[GenreController alloc]initWithNibName:@"GenreController" bundle:nil];
    searchVC.isSearch = YES;
    searchVC.listSearch = [[NSMutableArray alloc]initWithArray:@[@"Video",@"Kênh",@"Nghệ sĩ"]];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [txfSearchField resignFirstResponder];
}

#pragma mark - UIScrollView Delegate
- (void)showTitleVC {
    self.navigationItem.titleView = nil;
    //    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    //    title.text = @"Trang chủ";
    //    title.font = [UIFont boldSystemFontOfSize:17];
    //    title.textAlignment = NSTextAlignmentCenter;
    //    self.navigationItem.titleView = title;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        if (isUp) {
            isUp = !isUp;
            [self doAnimation:isUp];
        }
    }else if(scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 50){
        if (!isUp) {
            isUp = !isUp;
            if (!titleView) {
                titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width - Padding, 36)];
                titleView.backgroundColor = [UIColor clearColor];
                
                if (!txfSearchField) {
                    txfSearchField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width - Padding - 30, 3,30, 30)];
                    txfSearchField.backgroundColor = RGBA(171, 174, 174, 0.15);
                    txfSearchField.textColor = UIColorFromRGB(0x212121);
                    txfSearchField.tintColor = UIColorFromRGB(0x212121);
                    txfSearchField.placeholder = @"Tìm kiếm";
                    txfSearchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tìm kiếm"
                                                                                    attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xa4a4a4), NSFontAttributeName : [UIFont fontWithName:kFontRegular size:15.0]
                                                                                                 }
                                                     ];
                    txfSearchField.clipsToBounds = YES;
                    txfSearchField.layer.cornerRadius = 5;
                    UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-search-thumb-v2"]];
                    [leftView setFrame:CGRectMake(0, 0, 35, 35)];
                    leftView.contentMode = UIViewContentModeCenter;
                    txfSearchField.leftView = leftView;
                    txfSearchField.leftViewMode = UITextFieldViewModeAlways;
                    txfSearchField.delegate = self;
                    [titleView addSubview:txfSearchField];
                }
                self.navigationItem.titleView = titleView;
                
            }
            [self doAnimation:isUp];
        }
    }

}

- (void) doAnimation:(BOOL) is_up{
    if (is_up) {
        [UIView animateWithDuration:0.05 animations:^{
            rightBarBtn.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.4 animations:^{
                txfSearchField.backgroundColor = RGBA(171, 174, 174, 0.15);
                txfSearchField.frame = CGRectMake(0, 3, SCREEN_SIZE.width - Padding, 30);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        if (titleView && txfSearchField) {
            
            [UIView animateWithDuration:0.4 animations:^{
                txfSearchField.backgroundColor = [UIColor clearColor];
                txfSearchField.frame = CGRectMake(SCREEN_SIZE.width - Padding - 30, 3, 30, 30);
                //                txfSearchField.leftView.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                txfSearchField.backgroundColor = [UIColor clearColor];
                [UIView animateWithDuration:0.05 animations:^{
                    rightBarBtn.alpha = 1.0;
                    txfSearchField.leftView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    titleView = nil;
                    txfSearchField = nil;
                    self.navigationItem.titleView = nil;
                }];
            }];
        }
    }
}

- (void)refreshData {
    [self getDiscoveryData];
    [refreshControl endRefreshing];
}

@end
