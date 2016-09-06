//
//  DetailController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/11/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "DetailController.h"
#import "HomeHeaderSection.h"
#import "GenreTableViewCell.h"
#import "MyNavigationItem.h"
#import "ShareTask.h"
#import "ActorController.h"
#import "LoginViewController.h"
#import "MoreOptionView.h"

@interface DetailController () <LoginControllerDelegate,MoreOptionViewDelegate>{
    NSString *description;
    BOOL retrictReloadCell;
    NSArray *arrayTag;
    UILabelViewFlowLayout *tagView;
    BOOL isDidLayout;
    CGFloat height;
    BOOL isExpanded;
    MyNavigationItem *myNavi;
    LoginViewController *_loginVC;
    UIButton *btnFollow;
}

@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tbInfo registerNib:[UINib nibWithNibName:@"DetailInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"desCellIdenf"];
    [self.tbInfo registerNib:[UINib nibWithNibName:@"GenreTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"genreCell"];
    [self setupNavigationBar];
    [self updateChannelInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Thông tin kênh";
    [self trackScreen:@"iOS.Channel"];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!isDidLayout) {
        isDidLayout = YES;
        _lblNameScroll.text = _channel.channelName;
        _lblViewCountScroll.text = [Utilities convertToStringFromCount:_channel.view];
        _lblDesrScroll.text = _channel.channelDes;
        
        _lblDesrScroll.font = [UIFont fontWithName:kFontRegular size:15];
        CGFloat heightLabel = [Utilities heightForCellWithContent:_channel.channelDes];
        _lblDesrScroll.frame = CGRectMake(8, _lblDesrScroll.frame.origin.y, SCREEN_SIZE.width - 16, heightLabel);
        //_viewFullInfo.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollViewDesc.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height - _imgThumb.frame.origin.y - _imgThumb.frame.size.height);
        [_scrollViewDesc setContentSize:CGSizeMake(SCREEN_SIZE.width, heightLabel + 60)];
        [self.view addSubview:_scrollViewDesc];
    }
}

- (void)setupNavigationBar {
    myNavi = [[MyNavigationItem alloc]initWithController:self type:9];
    self.navigationController.navigationBarHidden = NO;
    UIButton *btnShare = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btnShare setImage:[UIImage imageNamed:@"icon-share"] forState:UIControlStateNormal];
    [btnShare setImage:[UIImage imageNamed:@"icon-share-h-v2"] forState:UIControlStateHighlighted];
    btnShare.tag = 1;
    [btnShare addTarget:self action:@selector(rightBarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn1 = [[UIBarButtonItem alloc]initWithCustomView:btnShare];
    
    btnFollow = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btnFollow setImage:[UIImage imageNamed:@"icon-theodoi-channel-v2"] forState:UIControlStateNormal];
    [btnFollow setImage:[UIImage imageNamed:@"icon-theodoi-channel-v2"] forState:UIControlStateHighlighted];
    btnFollow.tag = 2;
    [btnFollow addTarget:self action:@selector(rightBarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc]initWithCustomView:btnFollow];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, btn2,btn1];
}

- (void)updateChannelInfo {
    if (_channel) {
        [_imgThumb setImageWithURL:[NSURL URLWithString:_channel.fullImg] placeholderImage:[UIImage imageNamed:kDefault_Channel_Img]];
        _lblChannelName.text = _channel.channelName;
        _lblView.text = [Utilities convertToStringFromCount:_channel.view];
        _lblFollow.text = [Utilities convertToStringFromCount:_channel.totalFollow];
        _lblRating.text = [NSString stringWithFormat:@"%.01lf", _channel.rating];
        
        _lblDirectorName.text = _channel.director;
        _lblBroadcast.text = _channel.broadcast;
        _lblCountry.text = _channel.national;
        _lblProducer.text = _channel.producer;
        description = _channel.channelDes;
        
        if (_channel.genres) {
            arrayTag = _channel.genres;
            tagView = [[UILabelViewFlowLayout alloc]initWithData:arrayTag];
            [tagView arrangeSubViews];
            tagView.delegate = self;
        }
        
        if (!_channel.isSubcribe) {
            [btnFollow setImage:[UIImage imageNamed:@"icon-theodoi-channel-v2"] forState:UIControlStateNormal];
            [btnFollow setImage:[UIImage imageNamed:@"icon-theodoi-t-v2"] forState:UIControlStateHighlighted];
        } else {
            [btnFollow setImage:[UIImage imageNamed:@"icon-theodoi-channel-h-v2"] forState:UIControlStateNormal];
            [btnFollow setImage:[UIImage imageNamed:@"icon-botheodoi-popup-v2"] forState:UIControlStateHighlighted];
        }
        
        [_tbInfo reloadData];
        
    }
}

- (void)rightBarButtonTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 1) {
        MoreOptionView *moreView = [[MoreOptionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) type:5 object:_channel linkShare:_channel.linkShare];
        moreView.delegate = self;
        [APPDELEGATE.window addSubview:moreView];
    } else if (btn.tag == 2) {
        [self trackEvent:@"iOS_channel_follow"];
        if (APPDELEGATE.isLogined) {
            if (_channel.isSubcribe) {
                [APPDELEGATE showToastWithMessage:@"Bạn đã theo dõi kênh này!" position:@"top" type:errorImage];
                return;
            }
            [[APIController sharedInstance] userSubcribeChannel:_channel.channelId subcribe:YES completed:^(int code, BOOL results) {
                if (results) {
                    if (APPDELEGATE.nowPlayerVC.curChannel && [APPDELEGATE.nowPlayerVC.curChannel.channelId isEqualToString:_channel.channelId]) {
                        APPDELEGATE.nowPlayerVC.curChannel.isSubcribe = YES;
                        [APPDELEGATE.nowPlayerVC updateChannelInfo];
                    }
                    [APPDELEGATE showToastWithMessage:@"Đã thêm vào theo dõi thành công!" position:@"top" type:doneImage];
                    [btnFollow setImage:[UIImage imageNamed:@"icon-theodoi-channel-h-v2"] forState:UIControlStateNormal];
                    [btnFollow setImage:[UIImage imageNamed:@"icon-botheodoi-popup-v2"] forState:UIControlStateHighlighted];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kDidSubcribeChannel object:nil];
                } else {
                    [APPDELEGATE showToastWithMessage:@"Theo dõi không thành công!" position:@"top" type:errorImage];
                }
            } failed:^(NSError *error) {
                
            }];
        } else {
            [self showLoginViewWithTask:kTaskFolow];
        }
    }
}

