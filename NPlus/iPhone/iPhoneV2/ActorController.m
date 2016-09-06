//
//  ActorController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/13/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ActorController.h"
#import "UIImage+ImageEffects.h"
#import "MyNavigationItem.h"
#import "ShareTask.h"
#import "MoreOptionView.h"
@interface ActorController () <MyNaviItemDelegate,MoreOptionViewDelegate>{
    BOOL isDidLayout;
    MyNavigationItem *myNaviItem;
}

@end

@implementation ActorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self decordSubVies];
    myNaviItem = [[MyNavigationItem alloc]initWithController:self type:5];
    myNaviItem.delegate =self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Nghệ sĩ";
    [self trackScreen:@"iOS.SearchArtist"];
    APPDELEGATE.rootNavController.navigationBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    APPDELEGATE.rootNavController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadDataIsAnimation:NO];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!isDidLayout) {
        isDidLayout = YES;
        [self loadArtistDetail];
    }
}

- (void)decordSubVies {
    //self.offsetMenu = self.infoView.frame.size.height;
    UIImage *image = [UIImage imageNamed:kDefault_Actor_Img];
    UIImage *imageEff = [image applyLightEffect];
    [_imgCover setImage:imageEff];
    _imgAvatar.image = [Utilities getRoundedRectImageFromImage:image onReferenceView:_imgAvatar withCornerRadius:_imgAvatar.frame.size.width/2];
    _viewInfo.frame = CGRectMake(0, 0, SCREEN_SIZE.width, _viewInfo.frame.size.height);
}

- (void)loadContent {
    if (_artist) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_artist.avatarImg]]];
        image = [Utilities imageByCroppingImage:image toSize:CGSizeMake(self.imgAvatar.frame.size.width, self.imgAvatar.frame.size.width*9/16)];
        [self.imgCover setImage:[image applyLightEffect]];
        self.imgAvatar.clipsToBounds = YES;
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width/2;
        [self.imgAvatar setImageWithURL:[NSURL URLWithString:_artist.avatarImg] placeholderImage:[UIImage imageNamed:kDefault_Actor_Img]];
        self.lblName.text = _artist.alias;
        _lblFullName.text = _artist.name;
        _lblBirthday.text = _artist.birthday;
        _lblNational.text = _artist.national;
        
        _lblFullName1.text = _artist.name;
        _lblBirthday1.text = _artist.birthday;
        _lblNational1.text = _artist.national;
        _lblFullDes.text = _artist.fullDes;
        _lblFullDes.font = [UIFont fontWithName:kFontRegular size:15];
        CGFloat heightLabel = [Utilities heightForCellWithContent:_artist.fullDes];
        _lblFullDes.frame = CGRectMake(8, _lblFullDes.frame.origin.y, SCREEN_SIZE.width - 20, heightLabel);
        //_viewFullInfo.translatesAutoresizingMaskIntoConstraints = NO;
        _viewFullInfo.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height - _imgCover.frame.origin.y - _imgCover.frame.size.height);
        [_viewFullInfo setContentSize:CGSizeMake(SCREEN_SIZE.width, heightLabel + 130)];
        [self.view addSubview:_viewFullInfo];
    }
}

