//
//  VideoDetailVC_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 2/22/16.
//  Copyright © 2016 thienvc. All rights reserved.
//

#import "InfoDetailVC_iPad.h"
#import "Util.h"
#import "CustomTagsView.h"



@interface InfoDetailVC_iPad (){
}

@end

@implementation InfoDetailVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView* view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    [myTableView setTableFooterView:view];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI{
    [lbTitle setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbLuotXem setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Load Data

- (void) setContentTitleView{
    [lbTitle setText:[self stringForTitle]];
    if (self.mFileInfo) {
        [lbLuotXem setHidden:YES];
    }else{
        NSString* strViews = [Utilities convertToStringFromCount:self.mVideo.viewCount];
        NSString* strTime = [Utilities stringRelatedDateFromMiliseconds:self.mVideo.dateCreated/1000];
        [lbLuotXem setText:[NSString stringWithFormat:@"%@ - %@", strViews, strTime]];
        [lbLuotXem setHidden:!(self.mVideo.viewCount > 0)];
    }
    float height = [Util heightForContent:lbTitle.text withFont:lbTitle.font andWidth:lbTitle.frame.size.width];
    [lbTitle setFrame:CGRectMake(lbTitle.frame.origin.x, lbTitle.frame.origin.y, lbTitle.frame.size.width, height)];
    [luotXemView setFrame:CGRectMake(luotXemView.frame.origin.x, lbTitle.frame.origin.y + height + 8, luotXemView.frame.size.width, luotXemView.frame.size.height)];
    [actionView setFrame:CGRectMake(actionView.frame.origin.x, luotXemView.frame.origin.y, actionView.frame.size.width, actionView.frame.size.height)];
    [titleView setFrame:CGRectMake(titleView.frame.origin.x, titleView.frame.origin.y, titleView.frame.size.width, luotXemView.frame.origin.y + luotXemView.frame.size.height + 3 + line.frame.size.height)];
}

- (NSString*) stringForTitle{
    NSString* str;
    if (self.mFileInfo) {
        str = [NSString stringWithFormat:@"%@: %@", self.mVideo.video_title, self.mVideo.video_subtitle];
    }else{
        if (self.mChannel) {
            str = [NSString stringWithFormat:@"%@: %@", self.mChannel.channelName, self.mVideo.video_subtitle];
        }else{
            str = [NSString stringWithFormat:@"%@: %@", self.mVideo.video_title, self.mVideo.video_subtitle];
        }
    }
    return str;
}



- (void) loadDataWithVideo:(Video*) video{
    self.mVideo = video;
    self.mFileInfo = nil;
    Channel* channel = [self.mVideo.channels objectAtIndex:0];
    self.mChannel = channel;
    // set list video suggest
    if (!videosSuggestOfVideoVC) {
        videosSuggestOfVideoVC = [[VideoSuggestOfVideoVC alloc] initWithNibName:@"VideoSuggestOfVideoVC" bundle:nil];
        [videosSuggestOfVideoVC.view setHidden:NO];
    }
    [videosSuggestOfVideoVC setDelegate:self];
    [videosSuggestOfVideoVC loadVideosSuggestFromVideoId:self.mVideo.video_id];
    
    // set list videos of season
    if (!videosOfSeasonVC) {
        videosOfSeasonVC = [[VideosOfSeasonVC alloc] initWithNibName:@"VideosOfSeasonVC" bundle:nil];
        [videosOfSeasonVC.view setHidden:NO];
    }
    [videosOfSeasonVC setDelegate:self];
    [videosOfSeasonVC loadVideosOfSeasonFromSeasonId:self.mVideo.seasonKey];
    [myTableView reloadData];
}
- (void) loadDataWithFileInfo:(FileDownloadInfo*) fileInfo{
    self.mFileInfo = fileInfo;
    Video* video = [self.mFileInfo videoDownload];
    self.mVideo = video;
    [myTableView reloadData];
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
    if (self.mFileInfo) {
        return 1;
    }
    return 3;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { // title
        return titleView.frame.size.height;
    }else if(indexPath.row == 1){ // video of season
        return videosOfSeasonVC.view.frame.size.height;
    }else if(indexPath.row == 2){ // video suggest
        return videosSuggestOfVideoVC.view.frame.size.height;
    }
    return 0;
}

#pragma mark - Custom Cell

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self tableView:tableView titleCellForRowAtIndexPath:indexPath];
    }else if(indexPath.row == 1){
        return [self tableView:tableView videoOfSeasonCellForRowAtIndexPath:indexPath];
    }
    return [self tableView:tableView channelCellForRowAtIndexPath:indexPath];
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
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

- (UITableViewCell*)tableView:(UITableView *)tableView titleCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellForTitleView"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellForTitleView"];
        [cell addSubview:titleView];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    [self setContentTitleView];
    return cell;
}
//
- (UITableViewCell*)tableView:(UITableView *)tableView channelCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!videosSuggestOfVideoVC) {
        videosSuggestOfVideoVC = [[VideoSuggestOfVideoVC alloc] initWithNibName:@"VideoSuggestOfVideoVC" bundle:nil];
        [videosSuggestOfVideoVC.view setHidden:NO];
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:videosSuggestOfVideoVC.view.bounds];
    [cell addSubview:videosSuggestOfVideoVC.view];
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView videoOfSeasonCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!videosOfSeasonVC) {
        videosOfSeasonVC = [[VideosOfSeasonVC alloc] initWithNibName:@"VideosOfSeasonVC" bundle:nil];
        [videosOfSeasonVC.view setHidden:NO];
    }
    [videosOfSeasonVC setDelegate:self];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:videosOfSeasonVC.view.bounds];
    [cell addSubview:videosOfSeasonVC.view];
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void) showChannel:(id)item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showChannel:)]) {
        [self.delegate showChannel:item];
    }
}

- (void) setUILabelTextWithVerticalAlignTopWithLabel:(UILabel*) label{
    // set number line = 0 to show full text
//    CGSize theStringSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    CGSize theStringSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, label.frame.size.height)];
    float X = label.frame.origin.x;
    float width = label.frame.size.width;
    label.frame = CGRectMake(X, label.frame.origin.y, width, theStringSize.height);
}

- (CGRect) getHeighWithText:(NSString *)theText withLabel:(UILabel*) label{
    CGSize theStringSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    float X = label.frame.origin.x;
    float width = label.frame.size.width;
    label.frame = CGRectMake(X, label.frame.origin.y, width, theStringSize.height);
    return label.frame;
}

- (void) showVideosOfSeason:(NSMutableArray*) list{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showVideoSuggest:andList:)]) {
        [self.delegate showVideoSuggest:NO andList:list];
    }
}

- (void) showVideosSuggestMore{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showVideoSuggest:andList:)]) {
        [self.delegate showVideoSuggest:YES andList:nil];
    }
}


@end