#pragma mark - MoreViewDelegate
- (void)didTappedButtonIndex:(int)index object:(id)object linkShare:(NSString *)linkShare title:(NSString *)title {
    if (index == 1 && [title isEqualToString:@"Chia sẻ Facebook"]) {
        if (!_channel.linkShare || [_channel.linkShare isEqualToString:@""]) {
            [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho kênh này." position:@"top" type:errorImage];
            return;
        }
        [[ShareTask sharedInstance] setViewController:self];
        [[ShareTask sharedInstance] shareFacebook:_channel];
    } else if (index == 2 && [title isEqualToString:@"Copy Link"]) {
        if (!linkShare || [linkShare isEqualToString:@""]) {
            [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho kênh này." position:@"top" type:errorImage];
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

- (void)showLoginViewWithTask:(NSString*)task {
    
    _loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    _loginVC.task = task;
    _loginVC.delegate = self;
    _loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_loginVC animated:YES completion:^{
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.loginView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        }];
    }];
}

#pragma mark - LoginController Delegate
- (void)didLoginSuccessWithTask:(NSString *)task {
    if (_loginVC) {
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_loginVC dismissViewControllerAnimated:YES completion:^{
                [_loginVC.view removeFromSuperview];
                _loginVC = nil;
            }];
            if ([task isEqualToString:kTaskFolow]){
                [APPDELEGATE.nowPlayerVC btnFollowTapped:nil];
                [APPDELEGATE.nowPlayerVC loadVideoDetailWithLoadChannel:NO];
            } else if ([task isEqualToString:kTaskRating]){
                [APPDELEGATE.nowPlayerVC btnRatingTapped:nil];
                [APPDELEGATE.nowPlayerVC loadChannelDetail:APPDELEGATE.nowPlayerVC.curChannel.channelId];
                [APPDELEGATE.nowPlayerVC loadVideoDetailWithLoadChannel:NO];
                
            }
        }];
    }
}
- (void)didLoginFailedWithTask:(NSString *)task {
    if (_loginVC) {
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_loginVC dismissViewControllerAnimated:YES completion:^{
                [_loginVC.view removeFromSuperview];
                _loginVC = nil;
            }];
        }];
    }
}
- (void)didCancelLogin {
    if (_loginVC) {
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_loginVC dismissViewControllerAnimated:YES completion:^{
                
            }];
            [_loginVC.view removeFromSuperview];
            _loginVC = nil;
        }];
    }
}

