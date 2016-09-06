//
//  VideoDetailVC_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 2/22/16.
//  Copyright © 2016 thienvc. All rights reserved.
//

#import "ChannelInfoDetailVC_iPad.h"
#import "Util.h"
#import "Artist.h"
#import "ArtistSuggestItemCell.h"
#import "CustomTagsView.h"
#import "Constant.h"
#import <math.h>
#import "ShareTask.h"
#import "Utilities.h"

#define NUM_COLUMS_ARTIST 2
#define GRIDVIEW_HEIGH 149

@interface ChannelInfoDetailVC_iPad (){
    float heightDesInfo;
    float heightArtistInfo;
    BOOL isExpanded;
    CustomTagsView* tagView;
    
    int numCells;
}
@end

@implementation ChannelInfoDetailVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isExpanded = NO;
    [gridView setScrollEnabled:NO];
    [gridView setUiGridViewDelegate:self];
    UIView* view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    [myTableView setTableFooterView:view];
    _listArtists = [[NSMutableArray alloc] init];
    [self initUI];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kDidLogoutNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI{
    
    // title view
    [cLbTitle setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [sLbTitle setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
//    [cLbTitleLuotXem setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [sLbTitleLuotXem setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [cLbLuotXem setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    [sLbLuotXem setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
    
    [cBtnFollow.layer setCornerRadius:5.0f];
    [cBtnFollow setClipsToBounds:YES];
    [cBtnFollow.layer setBorderColor:[UIColorFromRGB(0x00adef) CGColor]];
    [cBtnFollow.layer setBorderWidth:1.0f];
    [cBtnFollow.titleLabel setTextColor:UIColorFromRGB(0x00adef)];
    
    // rating view
    [lbBroadcast setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [lbDirector setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [lbProducer setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    
    [lbRating setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
    [lbFollow setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
    
    [lbUsersRating setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbTitleBroadcast setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [lbTitleDirector setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [lbTitleProducer setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    
    [lbTitleRating setFont:[UIFont fontWithName:kFontSemibold size:16.0f]];
    [lbTitleFollow setFont:[UIFont fontWithName:kFontSemibold size:16.0f]];
    // artist view
    [lbTitleArtist setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Load Data
- (void) loadDataWithChannel:(Channel*) channel{
    self.mChannel = channel;
    if (self.listArtists.count > 0) {
        [self.listArtists removeAllObjects];
    }
    [self.listArtists addObject:self.mChannel.artists];
    self.mVideo = nil;
//    [myTableView setContentOffset:CGPointZero animated:NO];
    [myTableView setContentOffset:CGPointZero];
    [myTableView reloadData];
}

- (void) loadDataWithSeason:(Season*) season andVideo:(Video*) video{
    self.mChannel = season.channel;
    self.mVideo = video;
    [myTableView setContentOffset:CGPointZero];
    [myTableView reloadData];
}

- (void) setContentTitleView{
    if (self.mVideo) {
        [sLbTitle setText:[self stringForTitleSeason]];
        float height = [Util heightForContent:sLbTitle.text withFont:sLbTitle.font andWidth:sLbTitle.frame.size.width];
        [sLbTitle setFrame:CGRectMake(sLbTitle.frame.origin.x, sLbTitle.frame.origin.y, sLbTitle.frame.size.width, height)];
        [sBtnShare setFrame:CGRectMake(sBtnShare.frame.origin.x, sLbTitle.frame.origin.y + sLbTitle.frame.size.height + 10, sBtnShare.frame.size.width, sBtnShare.frame.size.height)];
        [sBtnFollow setFrame:CGRectMake(sBtnFollow.frame.origin.x, sLbTitle.frame.origin.y + sLbTitle.frame.size.height + 10, sBtnFollow.frame.size.width, sBtnFollow.frame.size.height)];
        [sBtnRate setFrame:CGRectMake(sBtnRate.frame.origin.x, sLbTitle.frame.origin.y + sLbTitle.frame.size.height + 10, sBtnRate.frame.size.width, sBtnRate.frame.size.height)];
        [sLbLuotXem setText:[NSString stringWithFormat:@"%d", self.mVideo.viewCount]];
        if (self.mChannel.isSubcribe) {
            [sBtnFollow setImage:[UIImage imageNamed:@"btn-theodoi-hover"] forState:UIControlStateNormal];
        }else{
            [sBtnFollow setImage:[UIImage imageNamed:@"btn-theodoi"] forState:UIControlStateNormal];
        }
    }else{
        [cLbTitle setText:self.mChannel.channelName];
        [cLbLuotXem setText:[Utilities convertToStringFromCount:self.mChannel.view]];
        if (self.mChannel.isSubcribe) {
            [cBtnFollow.layer setBorderColor:[[UIColor redColor] CGColor]];
            [cBtnFollow.titleLabel setTextColor:[UIColor redColor]];
            [cBtnFollow setTitle:@"Đã theo dõi" forState:UIControlStateNormal];
        }else{
            [cBtnFollow.layer setBorderColor:[UIColorFromRGB(0x00adef) CGColor]];
            [cBtnFollow.titleLabel setTextColor:UIColorFromRGB(0x00adef)];
            [cBtnFollow setTitle:@"Theo dõi" forState:UIControlStateNormal];
        }
    }

}

- (NSString*) stringForTitleSeason{
    NSString* str = [NSString stringWithFormat:@"%@: %@",self.mChannel.channelName, self.mVideo.video_subtitle];
    return str;
}

- (void)setUILabelTextWithVerticalAlignTopWithLabel:(UILabel*) label{
    // set number line = 0 to show full text
    CGSize theStringSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    float X = label.frame.origin.x;
    float width = label.frame.size.width;
    label.frame = CGRectMake(X, label.frame.origin.y, width, theStringSize.height);
}

- (void) setContentTagsView{
    if (!tagView) {
        tagView = [[CustomTagsView alloc] initWithData:self.mChannel.genres];
    }else{
        [tagView resetWithArray:self.mChannel.genres];
    }
    
}

- (void) setcontentArtistView{
    [artistView setFrame:CGRectMake(0, 0, artistView.frame.size.width, heightArtistInfo)];
    [gridView setFrame:CGRectMake(0, 50, gridView.frame.size.width, heightArtistInfo - 50)];
//    NSLog(@"%@", NSStringFromCGRect(gridView.frame));
    if (self.mChannel.artists.count > 0) {
        [gridView reloadData];
    }
}

- (void) setContentRateView{
    [lbBroadcast setText:self.mChannel.broadcast];
    [lbDirector setText:self.mChannel.director];
    [lbProducer setText:self.mChannel.producer];
    [lbRating.layer setCornerRadius:5.0f];
    lbRating.clipsToBounds = YES;
    
    
    [lbRating setText:[NSString stringWithFormat:@"%0.1f", self.mChannel.rating]];
//    [lbUsersRating setText:[NSString stringWithFormat:@"(%d)", self.mChannel.totalUserRating]];
    for (UIView* star in starView.subviews) {
        [star removeFromSuperview];
    }
    
    float rating = roundf(self.mChannel.rating * 10.0);
    int fullStar = (int) rating/10;
    int halfStar = fullStar;
    if ((rating - fullStar*10) < 8 && (rating - fullStar*10) > 2) {
        halfStar += 1;
    }else if((rating - fullStar*10) >= 8){
        fullStar += 1;
    }
    int X = 3, Y = 1;
    int dX = 5;
    int W = 30, H = 30;
    for (int i = 0; i < 5; i++) {
        UIImageView* imgStar;
        if (i < fullStar) {
            imgStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-star1"]];
        }else if( i < halfStar){
            imgStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-star2"]];
        }else{
            imgStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-star3"]];
        }
        
        [imgStar setFrame:CGRectMake(X + (dX + W) * i, Y, W, H)];
        [starView addSubview:imgStar];
    }
}

#pragma mark - TableView Delegate

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
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (!self.mChannel.artists || self.mChannel.artists.count == 0) ? 4 : 5;
//    return 5;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([self.type isEqualToString:CHANNEL_TYPE]) {
            return titleViewChannel.frame.size.height;
        }else{
            if (sLbTitle.frame.size.height < 29.0) {
                return sLbTitle.frame.size.height + sBtnShare.frame.size.height + 35;
            }
            return titleViewSeason.frame.size.height;
        }
    }else if(indexPath.row == 1){
        heightDesInfo = [Util heightForCellWithContent:self.mChannel.channelDes withFont:[UIFont fontWithName:kFontRegular size:15.0f]] + 37;
        if (!isExpanded) {
            heightDesInfo = heightDesInfo > 123 ? 123 : heightDesInfo;
        }
        return heightDesInfo;
    }else if (indexPath.row == 2){
//        [self setContentRateView];
        return rateView.frame.size.height;
    }else if (indexPath.row == 3){
        [self setContentTagsView];
        return tagView.frame.size.height;
    }
    else if (indexPath.row == 4){
        
        if (!self.mChannel.artists || self.mChannel.artists.count == 0) {
            heightArtistInfo = 0;
            return 318;
        }else{
            int rows = (int)self.mChannel.artists.count/NUM_COLUMS_ARTIST;
            if (rows * NUM_COLUMS_ARTIST < self.mChannel.artists.count) {
                rows ++;
            }
//            NSLog(@"grid view: %@", NSStringFromCGRect(gridView.frame));
            heightArtistInfo = gridView.frame.origin.y + GRIDVIEW_HEIGH * rows;
        }
        return heightArtistInfo;
    }
    return 318;
}

#pragma mark - Custom Cell

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self tableView:tableView titleCellForRowAtIndexPath:indexPath];
    }else if (indexPath.row == 1){
        return [self tableView:tableView cellDesAtIndexPath:indexPath];
    }else if(indexPath.row == 2){
        return [self tableView:tableView rateCellForRowAtIndexPath:indexPath];
    }else if(indexPath.row == 3){
        return [self tableView:tableView tagCellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 4){
        if (heightArtistInfo == 0) {
            return [self tableView:tableView commentCellForRowAtIndexPath:indexPath];
//            NSLog(@"aaaa");
        }else{
            return [self tableView:tableView artistCellForRowAtIndexPath:indexPath];
        }
    }
    return [self tableView:tableView commentCellForRowAtIndexPath:indexPath];
    
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
}

- (DescriptionItemCell*)tableView:(UITableView*)tableView cellDesAtIndexPath:(NSIndexPath*)indexPath {
    DescriptionItemCell *cell = (DescriptionItemCell*)[tableView dequeueReusableCellWithIdentifier:@"descriptionItemCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DescriptionItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setContent:self.mChannel.channelDes];
    if (!isExpanded) {
        cell.tvDesc.frame = cell.tvDesc.bounds;
        [cell.contentView layoutIfNeeded] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView titleCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellForTitleView"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellForTitleView"];
        if ([self.type isEqualToString:CHANNEL_TYPE]) {
            [cell addSubview:titleViewChannel];
        }else{
            [cell addSubview:titleViewSeason];
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    [self setContentTitleView];
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView rateCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:rateView.bounds];
    [cell addSubview:rateView];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setContentRateView];
    return cell;
}


- (UITableViewCell*)tableView:(UITableView *)tableView tagCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:tagView.bounds];
    [cell addSubview:tagView];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView artistCellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:artistView.bounds];
//    [cell addSubview:artistView];
//    cell.backgroundColor = [UIColor clearColor];
//    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [self setcontentArtistView];
//    return cell;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellForArtistView"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellForArtistView"];
        [cell addSubview:artistView];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    [self setcontentArtistView];
    return cell;
}

- (CommentItemCell*)tableView:(UITableView*)tableView commentCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    CommentItemCell *cell = (CommentItemCell*)[tableView dequeueReusableCellWithIdentifier:@"commentItemCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - GridView Delegate

- (NSInteger) numberOfSectionsInGridView:(UIGridView *)grid{
    return self.listArtists.count;
}

- (NSInteger) gridView:(UIGridView *)grid numberOfRowsInSection:(NSInteger)section{
    if (self.listArtists.count > section) {
        return [[self.listArtists objectAtIndex:section] count];
        
    }
    return 0;
}

- (CGFloat) gridView:(UIGridView *)grid heightForHeaderInSection:(int) section{
    return 0;
}


- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return 140;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    return 144;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return NUM_COLUMS_ARTIST;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
//    NSLog(@"%d", (int)self.mChannel.artists.count);
    return self.mChannel.artists.count;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex andSection:(int) section
{
    ArtistSuggestItemCell *cell = (ArtistSuggestItemCell *)[grid dequeueReusableCell:@"artistSuggestItemCell"];
    if (cell == nil) {
        cell = [[ArtistSuggestItemCell alloc] init];
    }
    int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
    NSMutableArray* arr = [_listArtists objectAtIndex:section];
    if (arr.count > index) {
        id item = [arr objectAtIndex:index];
        if ([item isKindOfClass:[Artist class]]) {
            Artist* artist = (Artist*)item;
            [cell setContentArtist:artist];
        }
    }
    return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex andSection:(int)section
{
    int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + colIndex;
    NSMutableArray* arr = [_listArtists objectAtIndex:section];
    if (arr.count > index) {
        id item = [arr objectAtIndex:index];
        if([item isKindOfClass:[Artist class]]){
            if (self.delegate && [self.delegate respondsToSelector:@selector(showArtist:)]) {
                [self.delegate showArtist:item];
            }
        }
    }

}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}


#pragma mark - TitleView Action

- (IBAction) doFollow:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginWithTask:withVC:)]) {
        [self.delegate showLoginWithTask:kTaskFolow withVC:self];
    }
}
//
- (IBAction) doRate:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginWithTask:withVC:)]) {
        [self.delegate showLoginWithTask:kTaskRating withVC:self];
    }
}

