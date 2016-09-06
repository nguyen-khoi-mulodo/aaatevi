//
//  ListVideoFullScreenController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/9/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ListVideoFullScreenController.h"
#import "TVCollectionViewCell.h"
#import "ItemCell.h"
#import "ShareTask.h"

@interface ListVideoFullScreenController ()

@end

@implementation ListVideoFullScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tbVideo registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"itemCellIdef"];
    [self.collectionVideo registerNib:[UINib nibWithNibName:@"TVCollectionViewCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"tvCollectionViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemCellIdef = @"itemCellIdef";
    ItemCell *cell = (ItemCell*)[self.tbVideo dequeueReusableCellWithIdentifier:itemCellIdef];
    if (!cell) {
        cell = [Utilities loadView:[ItemCell class] FromNib:@"ItemCell"];
    }
    if (self.dataSources.count > indexPath.row) {
        Video *v = (Video*)[self.dataSources objectAtIndex:indexPath.row];
        cell.video = v;
        cell.delegate = self;
        [cell loadContentWithType:typeVideoInSeasonFullScreen];
    }
    if (indexPath.row ==_curIndexVideoChoose) {
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        cell.lblTitle.textColor = UIColorFromRGB(0x00adef);
    } else {
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.lblTitle.textColor = UIColorFromRGB(0xffffff);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSources.count > indexPath.row) {
        Video *v = [self.dataSources objectAtIndex:indexPath.row];
        if ([v.video_id isEqualToString:APPDELEGATE.nowPlayerVC.currentVideo.video_id]) {
            return;
        }
        [[APIController sharedInstance]getVideoStreamWithKey:v.video_id completed:^(int code, VideoStream *results) {
            if (results) {
                v.videoStream = results;
                _lblTitle.text = [NSString stringWithFormat:@"%@",APPDELEGATE.nowPlayerVC.season.seasonName];
                _lblIndex.text = [NSString stringWithFormat:@"%d/%d",self.curIndexVideoChoose+1,(int)APPDELEGATE.nowPlayerVC.season.videos.count];
                APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
                APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
                [APPDELEGATE playerLoadDataWithType:@"NEW_VIDEO_IN_SEASON" video:v channel:nil index:indexPath.row];
                APPDELEGATE.nowPlayerVC.curIndexVideoChoose = _curIndexVideoChoose = (int)indexPath.row;
                [_tbVideo reloadData];
                [APPDELEGATE.nowPlayerVC.tbVideo reloadData];
                APPDELEGATE.nowPlayerVC.lblVideoOrder.text = [NSString stringWithFormat:@"%d/%d",(int)_curIndexVideoChoose+1,(int)APPDELEGATE.nowPlayerVC.season.videosCount];
            }
            //[self dismissHUD];
        } failed:^(NSError *error) {
            //[self dismissHUD];
        }];
    }
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tvCollectionCellIdenf = @"tvCollectionViewCell";
    TVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tvCollectionCellIdenf forIndexPath:indexPath];
    if (!cell) {
        cell = [Utilities loadView:[TVCollectionViewCell class] FromNib:@"TVCollectionViewCell"];
    }
    if (self.dataSources.count > indexPath.row) {
        Video *v = [self.dataSources objectAtIndex:indexPath.row];
        cell.video = v;
        cell.lblTitle.text = v.video_subtitle;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSources.count > indexPath.row) {
        Video *v = [self.dataSources objectAtIndex:indexPath.row];
        [[APIController sharedInstance]getVideoStreamWithKey:v.video_id completed:^(int code, VideoStream *results) {
            if (results) {
                v.videoStream = results;
                APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
                APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
                [APPDELEGATE playerLoadDataWithType:@"NEW_VIDEO_IN_SEASON" video:v channel:nil index:(int)indexPath.row];
                _curIndexVideoChoose = (int)indexPath.row;
//                _lblVideoOrder.text = [NSString stringWithFormat:@"%d/%d",(int)_curIndexVideoChoose+1,(int)_season.videosCount];
            }
            //[self dismissHUD];
        } failed:^(NSError *error) {
            //[self dismissHUD];
        }];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, (SCREEN_SIZE.width - 70*4)/5, 10, (SCREEN_SIZE.width - 70*4)/5);
}

#pragma mark - ItemCell Delegate 
- (void)didButtonMoreTapped:(id)object {
    if ([object isKindOfClass:[Video class]]) {
        Video *v = (Video*)object;
        MoreOptionView *moreView = [[MoreOptionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) type:5 object:v linkShare:v.link_share];
        moreView.delegate = self;
        [APPDELEGATE.window addSubview:moreView];
    }
}
#pragma mark - MoreOptionView Delegate
- (void)didTappedButtonIndex:(int)index object:(id)object linkShare:(NSString *)linkShare title:(NSString *)title{
    if ( !linkShare || [linkShare isEqualToString:@""]) {
        if ([object isKindOfClass:[Video class]]) {
            Video *video = (Video*)object;
            [[APIController sharedInstance]getVideoDetailWithKey:video.video_id completed:^(int code, Video *results) {
                if (results) {
                    if (!results.link_share || [results.link_share isEqualToString:@""]) {
                        [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho video này." position:@"top" type:errorImage];
                        return;
                    }
                    if (index == 1) {
                        [[ShareTask sharedInstance] setViewController:self];
                        [[ShareTask sharedInstance] shareFacebook:results];
                    } else if (index == 2) {
                        [self trackEvent:@"iOS_share_on_copy_link"];
                        NSString *dataText = results.link_share;
                        if (dataText && ![dataText isKindOfClass:[NSNull class]]) {
                            [[UIPasteboard generalPasteboard] setString:dataText];
                            [APPDELEGATE showToastWithMessage:@"Đã copy link" position:@"top" type:doneImage];
                        }
                    }
                    
                }
            } failed:^(NSError *error) {
                
            }];
        }
        
        return;
    }
    if ([object isKindOfClass:[Video class]] && index == 1){
        Video *video = (Video*)object;
        [[ShareTask sharedInstance] setViewController:self];
        [[ShareTask sharedInstance] shareFacebook:video];
    } else if ([object isKindOfClass:[Video class]] && index == 2) {
        [self trackEvent:@"iOS_share_on_copy_link"];
        NSString *dataText = linkShare;
        if (dataText && ![dataText isKindOfClass:[NSNull class]]) {
            [[UIPasteboard generalPasteboard] setString:dataText];
            [APPDELEGATE showToastWithMessage:@"Đã copy link" position:@"top" type:doneImage];
        }
    }
}
@end
