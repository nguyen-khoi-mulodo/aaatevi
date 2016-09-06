
//
//  RankVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/31/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "CategoryVC_iPad.h"
#import "Genre.h"
#import "CustomSegmentedControl.h"

#define COLUMN_NUMS 7
#define PADDING 0

static NSArray* segments = nil;

@interface CategoryVC_iPad ()

@end

@implementation CategoryVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // title
    [self.lbTitle setFont:[UIFont fontWithName:kFontRegular size:20.0f]];
    [self.lbTitle setTextColor:UIColorFromRGB(0x212121)];
    subTitle = @"";
    // content view
    [self addContentViewWithTypeScreen:_screenType];
    // header view
    [self addHeaderViewWithTypeScreen:_screenType];
    // search view
    [self addSearchView];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTitleForView];

}

#pragma mark Init UI


- (void) addSearchView{
    _txtSearch.layer.cornerRadius = 10.0f;
//    _txtSearch.backgroundColor = RGB(8, 10, 10);
    [_txtSearch setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    UIImageView *iconSearch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 18)];
    [iconSearch setImage:[UIImage imageNamed:@"search_icon_khungsearch"]];
    [_txtSearch setLeftView:iconSearch];
    [_txtSearch setTextColor:[UIColor colorWithWhite:1.0f alpha:0.8f]];
//    UIColor *color = [UIColor lightGrayColor];
    UIColor *color = UIColorFromRGB(0x212121);
    _txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tìm kiếm" attributes:@{NSForegroundColorAttributeName: color}];
    [_txtSearch setLeftViewMode:UITextFieldViewModeAlways];
    [_txtSearch setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
}