#pragma mark - GenreTagView Delegate
- (void)didTappedWithGenre:(Genre *)genre {
    if (!genre.parentKey || [genre.parentKey isEqualToString:@""] || [genre.parentKey isKindOfClass:[NSNull class]] || [genre.parentKey isEqualToString:genre.genreId]) {
        [APPDELEGATE didSelectGenre:genre listGenres:nil index:0];
    } else {
        Genre *parentGenre = [[Genre alloc]init];
        parentGenre.genreId = genre.parentKey;
        if ([parentGenre.genreId isEqualToString:ID_GENRE_PHIMNGAN]) {
            parentGenre.genreName = kGENRE_SHORT_FILM;
        } else if ([parentGenre.genreId isEqualToString:ID_GENRE_TVSHOW]) {
            parentGenre.genreName = kGENRE_TV_SHOW;
        } else if ([parentGenre.genreId isEqualToString:ID_GENRE_GIAITRI]) {
            parentGenre.genreName = kGENRE_RELAX;
        }
        [[APIController sharedInstance]getListGenresWithParentId:parentGenre.genreId completed:^(int code, NSArray *results) {
            if (results) {
                NSMutableArray *arraySubGenres = (NSMutableArray*)results;
                [arraySubGenres removeObjectAtIndex:0];
                for (Genre *gr in results) {
                    if ([gr.genreId isEqualToString:genre.genreId]) {
                        NSInteger index = [results indexOfObject:gr];
                        [APPDELEGATE didSelectGenre:parentGenre listGenres:arraySubGenres index:index];
                        break;
                    }
                }
            }
        } failed:^(NSError *error) {
            
        }];
    }
//    [[APIController sharedInstance]logViewedWithObjectId:genre.genreId type:@"GENRE" completed:^(BOOL result) {
//        
//    } failed:^(NSError *error) {
//        
//    }];
}