- (void)loadArtistDetail {
    [[APIController sharedInstance]getArtistDetailWithKey:_artist.artistId completed:^(int code, Artist *artist) {
        if (artist) {
            _artist =artist;
            [self loadContent];
//            [[NSNotificationCenter defaultCenter]postNotificationName:kDidLoadDetailArtist object:nil];
            
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)loadDataIsAnimation:(BOOL)isAnimation{
    self.pageIndex = 1;
    self.total = 0;
    self.isLoadMore = NO;
    [self.dataSources removeAllObjects];
    [self loadChannelOfArtist:_artist.artistId showLoading:NO];
}

- (void)loadChannelOfArtist:(long)artistId showLoading:(BOOL)isShowLoading{
    if (APPDELEGATE.internetConnnected) {
        if (isShowLoading) {
            [self showProgressHUDWithTitle:nil];
        }
        [[APIController sharedInstance]getChannelOfArtist:artistId pageIndex:self.pageIndex pageSize:kDefaultPageSize completed:^(int code, NSArray *results, BOOL loadmore, int total) {
            if (results) {
                NSArray *array = results;
                [self.dataSources addObjectsFromArray:array];
                self.isLoadMore = loadmore;
                if (loadmore) {
                    self.pageIndex = self.pageIndex + 1;
                }
                [self.tbInfo reloadData];
            }
            [self dismissHUD];
            [self loadEmptyData];
        } failed:^(NSError *error) {
            [self dismissHUD];
        }];
    } else {
        
    }
}

- (void)loadMore {
    if (self.isLoadMore) {
        [self loadChannelOfArtist:_artist.artistId showLoading:NO];
    }
}
- (IBAction)btnMoreTapped:(id)sender {
    CGFloat heightLabel = [Utilities heightForCellWithContent:_artist.fullDes];
    [UIView animateWithDuration:0.3 animations:^{
        _lblFullDes.text = _artist.fullDes;
        _lblFullDes.font = [UIFont fontWithName:kFontRegular size:15];
        _lblFullDes.translatesAutoresizingMaskIntoConstraints = YES;
        _lblFullDes.frame = CGRectMake(10, _lblFullDes.frame.origin.y, SCREEN_SIZE.width - 20, heightLabel);
        _viewFullInfo.translatesAutoresizingMaskIntoConstraints = YES;
        _viewFullInfo.frame = CGRectMake(0, _imgCover.frame.origin.y + _imgCover.frame.size.height, SCREEN_SIZE.width, SCREEN_SIZE.height - _imgCover.frame.origin.y - _imgCover.frame.size.height);
        [_viewFullInfo setContentSize:CGSizeMake(SCREEN_SIZE.width, heightLabel + 200)];
        _btnCancel.alpha = 1;
    } completion:^(BOOL finished) {
        [_viewFullInfo setContentSize:CGSizeMake(SCREEN_SIZE.width, heightLabel + 200)];
    }];
}
- (IBAction)btnCancelTapped:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewFullInfo.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height - _imgCover.frame.origin.y - _imgCover.frame.size.height);
        _btnCancel.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - NaviItem Delegate
- (void)didRightButtonTapWithType:(int)type {
    MoreOptionView *moreView = [[MoreOptionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) type:5 object:_artist linkShare:_artist.shortLink];
    moreView.delegate = self;
    [APPDELEGATE.window addSubview:moreView];
}
- (void)didLeftButtonTap{};

#pragma mark - MoreOptionView Delegate
- (void)didTappedButtonIndex:(int)index object:(id)object linkShare:(NSString *)linkShare title:(NSString *)title {
    if (index == 1 && [title isEqualToString:@"Chia sẻ Facebook"]) {
        if (!_artist.shortLink || [_artist.shortLink isEqualToString:@""]) {
            [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho nghệ sĩ này." position:@"top" type:errorImage];
            return;
        }
        [[ShareTask sharedInstance] setViewController:self];
        [[ShareTask sharedInstance] shareFacebook:_artist];
    } else if (index == 2 && [title isEqualToString:@"Copy Link"]) {
        if (!linkShare || [linkShare isEqualToString:@""]) {
            [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho nghệ sĩ này." position:@"top" type:errorImage];
            return;
        }
        [self trackEvent:@"iOS_share_on_copy_link"];
        NSString *dataText = linkShare;
        if (dataText && ![dataText isKindOfClass:[NSNull class]]) {
            [[UIPasteboard generalPasteboard] setString:dataText];
            [APPDELEGATE showToastWithMessage:@"Đã copy link." position:@"top" type:doneImage];
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
    return 2;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    } else {
        HomeHeaderSection *headerView = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
        headerView.backgroundColor = UIColorFromRGB(0xfcfcfc);
        headerView.lblHeader.text = kGENRE_CHANNEL_ACTOR;
        return headerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return section == 0 ? 0 : 60;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 11)];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
            lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
            UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_SIZE.width, 10)];
            paddingView.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [footerView addSubview:lineView];
            [footerView addSubview:paddingView];
            return footerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [tableView isEqual:self.tbInfo]&& section==0 ? 11 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 1 : self.dataSources.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section == 0 ? _viewInfo.frame.size.height : 92;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemCellIdef = @"itemCellIdef";
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 370)];
        [cell addSubview:_viewInfo];
        cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ItemCell *cell = (ItemCell*)[self.tbInfo dequeueReusableCellWithIdentifier:itemCellIdef];
        if (!cell) {
            cell = [Utilities loadView:[ItemCell class] FromNib:@"ItemCell"];
        }
        if (self.dataSources.count > indexPath.row) {
            Channel *cn = (Channel*)[self.dataSources objectAtIndex:indexPath.row];
            cell.channel = cn;
            [cell loadContentWithType:typeChannel];
        }
        cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (self.dataSources.count >indexPath.row) {
            Channel *cn = (Channel*)[self.dataSources objectAtIndex:indexPath.row];
            [self didSelectChannelCellWith:cn];
        }
    }
}

- (void)didSelectChannelCellWith:(Channel*)channel {
    [self trackEvent:@"iOS_channel_play_recommend_channel"];
    if (APPDELEGATE.internetConnnected) {
        if (channel.videoKey) {
            [[APIController sharedInstance]getVideoStreamWithKey:channel.videoKey completed:^(int code, VideoStream *results) {
                Video *video = [[Video alloc]init];
                video.video_id = channel.videoKey;
                video.videoStream = results;
                APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
                APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
                [APPDELEGATE playerLoadDataWithType:@"NEW_VIDEO" video:video channel:nil index:0];
            } failed:^(NSError *error) {
                
            }];
        } else {
            [[APIController sharedInstance]getChannelDetailWithKey:channel.channelId completed:^(int code, Channel *results) {
                if (results) {
                    //APPDELEGATE.nowPlayerVC.curChannel = results;
                    [[APIController sharedInstance]getVideoStreamWithKey:results.videoKey completed:^(int code, VideoStream *stream) {
                        Video *video = [[Video alloc]init];
                        video.video_id = results.videoKey;
                        video.videoStream = stream;
                        APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
                        APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
                        [APPDELEGATE playerLoadDataWithType:@"SHOWCASE_CHANNEL" video:video channel:results index:0];
                    } failed:^(NSError *error) {
                        
                    }];
                }
            } failed:^(NSError *error) {
                
            }];
        }
    }
}
@end