- (void) addHeaderViewWithTypeScreen:(MainScreenType) type{
    [self.headerView setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
    [self.menuView setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
    if (type == home_type || type == download_type) {
        [self.menuView setHidden:YES];
    }else{
        [self.menuView setHidden:NO];
        btnGenreCurrent = _btnAll;
        [_btnAll.titleLabel setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
        [_genreScrollView setShowsVerticalScrollIndicator:NO];
        [_genreScrollView setShowsHorizontalScrollIndicator:NO];
        [self loadDataWithGenreId:contentVC.genreID];
    }
    
    [self.lbTitle setFont:[UIFont fontWithName:kFontRegular size:20.0f]];
    [self.lbTitle setTextColor:UIColorFromRGB(0x212121)];
}

#pragma mark Load Data

- (void)loadDataWithGenreId:(NSString*) gId{
    if (!listGenres) {
        listGenres = [[NSMutableArray alloc] init];
    }
    [listGenres removeAllObjects];
    [[APIController sharedInstance] getListGenresWithParentId:gId completed:^(int code ,NSArray *results) {
        if (results) {
            NSArray *array = results;
            [listGenres addObjectsFromArray:array];
            [self addListGenres];
        }
    } failed:^(NSError *error) {
    }];
    
}


- (void) addListGenres{
    Genre* genreAll = [listGenres objectAtIndex:0];
    [_btnAll setTitle:genreAll.genreName forState:UIControlStateNormal];
    [_btnAll setTitle:genreAll.genreName forState:UIControlStateSelected];
    
    float H = 30;
    float Y = 5;
    float X = 0;
//    NSArray* arrTitle = @[@"Âm nhạc", @"Thời sự", @"Sitcom", @"Hài hước", @"Tâm lý tình cảm", @"Thiếu nhi", @"Âm nhạc", @"Thời sự", @"Sitcom", @"Hài hước", @"Tâm lý tình cảm", @"Thiếu nhi"];
    
    float contentWidth = 0;
    for (int i = 1; i < listGenres.count; i ++)
    {
        NSString* strTitle = [[listGenres objectAtIndex:i] genreName];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:kFontRegular size:14.0f]};
        CGSize size = [strTitle sizeWithAttributes:attributes];
        float W = size.width + 24;
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(X, Y, W, H)];
        X += W;
        [btn setTitle:strTitle forState:UIControlStateNormal];
        
        [btn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateHighlighted];
        [btn setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateSelected];
        [btn setTag:i];
        [btn.titleLabel setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
        [btn addTarget:self action:@selector(genreMenuSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_genreScrollView addSubview:btn];
        contentWidth += W;
    }
    
    if (contentWidth > _genreScrollView.frame.size.width) {
        [_genreScrollView setContentSize:CGSizeMake(contentWidth, H)];
    }
}


- (IBAction) genreMenuSelected:(id) sender{
    UIButton* btn = (UIButton*)sender;
    if (btn == _btnAll) {
        [_genreScrollView setContentOffset:CGPointZero animated:YES];
        
    }
    [btnGenreCurrent setSelected:NO];
    [self goToMenuSelect:btn];
}

- (void) goToMenuSelect:(UIButton*) btnMenu
{
    
    [UIView animateWithDuration:0.15f delay:0 options: UIViewAnimationOptionCurveEaseIn  animations:^
     {
         if (btnMenu == _btnAll) {
            [_vIndicator setCenter:CGPointMake(btnMenu.center.x, _vIndicator.center.y)];
         }else{
             if ([_genreScrollView.subviews containsObject:_vIndicator]) {
                 [_vIndicator setFrame:CGRectMake(btnMenu.frame.origin.x, _vIndicator.frame.origin.y, btnMenu.frame.size.width, _vIndicator.frame.size.height)];
             }else{
                 [_vIndicator setFrame:CGRectMake(btnMenu.frame.origin.x - _genreScrollView.contentOffset.x + _btnAll.frame.size.width, _vIndicator.frame.origin.y, btnMenu.frame.size.width, _vIndicator.frame.size.height)];
             }
         }
         
     } completion:^(BOOL finished)
     {
         [btnMenu setSelected:YES];
         if (btnMenu == _btnAll) {
             [_vIndicator removeFromSuperview];
             [_menuView addSubview:_vIndicator];
         }else{
             if ([_genreScrollView.subviews containsObject:_vIndicator]) {
                 [_vIndicator setFrame:CGRectMake(btnMenu.frame.origin.x, _vIndicator.frame.origin.y, btnMenu.frame.size.width, _vIndicator.frame.size.height)];
             }else{
                 [_vIndicator removeFromSuperview];
                 [_vIndicator setFrame:CGRectMake(btnMenu.frame.origin.x, _vIndicator.frame.origin.y, btnMenu.frame.size.width, _vIndicator.frame.size.height)];
                 [_genreScrollView addSubview:_vIndicator];

             }
         }
         btnGenreCurrent = btnMenu;
         NSString* genreId = [[listGenres objectAtIndex:btnGenreCurrent.tag] genreId];
         [contentVC setFilterType:contentVC.filterStr andGenreId:genreId];
     }];
}

- (void) addContentViewWithTypeScreen:(MainScreenType) type{
    
    // content view
    if (!contentVC) {
        contentVC = [[GridListItemsVC alloc] initWithNibName:@"GridListItemsVC" bundle:nil];
    }
    [contentVC setDelegate:self];
    [contentVC setScreenType:type];
    
    if (type == home_type) {
        [contentVC.view setFrame:CGRectMake(PADDING, self.headerView.frame.origin.y + self.headerView.frame.size.height + PADDING, SCREEN_WIDTH - 2 * PADDING, SCREEN_HEIGHT - self.headerView.frame.origin.y - self.headerView.frame.size.height - PADDING)];
    }else{
//        if (!self.menuView.hidden) {
//            [contentVC.view setFrame:CGRectMake(PADDING, self.headerView.frame.origin.y + self.headerView.frame.size.height + PADDING + self.menuView.frame.size.height, SCREEN_WIDTH - 2 * PADDING, SCREEN_HEIGHT - self.headerView.frame.origin.y - self.headerView.frame.size.height - PADDING - self.menuView.frame.size.height)];
//        }else{
//            [contentVC.view setFrame:CGRectMake(PADDING, self.headerView.frame.origin.y + self.headerView.frame.size.height + PADDING, SCREEN_WIDTH - 2 * PADDING, SCREEN_HEIGHT - self.headerView.frame.origin.y - self.headerView.frame.size.height - PADDING)];
//        }
        [contentVC.view setFrame:CGRectMake(PADDING, self.headerView.frame.origin.y + self.headerView.frame.size.height + PADDING + self.menuView.frame.size.height, SCREEN_WIDTH - 2 * PADDING, SCREEN_HEIGHT - self.headerView.frame.origin.y - self.headerView.frame.size.height - PADDING - self.menuView.frame.size.height)];
    }
    [self.view insertSubview:contentVC.view belowSubview:self.line];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark CustomSegmentedControlDelegate
//- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
//{
//    NSUInteger dataOffset = segmentedControl.tag - TAG_VALUE ;
//    NSDictionary* data = [segments objectAtIndex:dataOffset];
//    NSArray* titles = [data objectForKey:@"titles"];
//    
//    CapLocation location;
//    if (segmentIndex == 0)
//        location = CapLeft;
//    else if (segmentIndex == titles.count - 1)
//        location = CapRight;
//    else
//        location = CapMiddle;
//    
//    UIImage* buttonImage = nil;
//    UIImage* buttonPressedImage = nil;
//    
//    CGFloat capWidth = [[data objectForKey:@"cap-width"] floatValue];
//    CGSize buttonSize = [[data objectForKey:@"size"] CGSizeValue];
//    
//    if (location == CapLeftAndRight)
//    {
//        buttonImage = [[UIImage imageNamed:[data objectForKey:@"button-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
//        buttonPressedImage = [[UIImage imageNamed:[data objectForKey:@"button-highlight-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
//    }
//    else
//    {
//        buttonImage = [self image:[[UIImage imageNamed:[data objectForKey:@"button-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:location capWidth:capWidth buttonWidth:buttonSize.width];
//        buttonPressedImage = [self image:[[UIImage imageNamed:[data objectForKey:@"button-highlight-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:location capWidth:capWidth buttonWidth:buttonSize.width];
//    }
//    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0.0, 0.0, buttonSize.width, buttonSize.height);
//    [button setTitle:[titles objectAtIndex:segmentIndex] forState:UIControlStateNormal];
//    [button setTitleColor:kSelectedColor forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [button.titleLabel setFont:[UIFont fontWithName:kFontRegular size:16.0]];
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
//    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
//    button.adjustsImageWhenHighlighted = NO;
//    [button.titleLabel setTextColor:[UIColor blackColor]];
//    if (segmentIndex == 0)
//        button.selected = YES;
//    return button;
//}
//
//- (void) touchUpInsideSegmentIndex:(NSUInteger)segmentIndex{
//    [self setListTypeWithSegmentIndex:(int) segmentIndex];
//}
//
//-(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
//{
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
//    
//    if (location == CapLeft)
//        // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
//        [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
//    else if (location == CapRight)
//        // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
//        [image drawInRect:CGRectMake(0.0 - capWidth, 0, buttonWidth + capWidth, image.size.height)];
//    else if (location == CapMiddle)
//        // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
//        [image drawInRect:CGRectMake(0.0 - capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
//    
//    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return resultImage;
//}
//
//-(void)addView:(UIView*)subView itemscount:(int) count
//{
//    [subView setFrame:CGRectMake((self.segmentView.frame.size.width - WIDTH_SEGMENT)/2, (self.segmentView.frame.size.height - HEIGHT_INDEX_SEGMENT)/2, WIDTH_SEGMENT, HEIGHT_INDEX_SEGMENT)];
//    [self.segmentView addSubview:subView];
//}


#pragma mark Action

//-(void) setListTypeWithSegmentIndex:(int) index{
//    if (_screenType == khampha_type) {
//        if (index == 0) {
//            mListType = channel_type;
//            mDataType = NEW_TYPE;
//        }else if(index == 1){
//            mListType = video_type;
//            mDataType = RECOMMEND_TYPE;
//        }else if(index == 2){
//            mListType = video_type;
//            mDataType = NEW_TYPE;
//        }
//    }else{ // cac screen có segment còn lại
//        if (_screenType == phimngan_type || _screenType == tvshow_type || _screenType == giaitri_type) {
//            if (index == 0) {
//                mDataType = NEW_TYPE;
//            }else if(index == 1){
//                mDataType = HOT_TYPE;
//            }
//            mListType = channel_type;
//        }
//    }
//    [contentVC setListType:mListType withDataType:mDataType withGenreId:contentVC.subGenreID];
//}

- (void) showNewOrHot:(BOOL) isShow withFilter:(NSString*) filter
{
    if (isShow) {
        if (!filterListVC) {
            filterListVC = [[FilterListVC alloc] initWithNibName:@"FilterListVC" bundle:nil];
        }
        [filterListVC.view setFrame:CGRectMake(0, 0, 100, 88)];
        [filterListVC setDelegate:self];
        [filterListVC setFilterSelecting:contentVC.mDataType];
        
//        [genreListVC loadDataWithGenreId:genreId];
//        if (!genreNav) {
//            genreNav = [[UINavigationController alloc] initWithRootViewController:filterListVC];
//        }else{
//            UIViewController* topVC = (UIViewController*)genreNav.topViewController;
//            if (![topVC isKindOfClass:[FilterListVC class]]) {
//                [genreNav popToRootViewControllerAnimated:NO];
//            }
//        }
//        genreNav.edgesForExtendedLayout = UIRectEdgeNone;
//        genreNav.navigationBarHidden = YES;
        if (IOS_VERSION_LOWER_THAN_8) {
            if (!popoverVC) {
                popoverVC = [[UIPopoverController alloc] initWithContentViewController:filterListVC];
                [popoverVC setDelegate:self];
            }else{
                [popoverVC setContentViewController:filterListVC];
            }
        }else{
            popoverVC = [[UIPopoverController alloc] initWithContentViewController:filterListVC];
            [popoverVC setDelegate:self];
        }
        [popoverVC setBackgroundColor:[UIColor blackColor]];
        [popoverVC setPopoverContentSize:CGSizeMake(100, 88)];
        [popoverVC presentPopoverFromRect:CGRectMake(0, 0, 25, 30) inView:btnShowList permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }else{
        if (popoverVC != nil) {
            [popoverVC dismissPopoverAnimated:YES];
        }
        [self.lbFilter setText:[filter isEqualToString:NEW_TYPE] ? @"Mới" : @"Hot"];
        NSString* genreId = [[listGenres objectAtIndex:btnGenreCurrent.tag] genreId];
        [contentVC setFilterType:filter andGenreId:genreId];
    }
}

-(IBAction) newOrhotSelected:(id) sender{
    UIButton* btn = (UIButton*)sender;
    [self showNewOrHot:!btn.selected withFilter:contentVC.filterStr];
}


- (IBAction) doSearch:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showSearchVC)]) {
        [self.delegate showSearchVC];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showSearchVC)]) {
        [self.delegate showSearchVC];
    }
    return NO;
}

