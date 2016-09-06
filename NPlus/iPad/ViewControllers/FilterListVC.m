//
//  CategoryListVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/11/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "FilterListVC.h"

//static NSArray* segments = nil;

@interface FilterListVC ()
@end

//#define ALLOW_3G        @"Cho phép dùng 3G để tải"
//#define RECEIVE_NOTI    @"Nhận thông báo"
//#define DES_NOTI        @"Bạn sẽ nhận được thông báo cập nhật các chương trình, phim yêu thích phù hợp với sở thích của mình"
//#define SHARE_APP       @"Chia sẻ ứng dụng"
//#define RATE_APP        @"Đánh giá ứng dụng"
//#define GOPY            @"Góp Ý"
//#define APP_LIEN_QUAN   @"Ứng dụng liên quan"
//#define LOGOUT          @"Đăng xuất"
//#define LOGIN           @"Đăng nhập"
//
//#define WIDTH_SEG 200
//#define HEIGHT_SEG 30

@implementation FilterListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    [self.view setBackgroundColor:[UIColor clearColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes: @{UITextAttributeFont: [UIFont fontWithName:kFontSemibold size:18.0f]}];
    _tbMain.backgroundColor = [UIColor clearColor];
    [_tbMain setAlpha:0.5];
    [_tbMain setFrame:CGRectMake(0, 0, 100, 88)];
    listItems = @[NEW_TYPE, HOT_TYPE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
//    [self.navigationItem setTitle:@"Thể loại"];
    [_tbMain reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Init UI

//- (void) initSegment{
//    segments = [NSArray arrayWithObjects:
//                [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"Mới", @"Hot", nil], @"titles", [NSValue valueWithCGSize:CGSizeMake(WIDTH_SEG/2, HEIGHT_SEG)], @"size", @"border-tab-menu.png", @"button-image", @"border-tab-menu-press.png", @"button-highlight-image", @"line2.png", @"divider-image", [NSNumber numberWithFloat:14.0], @"cap-width", nil], nil];
//    
//    NSDictionary* segmentData = [segments objectAtIndex:0];
//    NSArray* segmentTitles = [segmentData objectForKey:@"titles"];
//    segment = [[CustomSegmentedControl alloc] initWithSegmentCount:segmentTitles.count segmentsize:[[segmentData objectForKey:@"size"] CGSizeValue] dividerImage:[UIImage imageNamed:[segmentData objectForKey:@"divider-image"]] tag:TAG_VALUE + 0 delegate:self];
//    [self addView:segment itemscount:2];
//}
//
//- (void) setSelectForSegment{
//    NSMutableArray* buttons = segment.buttons;
//    if ([_mDataType isEqualToString:NEW_TYPE]) {
//        UIButton* btn = [buttons objectAtIndex:0];
//        if (!btn.selected) {
//            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
//        }
//    }else{
//        UIButton* btn = [buttons objectAtIndex:1];
//        if (!btn.selected) {
//            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
//        }
//    }
//}

//#pragma mark Load Data
//
//- (void)loadDataWithGenreId:(NSString*) gId{
//    if (!_pGenreId) {
//        _pGenreId = gId;
//    }
//    [self.dataSources removeAllObjects];
//    [[APIController sharedInstance] getListGenresWithParentId:gId completed:^(int code ,NSArray *results) {
//        if (results) {
//            NSArray *array = results;
////            Genre* genreAll = [[Genre alloc] init];
////            genreAll.genreName = @"Toàn bộ";
////            genreAll.genreId = gId;
////            genreAll.childGenres = nil;
////            [self.dataSources addObject:genreAll];
//            [self.dataSources addObjectsFromArray:array];
//            [_tbMain reloadData];
//        }
//    } failed:^(NSError *error) {
//    }];
//
//}

#pragma mark TableView Delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([_tbMain respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tbMain setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tbMain respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tbMain setLayoutMargins:UIEdgeInsetsZero];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.0f;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return headerView;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIImage* imgCheck = [UIImage imageNamed:@"icon-checked"];
        UIImageView* checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, imgCheck.size.width, imgCheck.size.height)];
        [checkImageView setImage:imgCheck];
        [checkImageView setTag:1000];
        [cell addSubview:checkImageView];
    }
    
    if (indexPath.row < listItems.count) {
        NSString* str = [listItems objectAtIndex:indexPath.row];
        [cell.textLabel setText:[str isEqualToString:NEW_TYPE] ? @"Mới" : @"Hot"];
        if ([_filterSelecting isEqualToString:str]) {
            [cell.textLabel setTextColor:UIColorFromRGB(0x00adef)];
        }else{
            [cell.textLabel setTextColor:UIColorFromRGB(0xfcfcfc)];
        }
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.textLabel.font = [UIFont fontWithName:kFontRegular size:15.0f];
    }
//    UIImageView* checkImageView = [cell viewWithTag:1000];
//    if (self.dataSources.count > indexPath.row) {
//        Genre* genre = [self.dataSources objectAtIndex:indexPath.row];
//        [checkImageView setHidden:![genre.genreId isEqualToString:_pGenreId]];
//        cell.textLabel.text = genre.genreName;
//        cell.textLabel.font = [UIFont fontWithName:kFontRegular size:15.0f];
//        cell.textLabel.textColor = RGB(0, 0, 0);
//        if (genre.childGenres.count == 0 || !genre.childGenres) {
//            [checkImageView setFrame:CGRectMake(280, 10, checkImageView.frame.size.width, checkImageView.frame.size.height)];
//            cell.accessoryType= UITableViewCellAccessoryNone;
//        }else{
//            [checkImageView setFrame:CGRectMake(260, 10, checkImageView.frame.size.width, checkImageView.frame.size.height)];
//            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
//        }
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < listItems.count) {
        NSString* str = [listItems objectAtIndex:indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(showNewOrHot:withFilter:)]) {
            [self.delegate showNewOrHot:NO withFilter:str];
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}



//- (void) selectGenreFromSubListGenre:(NSString*) subGenreId withGenreTitle:(NSString*) title{
//    _sGenreId = subGenreId;
//    _pGenreId = genreTemp;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(showListGenres:withGenreId:withGenreTitle:)]) {
//        [self.delegate showListGenres:NO withGenreId:_sGenreId withGenreTitle:title];
//    }
//
//}

@end