- (IBAction) doShare:(id)sender{
    if (!actionVC) {
        actionVC = [[ActionVC alloc] initWithNibName:@"ActionVC" bundle:nil];
    }
    [actionVC setDelegate:self];
    [actionVC loadDataWithType:share_type];
    if (!actionPopover) {
        actionPopover = [[UIPopoverController alloc] initWithContentViewController:actionVC];
    }
    [actionPopover setPopoverContentSize:CGSizeMake(134, 40 * actionVC.arrTitles.count)];
    if (self.mVideo) {
        [actionPopover presentPopoverFromRect:sBtnShare.frame inView:titleViewSeason permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }else{
        [actionPopover presentPopoverFromRect:cBtnShare.frame inView:titleViewChannel permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void) shareFacebook{
    [actionPopover dismissPopoverAnimated:YES];
    if ([self.mChannel.linkShare isEqualToString:@""]) {
        [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho kênh này." position:@"bottom" type:errorImage];
    }else{
        [[ShareTask sharedInstance] setViewController:self];
        [[ShareTask sharedInstance] shareFacebook:self.mChannel];
    }
    
}

- (void) copyLink{
    //    NSLog(@"copy link");
    [actionPopover dismissPopoverAnimated:YES];
    NSString *dataText = self.mChannel.linkShare;
    [[UIPasteboard generalPasteboard] setString:dataText];
    [APPDELEGATE showToastWithMessage:@"Đã copy link." position:@"bottom" type:doneImage];
}


- (void) doShowMore{
    [self updateTableView];
}

- (void)updateTableView
{
    isExpanded = !isExpanded;
    [myTableView beginUpdates];
    [myTableView endUpdates];
    
}

-(void)loginSuccessWithTask:(NSString *)task{
//    NSLog(@"success login");
    if ([task isEqualToString:kTaskFolow]) {
        if (!self.mChannel.isSubcribe) {
            [[APIController sharedInstance] userSubcribeChannel:self.mChannel.channelId subcribe:!self.mChannel.isSubcribe completed:^(int code, BOOL status){
                if (status) {
                    self.mChannel.isSubcribe = !self.mChannel.isSubcribe;
                    [APPDELEGATE showToastWithMessage:@"Bạn đã follow kênh thành công!" position:@"bottom" type:doneImage];
                    if (self.mVideo) { // season page
                        [sBtnFollow setImage:[UIImage imageNamed:@"btn-theodoi-hover"] forState:UIControlStateNormal];
                    }else{ // channel page
                        [cBtnFollow setImage:[UIImage imageNamed:@"btn-theodoi-hover"] forState:UIControlStateNormal];
                    }

                }else{
                    [APPDELEGATE showToastWithMessage:@"Bạn follow kênh chưa thành công!" position:@"bottom" type:errorImage];
                }
                
//                if (self.delegate && [self.delegate respondsToSelector:@selector(hideLoginView)]) {
//                    [self.delegate hideLoginView];
//                }
            } failed:^(NSError *error) {
                NSLog(@"fail");
            }];
        }else{
            [APPDELEGATE showToastWithMessage:@"Bạn đã follow kênh này rồi!" position:@"bottom" type:doneImage];
        }
    }else if([task isEqualToString:kTaskRating]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(showRatingView:)]) {
            [self.delegate showRatingView:self];
        }
    }
}

- (void) logout{
    self.mChannel.isSubcribe = NO;
    if (self.mVideo) {
        [sBtnFollow setImage:[UIImage imageNamed:@"btn-theodoi"] forState:UIControlStateNormal];
    }else{
        [cBtnFollow setImage:[UIImage imageNamed:@"btn-theodoi"] forState:UIControlStateNormal];
    }
}

- (void) doRateWithMark:(int) mark{
    [[APIController sharedInstance] ratingChannel:self.mChannel.channelId score:mark completed:^(int code, BOOL status){
        if (status) {
            [APPDELEGATE showToastWithMessage:@"Bạn đã đánh giá kênh thành công!" position:@"bottom" type:doneImage];
        }else{
            [APPDELEGATE showToastWithMessage:@"Bạn đánh giá kênh chưa thành công!" position:@"bottom" type:errorImage];
        }
    } failed:^(NSError *error) {
        NSLog(@"fail");
    }];
}

@end