- (void) showChannelView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showChannelView)]) {
        [self.delegate showChannelView];
    }
}

- (void) setTitleForView{
    if ([subTitle isEqualToString:@""] || [subTitle isEqualToString:@"Tất cả"]) {
        switch (_screenType) {
            case home_type:
                [self setScreenName:@"iPad.Home"];
                [self.lbTitle setText:@"Trang Chủ"];
                break;
            case khampha_type:
                [self setScreenName:@"iPad.KhamPha"];
                [self.lbTitle setText:@"Khám phá"];
                break;
            case phimbo_type:
                [self setScreenName:@"iPad.PhimBo"];
                [self.lbTitle setText:@"Phim bộ"];
                break;
            case phimle_type:
                [self setScreenName:@"iPad.PhimLe"];
                [self.lbTitle setText:@"Phim lẻ"];
                break;
            case tvshow_type:
                [self setScreenName:@"iPad.TVShow"];
                [self.lbTitle setText:@"TV Show"];
                break;
            case phimngan_type:
                [self setScreenName:@"iPad.PhimNgan"];
                [self.lbTitle setText:@"Phim ngắn"];
                break;
            case giaitri_type:
                [self setScreenName:@"iPad.GiaiTri"];
                [self.lbTitle setText:@"Giải Trí"];
                break;
            case xemsau_type:
                [self setScreenName:@"iPad.XemSau"];
                [self.lbTitle setText:@"Xem Sau"];
                break;
            case download_type:
                [self setScreenName:@"iPad.Download"];
                [self.lbTitle setText:@"Tải về"];
                if (contentVC) {
                    [contentVC loadData];
                }
                break;
            default:
                break;
        }
    }else{
        switch (_screenType) {
            case tvshow_type:
                [self.lbTitle setText:[NSString stringWithFormat:@"TV Show - %@", subTitle]];
                break;
            case phimngan_type:
                [self.lbTitle setText:[NSString stringWithFormat:@"Phim ngắn - %@", subTitle]];
                break;
            case giaitri_type:
                [self.lbTitle setText:[NSString stringWithFormat:@"Giải Trí - %@", subTitle]];
                break;
            default:
                break;
        }
    }
    
}



@end