#pragma mark - TableView
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50;
    } else if (section == 2) {
        if (_channel.artists.count == 0) {
            return  0;
        }
        return 60;
    }
    return  0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return _headerChannel;
    } else if (section == 2) {
        if (_channel.artists.count == 0) {
            return  nil;
        }
        HomeHeaderSection *headerView = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
        headerView.backgroundColor = UIColorFromRGB(0xfcfcfc);
        headerView.lblHeader.text = @"Nghệ sĩ tham gia";
        headerView.iconHeader.hidden = YES;
        headerView.isHideButton = YES;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 11;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 11)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_SIZE.width, 10)];
        paddingView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        //[footerView addSubview:lineView];
        [footerView addSubview:paddingView];
        return footerView;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 1;
    } else if (section == 1) {
        return 2;
    }
    return _channel.artists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!retrictReloadCell) {
            height = [Utilities heightForCellWithContent:description];
            if (!isExpanded) {
                height = height <= 75 ? height+25 : 100;
                return height; // Normal height
            } else {
                height = height + 25;
                return height;
            }
            return height <= 75 ? height+25 : 100; // Normal height
        } else {
            retrictReloadCell = !retrictReloadCell;
            return height;
        }
    } else if (indexPath.section == 1) {
        return indexPath.row == 0 ? 240 : tagView.frame.size.height + 5;
    } else {
        return 90;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *desCellIdenf = @"desCellIdenf";
        DetailInfoTableViewCell *cell = (DetailInfoTableViewCell*)[_tbInfo dequeueReusableCellWithIdentifier:desCellIdenf];
        if (!cell) {
            cell = [Utilities loadView:[DetailInfoTableViewCell class] FromNib:@"DetailInfoTableViewCell"];
        }
        cell.lblDescription.text = description;
        [cell.btnViewMore setImage:isExpanded?[UIImage imageNamed:@"icon-thulai-v2"]:[UIImage imageNamed:@"icon-view-more-v2"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell addSubview:_viewInfo];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            if (![tagView isDescendantOfView:cell]) {
                [cell addSubview:tagView];
                //tagView.delegate = self;
            }
            cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        static NSString *genreCell = @"genreCell";
        GenreTableViewCell *cell = (GenreTableViewCell*)[self.tbMain dequeueReusableCellWithIdentifier:genreCell];
        if (!cell) {
            cell = [Utilities loadView:[GenreTableViewCell class] FromNib:@"GenreTableViewCell"];
        }
        if (_channel.artists.count > indexPath.row) {
            cell.artist = (Artist*)[_channel.artists objectAtIndex:indexPath.row];
            [cell loadContentViewArtist];
        }
        
        cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (_channel.artists.count > indexPath.row) {
            Artist *artist = [_channel.artists objectAtIndex:indexPath.row];
            [APPDELEGATE didSelectArtistCellWith:artist];
//            ActorController *actorVC = [[ActorController alloc]initWithNibName:@"ActorController" bundle:nil];
//            actorVC.artist = artist;
//            [self.navigationController pushViewController:actorVC animated:YES];
        }
    }
}

- (void)didTapViewMoreBtn:(DetailInfoTableViewCell *)cell {
    //[self updateTableViewWithCell:cell];
    CGFloat heightLabel = [Utilities heightForCellWithContent:_channel.channelDes];
    [UIView animateWithDuration:0.3 animations:^{
        _lblDesrScroll.text = _channel.channelDes;
        _lblDesrScroll.font = [UIFont fontWithName:kFontRegular size:15];
        _lblDesrScroll.translatesAutoresizingMaskIntoConstraints = YES;
        _lblDesrScroll.frame = CGRectMake(10, 50, SCREEN_SIZE.width - 20, heightLabel);
        _scrollViewDesc.translatesAutoresizingMaskIntoConstraints = YES;
        _scrollViewDesc.frame = CGRectMake(0, _imgThumb.frame.origin.y + _imgThumb.frame.size.height, SCREEN_SIZE.width, SCREEN_SIZE.height - _imgThumb.frame.origin.y - _imgThumb.frame.size.height);
        [_scrollViewDesc setContentSize:CGSizeMake(SCREEN_SIZE.width, heightLabel + 120)];
        _btnCancelScroll.alpha = 1;
    } completion:^(BOOL finished) {
        [_scrollViewDesc setContentSize:CGSizeMake(SCREEN_SIZE.width, heightLabel + 120)];
    }];
}

- (IBAction)btnCancelTapped:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _scrollViewDesc.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height - _imgThumb.frame.origin.y - _imgThumb.frame.size.height);
        _btnCancelScroll.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)updateTableViewWithCell:(DetailInfoTableViewCell*)cell {
    isExpanded = !isExpanded;
    [self.tbInfo reloadData];
    
//    if (isExpanded) {
//        [self.tbInfo reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    } else {
//        [self.tbInfo reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    }
//    [self.tbInfo beginUpdates];
//    [self.tbInfo endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
