//
//  NowPlayerVC.m
//  NPlus
//
//  Created by TEVI Team on 8/20/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "NowPlayerVC.h"
#import "UIView+VKFoundation.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAITracker.h"
#import "GAIFields.h"
#import "Season.h"
#import "DownloadManager.h"
#import "DBHelper.h"
#import "ParserObject.h"
#import "GooglePlusLoginTask.h"
#import "SubTitle.h"
#import "RC4Crypt.h"
#import "QualityURL.h"
#import "TVCollectionViewCell.h"
#import "ShareTask.h"
#import "DetailController.h"
#import "DownloadedItemCell.h"

static float height_player = 0;
static NSString* curAsset;
@implementation NowPlayerView
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

@end
@interface NowPlayerVC ()<UIAlertViewDelegate>{
    NSMutableArray *_lstRelated;
    QualityURL *_quality;
    BOOL _landscapeActive;
    BOOL _isAnimation;
    UIInterfaceOrientation _orientationTo;
    BOOL _isShowDownload;
    BOOL _isChangeRotate;
    BOOL isAllowCellcular;
    NSInteger _curIndexDownload;
    NSString *scrNameGA;
    BOOL isMiniInfo;
    CGRect originScrollView;
    UIScrollView *scrollView;
    HomeHeaderSection *headerViewOffline;
    BOOL isReload;
}
//@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation NowPlayerVC
//@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;
@synthesize type = _type;
@synthesize curId = _curId;
@synthesize curChannel = _curChannel;
@synthesize itemCollectionType = _itemCollectionType;
@synthesize isShowNowPlaying = _isShowNowPlaying;
@synthesize lstVideo = _lstVideo;
@synthesize curIndexVideoChoose = _curIndexVideoChoose;
@synthesize subtitle = _subtitle;
@synthesize currentOfflineVideo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)cellcularChange{
    isAllowCellcular = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrNameGA = @"VideoDetail";
    _numberOfTabs = 4;
    self.offsetMenu = height_player;
    // Do any additional setup after loading the view from its nib.
    float delta = 0.5625f;
    height_player = SCREEN_WIDTH * delta;
    
    _lstVideo = [[NSMutableArray alloc] init];
//    _lstRelated = [[NSMutableArray alloc] init];
    _landscapeActive = NO;
    _isAnimation = NO;
    _isShowDownload = NO;
    _isChangeRotate = NO;
    isAllowCellcular = NO;
    _curIndexDownload = -1;
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    }
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = YES;
    
//    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//    self.pageViewController.view.frame = CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
    
    [self.tbVideo registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"itemCellIdef"];
    [self.tbInfo registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"itemCellIdef"];
    [self.tbSuggestion registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"itemCellIdef"];
    [self.collectionVideo registerNib:[UINib nibWithNibName:@"TVCollectionViewCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"tvCollectionViewCell"];
    [self.tbMain registerNib:[UINib nibWithNibName:@"DownloadedItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"downloadItemCellIdef"];
    
    [self.tbInfo setContentInset:UIEdgeInsetsMake(0, 0, -10, 0)];
    
    _infoView.translatesAutoresizingMaskIntoConstraints = YES;
    _infoView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 370);
    
    self.mainView.frame = CGRectMake(0,height_player, SCREEN_WIDTH, SCREEN_SIZE.height - height_player);
    _contentContainer.frame = CGRectMake(0, 0, SCREEN_SIZE.width, _mainView.frame.size.height);
    self.tbSuggestion.frame = CGRectMake(0, _contentContainer.frame.size.height, SCREEN_SIZE.width, _contentContainer.frame.size.height);
    [_contentContainer addSubview:self.tbSuggestion];
    
    HomeHeaderSection *headerView = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
    headerView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    headerView.lblHeader.text = kGENRE_PLAYLIST;
    headerView.iconHeader.hidden = YES;
    [_headerPlaylistView addSubview:headerView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 54, SCREEN_SIZE.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [_headerPlaylistView addSubview:lineView];
    [self decordSubView];
    
    self.player = [[NPVideoPlayer alloc] init];
    self.player.forceRotate = YES;
    self.player.delegate = self;
    [self.view addSubview:self.player.view];
    [self.view bringSubviewToFront:self.player.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadCurrentVideo:) name:kDownloadVideoCurrentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadedVideo:) name:kDidDownloadedVideoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadedVideo:) name:kDidDeleteVideoDownloaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginNotification) name:kDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willEnterForeground) name:kWillEnterForeground object:nil];
    self.mainView.translatesAutoresizingMaskIntoConstraints = YES;
}


- (void)stopPlayer{
    if (self.player) {
        [self.player stop];
        //add video to history
        double seconds = CMTimeGetSeconds([self.player timeCurrent]);
        //double duration = CMTimeGetSeconds([self.player timeDuration]);
//        if (seconds == duration) {
//            seconds = -1;
//        }
        [[DBHelper sharedInstance] addVideoToHistory:_currentVideo withStopTime:seconds];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHistoryNotification object:nil];
        _currentVideo = nil;
    }
    
}

- (void)changeStateHDTap:(BOOL)isHD {
    if (!APPDELEGATE.nowPlayerVC.currentVideo) {
        return;
    }
    NSArray *arrQuality = APPDELEGATE.nowPlayerVC.currentVideo.videoStream.streamUrls;
    if (arrQuality.count > 0) {
        self.player.view.btnHD.hidden = NO;
        QualityURL *qlt = [arrQuality lastObject];
        self.player.curTypeQuality = qlt.type;
        [self.player.view.btnHD setTitle:qlt.type forState:UIControlStateNormal];
        if ([qlt.type  containsString:@"720"] || [qlt.type  containsString:@"1080"]) {
            APPDELEGATE.nowPlayerVC.player.view.iconHD.hidden = NO;
        } else {
            APPDELEGATE.nowPlayerVC.player.view.iconHD.hidden = YES;
        }
        [self.player.view.popoverView dismissPopoverAnimated:YES];
    }
}

- (void)loadDataVideoIndex:(int)index{
    [_player.view hideControll];
    if (_currentVideo) {
        [self stopPlayer];
    }
    if (_typePlayer != typePlayerOffline) {
        _currentVideo = _prepairedVideo;
        NSArray *fileDownloads = [[DBHelper sharedInstance]getAllVideoDownloaded];
        NSArray *fileDownloading = [[DownloadManager sharedInstance]getListVideoDownload];
        NSMutableArray *arrayDownload = [[NSMutableArray alloc]init];
        [arrayDownload addObjectsFromArray:fileDownloads];
        [arrayDownload addObjectsFromArray:fileDownloading];
        [_player.view.btnDownload setImage:[UIImage imageNamed:@"icon-download-white-v2"] forState:UIControlStateNormal];
        [_btnDownload setImage:[UIImage imageNamed:@"icon-download-black-v2"] forState:UIControlStateNormal];
        for (FileDownloadInfo *file in arrayDownload) {
            if ([_currentVideo.video_id isEqualToString:file.videoDownload.video_id]) {
                [_player.view.btnDownload setImage:[UIImage imageNamed:@"icon-download-h-v2"] forState:UIControlStateNormal];
                [_btnDownload setImage:[UIImage imageNamed:@"icon-download-h-v2"] forState:UIControlStateNormal];
                break;
            } else {
                [_player.view.btnDownload setImage:[UIImage imageNamed:@"icon-download-white-v2"] forState:UIControlStateNormal];
                [_btnDownload setImage:[UIImage imageNamed:@"icon-download-black-v2"] forState:UIControlStateNormal];
            }
        }
    }
    [self changeStateHDTap:_isHD];
    [self showData:index];
    self.pageIndex = 1;
}

- (void)loadNewDataForVideoInSeason {
    if (_listSuggestFull) {
        [_listSuggestFull removeAllObjects];
    }
    if (_listSuggestShort) {
        [_listSuggestShort removeAllObjects];
    }
    self.pageIndex =1;
    [self loadVideoDetailWithLoadChannel:NO];
    [self loadVideoSuggestionShort];
    [self loadVideoSuggestionWithPageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:NO];
}
- (void)loadDataNewVideo {
    if (_listSuggestFull) {
        [_listSuggestFull removeAllObjects];
    }
    if (_listSuggestShort) {
        [_listSuggestShort removeAllObjects];
    }
    if (_listSeason) {
        [_listSeason removeAllObjects];
    }
    [self loadVideoDetailWithLoadChannel:YES];
    [self loadVideoSuggestionShort];
    self.pageIndex =1;
    [self loadVideoSuggestionWithPageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:NO];
    [_tbVideo scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [_tbSuggestion scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self loadSeasonDetail];
}
- (void)loadDataNewVideoSuggestion {
    [self loadDataNewVideo];
}

- (void)decordSubView {
    _imgChannel.layer.cornerRadius = _imgChannel.frame.size.width/2;
    _imgChannel.clipsToBounds = YES;
    
    _btnFollow.clipsToBounds = YES;
    _btnFollow.layer.cornerRadius = 10;
    _btnFollow.layer.borderWidth = 1.0;
    _btnFollow.layer.borderColor = UIColorFromRGB(0x00adef).CGColor;
}

- (void)updateRatingScoreOf:(Channel*)channel {
    _lblRating.text = [NSString stringWithFormat:@"%.01lf",channel.rating];
    _lblRatingCount.text = [NSString stringWithFormat:@"%ld lượt đánh giá",channel.totalUserRating];
    float rating = channel.rating*10;
    int ratingStep = 0;
    if (0 <= rating && rating < 3) {
        ratingStep = 0;
    } else if (8 <= rating && rating < 13) {
        ratingStep = 2;
    } else if (18 <= rating && rating < 23) {
        ratingStep = 4;
    } else if (28 <= rating && rating < 33) {
        ratingStep = 6;
    } else if (38 <= rating && rating < 43) {
        ratingStep = 8;
    }  else if (48 <= rating && rating <= 50) {
        ratingStep = 10;
    } else if (3 <= rating && rating < 8) {
        ratingStep = 1;
    }  else if (13 <= rating && rating < 18) {
        ratingStep = 3;
    } else if (23 <= rating && rating < 28) {
        ratingStep = 5;
    } else if (33 <= rating && rating < 38) {
        ratingStep = 7;
    } else if (43 <= rating && rating < 48) {
        ratingStep = 9;
    }
    _lblRatingText.textColor = UIColorFromRGB(0x212121);
    switch (ratingStep) {
        case 10:
            _imgStar1.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-full-v2"];
            _lblRatingText.text = @"Tuyệt vời";
            _lblRatingText.textColor = UIColorFromRGB(0xFF6029);
            break;
        case 9:
            _imgStar1.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-half-v2"];
            _lblRatingText.text = @"Hay quá";
            _lblRatingText.textColor = UIColorFromRGB(0x8BC34A);
            break;
        case 8:
            _imgStar1.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-line-v2"];
            _lblRatingText.text = @"Hay quá";
            _lblRatingText.textColor = UIColorFromRGB(0x8BC34A);
            break;
        case 7:
            _imgStar1.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-half-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-line-v2"];
            _lblRatingText.text = @"Bình thường";
            break;
        case 6:
            _imgStar1.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-line-v2"];
            _lblRatingText.text = @"Bình thường";
            break;
        case 5:
            _imgStar1.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-half-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-line-v2"];
            _lblRatingText.text = @"Không hay lắm";
            break;
        case 4:
            _imgStar1.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-line-v2"];
            _lblRatingText.text = @"Không hay lắm";
            break;
        case 3:
            _imgStar1.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-half-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-line-v2"];
            _lblRatingText.text = @"Dở tệ";
            break;
        case 2:
            _imgStar1.image = [UIImage imageNamed:@"star-full-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-line-v2"];
            _lblRatingText.text = @"Dở tệ";
            break;
        case 1:
            _imgStar1.image = [UIImage imageNamed:@"star-half-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-line-v2"];
            _lblRatingText.text = @"Dở tệ";
            break;
        case 0:
            _imgStar1.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar2.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar3.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar4.image = [UIImage imageNamed:@"star-line-v2"];
            _imgStar5.image = [UIImage imageNamed:@"star-line-v2"];
            _lblRatingText.text = @"Đánh giá";
            break;
        default:
            break;
    }
}
- (void)updateChannelInfo {
    if (_curChannel) {
        _lblChannelBody.text = _curChannel.channelName;
        _lblFollowCount.text = [NSString stringWithFormat:@"%@ lượt theo dõi",[Utilities convertToStringFromCount:_curChannel.totalFollow]];
        [_imgChannel setImageWithURL:[NSURL URLWithString:_curChannel.thumb] placeholderImage:[UIImage imageNamed:kDefault_Video_Img]];
        if (_curChannel.isSubcribe) {
            [_btnFollow setTitle:@"Đã theo dõi" forState:UIControlStateNormal];
            [_btnFollow setTitleColor:UIColorFromRGB(0xFC1D00) forState:UIControlStateNormal];
            _btnFollow.layer.borderColor = [UIColorFromRGB(0xFC1D00)CGColor];
        } else {
            [_btnFollow setTitle:@"Theo dõi" forState:UIControlStateNormal];
            [_btnFollow setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
            _btnFollow.layer.borderColor = UIColorFromRGB(0x00adef).CGColor;
        }
        [self updateRatingScoreOf:_curChannel];
    }
}

- (void)updateVideoInfoWithLoadChannel:(BOOL)isLoadChannel {
    if (_currentVideo) {
        if (isLoadChannel) {
            Channel *cn = (Channel*)[_currentVideo.channels firstObject];
            [self loadChannelDetail:cn.channelId];
        }
        _lblVideoName.text = _currentVideo.video_subtitle;
        NSString *view = [Utilities convertToStringFromCount:_currentVideo.viewCount];
        NSString *time = [Utilities stringRelatedDateFromMiliseconds:_currentVideo.dateCreated/1000];
        _lblViewCount.text = [NSString stringWithFormat:@"%@ lượt xem - %@",view,time];
        if (APPDELEGATE.isLogined) {
            [APPDELEGATE.nowPlayerVC.player.view.btnLike setImage:_currentVideo.is_like?[UIImage imageNamed:@"icon-xemsau-h-v2-1"]:[UIImage imageNamed:@"icon-xemsau-white-v2"] forState:UIControlStateNormal];
            [_btnViewLater setImage:_currentVideo.is_like?[UIImage imageNamed:@"icon-xemsau-h-v2-1"]:[UIImage imageNamed:@"icon-xemsau-black-v2"] forState:UIControlStateNormal];
        } else {
            _currentVideo.is_like = NO;
            _curChannel.isSubcribe = NO;
            [APPDELEGATE.nowPlayerVC.player.view.btnLike setImage:[UIImage imageNamed:@"icon-xemsau-white-v2"] forState:UIControlStateNormal];
            [_btnViewLater setImage:[UIImage imageNamed:@"icon-xemsau-black-v2"] forState:UIControlStateNormal];
            [_btnFollow setTitle:@"Theo dõi" forState:UIControlStateNormal];
            [_btnFollow setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
            _btnFollow.layer.borderColor = UIColorFromRGB(0x00adef).CGColor;
        }
    }
}

- (void)loadDataOffile {
    NSArray *arrayDownload = [[DBHelper sharedInstance] getAllVideoDownloaded];
    _listDownloaded = (NSMutableArray*)[[arrayDownload reverseObjectEnumerator] allObjects];
    [_tbVideo reloadData];
}

- (void)loadVideoDetailWithLoadChannel:(BOOL)isLoadChannel {
    if (_currentVideo) {
        [[APIController sharedInstance]getVideoDetailWithKey:_currentVideo.video_id completed:^(int code, Video *results) {
            if (results) {
                BOOL loadSeason = _currentVideo.seasonKey ? NO:YES;
                VideoStream *stream = _currentVideo.videoStream;
                _currentVideo = results;
                _currentVideo.videoStream = stream;
                if (loadSeason) {
                    [self loadSeasonDetail];
                }
                [self updateVideoInfoWithLoadChannel:isLoadChannel];
            }
        } failed:^(NSError *error) {
            
        }];
    }
}
- (void)loadChannelDetail:(NSString*)channelId {
    [[APIController sharedInstance] getChannelDetailWithKey:channelId completed:^(int code, Channel *results) {
        if (results) {
            _curChannel = results;
            [self logGenre];
            [self updateChannelInfo];
            [self loadPlaylist];
        }
    } failed:^(NSError *error) {
        NSLog(@"error: %@",[error description]);
    }];
}

- (void)logGenre:(NSString*)genreId {
    [[APIController sharedInstance]logViewedWithObjectId:genreId type:@"GENRE" completed:^(BOOL result) {
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)logGenre {
    if (_curChannel.genres.count) {
        for (Genre *genre in _curChannel.genres) {
            if ([genre.parentKey isEqualToString:@""]) {
                [self logGenre:genre.genreId];
            }
        }
    }
}

- (void)loadPlaylist {
    if (_curChannel.seasons) {
        if (scrollView) {
            [scrollView removeFromSuperview];
            scrollView = nil;
        }
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, _playlistView.frame.size.height)];
        CGFloat x = 0;
        CGFloat w = SCREEN_SIZE.width*2/5;
        for (int i = 0; i < _curChannel.seasons.count; i++) {
            Season *ss = [_curChannel.seasons objectAtIndex:i];
            x = i*w;
            PlaylistItemView *item = [[PlaylistItemView alloc]initWithFrame:CGRectMake(x, 0, w, scrollView.frame.size.height)];
            item.season = ss;
            [item loadContentSeason];
            if ([[ss.seasonId description] isEqualToString:[_currentVideo.seasonKey description]]) {
                item.selected = YES;
            } else {
                item.selected = NO;
            }
            item.delegate = self;
            [scrollView addSubview:item];
        }
        [scrollView setContentSize:CGSizeMake(w*_curChannel.seasons.count, scrollView.frame.size.height)];
        [_playlistView addSubview:scrollView];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [_playlistView addSubview:lineView];
    }
}

- (void)loadDataFromNewSeason:(Season*)season {
    _season = season;
    [[APIController sharedInstance]getSeasonDetailWithKey:_season.seasonId completed:^(int code, Season *result) {
        if (season) {
            _season = result;
            if (_season.videosCount == 1) {
                _player.view.btnNext.hidden = YES;
                _player.view.btnPrevious.hidden = YES;
            }
            _lblChannelNameHeader.text = _season.seasonName;
            if (_season.videosCount > 0) {
                Video *v = [_season.videos firstObject];
                
//                _prepairedVideo = v;
                [self loadStreamVideo:v];
                //[self loadVideoDetailWithLoadChannel:NO];
                _curIndexVideoChoose = 0;
                _lblVideoOrder.text = [NSString stringWithFormat:@"%d/%d",(int)_curIndexVideoChoose+1,(int)season.videosCount];
                [_tbVideo reloadData];
            }
        }
        //            [self dismissHUD];
    } failed:^(NSError *error) {
        //            [self dismissHUD];
    }];
}

- (void)loadStreamVideo:(Video*)video {
    [[APIController sharedInstance]getVideoStreamWithKey:video.video_id completed:^(int code, VideoStream *results) {
        if (results) {
            video.videoStream = results;
            APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
            APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
            [APPDELEGATE playerLoadDataWithType:@"NEW_SEASON" video:video channel:nil index:0];
        }
        //[self dismissHUD];
    } failed:^(NSError *error) {
        //[self dismissHUD];
    }];
}

- (void)loadNewSeason {
    if (_listSuggestFull) {
        [_listSuggestFull removeAllObjects];
    }
    if (_listSuggestShort) {
        [_listSuggestShort removeAllObjects];
    }
    self.pageIndex =1;
    [self loadVideoDetailWithLoadChannel:NO];
    //[self updateVideoInfoWithLoadChannel:NO];
    self.pageIndex =1;
    [self loadVideoSuggestionShort];
    [_listSuggestFull removeAllObjects];
    [self loadVideoSuggestionWithPageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:NO];
}

- (void)loadSeasonDetail {
    if (_currentVideo.seasonKey) {
        //[self showProgressHUDWithTitle:nil];
        [[APIController sharedInstance]getSeasonDetailWithKey:_currentVideo.seasonKey completed:^(int code, Season *season) {
            if (season) {
                _season = season;
                _lblChannelNameHeader.text = season.seasonName;
                for (UIView *view in scrollView.subviews) {
                    if ([view isKindOfClass:[PlaylistItemView class]]) {
                        PlaylistItemView *item = (PlaylistItemView*)view;
                        if ([item.season.seasonId isEqualToString:_currentVideo.seasonKey]) {
                            item.selected = YES;
                            break;
                        }
                    }
                }
                if (season.videos.count > 0) {
                    for (int i = 0; i < season.videos.count; i++) {
                        Video *v = (Video*)[season.videos objectAtIndex:i];
                        if ([v.video_id isEqualToString:_currentVideo.video_id]) {
                            self.player.view.chooseVideo.curIndexVideoChoose = _curIndexVideoChoose = i;
                            _lblVideoOrder.text = [NSString stringWithFormat:@"%d/%d",(int)_curIndexVideoChoose+1,(int)season.videosCount];
                        }
                    }
                    [self updatePre_NextBtnsWithIndex:_curIndexVideoChoose];
                    _collectionVideo.hidden = YES;
                    _tbVideo.hidden = NO;
                    [_tbVideo reloadData];
                    
                }
            }
//            [self dismissHUD];
        } failed:^(NSError *error) {
//            [self dismissHUD];
        }];
    }
}

- (void)loadVideoSuggestionWithPageIndex:(int)pageIndex pageSize:(int)pageSize showLoading:(BOOL)isShowLoading{
    if (_currentVideo) {
        if (APPDELEGATE.internetConnnected) {
            if (isShowLoading) {
                //[self showProgressHUDWithTitle:nil];
            }
            [[APIController sharedInstance]getVideoSuggestionWithKey:_currentVideo.video_id pageIndex:pageIndex pageSize:kDefaultPageSize completed:^(int code, NSArray *results, BOOL loadmore, int total) {
                if (results) {
                    if (!self.listSuggestFull) {
                        self.listSuggestFull = (NSMutableArray*)results;
                    } else {
                        [self.listSuggestFull addObjectsFromArray:results];
                    }
                    self.isLoadMore = loadmore;
                    if (loadmore) {
                        self.pageIndex = self.pageIndex + 1;
                    }
                    [self.tbSuggestion reloadData];
                }
                [self dismissHUD];
                [self loadEmptyData];
            } failed:^(NSError *error) {
                [self dismissHUD];
            }];
        } else {
            //[self showConnectionErrorView:NO offsetY:0];
        }
    }
}
- (void)loadVideoSuggestionShort {
    if (_currentVideo) {
        if (APPDELEGATE.internetConnnected) {
            [[APIController sharedInstance]getVideoSuggestionWithKey:_currentVideo.video_id pageIndex:1 pageSize:kDefaultPageSize completed:^(int code, NSArray *results, BOOL loadmore, int total) {
                if (results) {
                    self.listSuggestShort = (NSMutableArray*)results;
                    [self.tbInfo reloadData];
                }
                [self dismissHUD];
                [self loadEmptyData];
            } failed:^(NSError *error) {
                [self dismissHUD];
            }];
        } else {
            //[self showConnectionErrorView:NO offsetY:0];
        }
    }
}


- (void)loadDataWithChannel:(Channel*)channel {
    _curChannel = channel;
    [self updateChannelInfo];
    [self loadPlaylist];
}

- (void)showData:(NSInteger)index{
    NSArray *arrayQualities = _currentVideo.videoStream.streamUrls;
    QualityURL *curQuality = nil;
    if (arrayQualities.count > 0) {
        if (_isHD) {
            if (arrayQualities.count > 1) {
                curQuality = (QualityURL*)[arrayQualities lastObject];
                _player.view.isHadHD = YES;
            } else {
                curQuality = (QualityURL*)[arrayQualities firstObject];
                _player.view.isHadHD = NO;
            }
        } else {
            if (arrayQualities.count > 1) {
                curQuality = (QualityURL*)[arrayQualities lastObject];
                _player.view.isHadHD = YES;
            } else {
                curQuality = (QualityURL*)[arrayQualities firstObject];
                _player.view.isHadHD = NO;
            }
        }
        _currentVideo.stream_url = curQuality.link;
        [self playVideoWithURL:curQuality.link];
        [self updatePre_NextBtnsWithIndex:index];
        [[APIController sharedInstance]logPlayededVideoId:_currentVideo.video_id completed:^(BOOL result) {}failed:^(NSError *error) {}];
    }
}

- (void)updatePre_NextBtnsWithIndex:(NSInteger)index {
    if (_season.videos) {
        _curIndexVideoChoose = index;
        if (_season.videosCount == 1) {
            _player.view.btnNext.hidden = YES;
            _player.view.btnPrevious.hidden = YES;
        } else {
            if (_curIndexVideoChoose == 0) {
                _player.view.btnPrevious.hidden = YES;
                _player.view.btnNext.hidden = NO;
            } else if (_curIndexVideoChoose == _season.videos.count - 1){
                _player.view.btnPrevious.hidden = NO;
                _player.view.btnNext.hidden = YES;
            } else {
                _player.view.btnPrevious.hidden = NO;
                _player.view.btnNext.hidden = NO;
            }
        }
    }
}

- (void)playVideoWithURL:(NSString*)link{
    if (self.player) {
        //_player.view.isLockControll = YES;
        if (self.player.view.isShowMore) {
            [_player.view handleSingleTap:nil];
        }
        [self.player setURL:[NSURL URLWithString:link]];
        if (_typePlayer == typePlayerOffline) {
            self.player.view.btnLike.hidden = YES;
            self.player.view.btnDownload.hidden = YES;
            self.player.view.btnShare.hidden = YES;
        } else {
            self.player.view.btnLike.hidden = NO;
            self.player.view.btnDownload.hidden = NO;
            self.player.view.btnShare.hidden = NO;
        }
    }
}

- (NSMutableArray *)pages
{
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        for (NSLayoutConstraint *constraint in _infoView.constraints) {
            if (([constraint.firstItem isEqual:_btnViewLater] && [constraint.secondItem isEqual:_btnDownload] && constraint.constant == 27) || ([constraint.firstItem isEqual:_btnDownload] && [constraint.secondItem isEqual:_btnShare] && constraint.constant == 27)) {
                constraint.constant = 20;
                [_infoView setNeedsLayout];
                [_infoView layoutIfNeeded];
            }
        }
    }
    if (!isReload) {
        isReload = YES;
        self.mainView.frame = CGRectMake(0,height_player, SCREEN_WIDTH, SCREEN_SIZE.height - height_player);
        self.tbSuggestion.frame = CGRectMake(0, _contentContainer.frame.size.height, SCREEN_SIZE.width, _contentContainer.frame.size.height);
    }
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myDealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangeModeScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadVideoCurrentNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.player) {
        [self.player myDealloc];
        self.player = nil;
    }
}


#pragma mark - Callback

- (IBAction)btnHideDownloadView_Tapped:(id)sender {
    QualityURL *qlt = [_quality copy];
    [self downloadCurrentVideoWithQuality:qlt];
}

- (BOOL) isAllow3G{
    if ([kNSUserDefault valueForKey:SETTING_ALLOW3G] && [[kNSUserDefault valueForKey:SETTING_ALLOW3G] boolValue]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)downloadCurrentVideoWithQuality:(QualityURL*)quality {
    _quality = quality;
    if (![self isAllow3G] && !isAllowCellcular && APPDELEGATE.connectionType != kConnectionTypeWifi) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn đã chuyển qua chế độ 2G/3G, có tiếp tục tải không?" delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles:@"Tiếp tục", nil];
        alert.tag = 111;
        [alert show];
        return;
    }
    [_btnDownload setImage:[UIImage imageNamed:@"icon-download-h-v2"] forState:UIControlStateNormal];
    [_player.view.btnDownload setImage:[UIImage imageNamed:@"icon-download-h-v2"] forState:UIControlStateNormal];
    [[DownloadManager sharedInstance] downloadVideo:_currentVideo withQuality:quality completion:^(DownloadManagerCode code) {
        if (code == DownloadManagerCodeFileIsNull) {
            NSString *mess = @"Không tìm thấy link tải về.";
            [APPDELEGATE showToastWithMessage:mess position:@"top" type:errorImage];
            return;
        }
        if (code == DownloadManagerCodeFileExists) {
            NSString *mess = @"Video đang được tải về.";
            [APPDELEGATE showToastWithMessage:mess position:@"top" type:errorImage];
            return;
        }
        if(code == DownloadManagerCodeFileDownloaded){
            NSString *mess = @"Video đã được tải về.";
            [APPDELEGATE showToastWithMessage:mess position:@"top" type:errorImage];
            return;
        }
        if(code == DownloadManagerCodeAddFinished){
            _currentVideo.type_quality = quality.type;
            _currentVideo.link_down = quality.link;
            NSString *mess = @"Video đã thêm vào danh sách tải về.";
            [APPDELEGATE showToastWithMessage:mess position:@"top" type:doneImage];
            return;
        }
        if(code == DownloadManagerCodeDoNotAllowDownload){
            NSString *mess = @"Do yêu cầu của đơn vị sở hữu bản quyền, hiện không cho phép tải video này!";
            [APPDELEGATE showToastMessage:mess];
            return;
        }
    }];
    return;
}

- (void)downloadCurrentVideo:(NSNotification *)notif {
    NSDictionary *dict = [notif userInfo];
    if ([dict objectForKey:@"qualityDownload"]) {
        QualityURL *quality =(QualityURL*)[dict objectForKey:@"qualityDownload"];
        [self downloadCurrentVideoWithQuality:quality];
    }
}
- (void)didDownloadedVideo: (NSNotification*)notif {
    if (_typePlayer == typePlayerOffline) {
        if (_isShowNowPlaying) {
            NSArray *arrayDownload = [[DBHelper sharedInstance] getAllVideoDownloaded];
            _listDownloaded = (NSMutableArray*)arrayDownload;
            BOOL isExist = NO;
            for (FileDownloadInfo *file in _listDownloaded) {
                if ([_currentVideo isEqualToVideo:file.videoDownload]) {
                    _curIndexVideoChoose = [_listDownloaded indexOfObject:file];
                    isExist = YES;
                    break;
                }
            }
            if (!isExist) {
                _curIndexVideoChoose = -1;
                //[self.player stop];
            }
            [_tbVideo reloadData];
        }
    }
}

#pragma mark - npvideoplayer delegate
-(BOOL)canPlayNextItem{
    NSInteger index = _curIndexVideoChoose + 1;
    if (index > _season.videos.count - 1) {
        return NO;
    }
    return YES;
}

- (void)playNextItem{
    if (_currentVideo) {
        [self stopPlayer];
    }
    if (_season) {
        _player.view.btnPrevious.hidden = NO;
        _curIndexVideoChoose++;
        APPDELEGATE.nowPlayerVC.player.view.chooseVideo.curIndexVideoChoose++;
        _lstVideo = _season.videos;
        if (_curIndexVideoChoose > _lstVideo.count - 1) {
            return;
        } else if (_curIndexVideoChoose == _lstVideo.count - 1) {
            _player.view.btnNext.hidden = YES;
        }
        if (_lstVideo.count > _curIndexVideoChoose) {
            Video *video = [_lstVideo objectAtIndex:_curIndexVideoChoose];
            [[APIController sharedInstance] getVideoStreamWithKey:video.video_id completed:^(int code, VideoStream *results) {
                if (results) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:kDidPlayNextVideo object:nil];
                    video.videoStream = results;
                    _prepairedVideo = video;
                    [self loadDataVideoIndex:(int)_curIndexVideoChoose];
                    [self loadNewDataForVideoInSeason];
                    _lblVideoOrder.text = [NSString stringWithFormat:@"%d/%d",(int)_curIndexVideoChoose+1,(int)_season.videosCount];
                    [_tbVideo reloadData];
                    [APPDELEGATE.nowPlayerVC.player.view.chooseVideo.tbVideo reloadData];
                }
            } failed:^(NSError *error) {
                
            }];
        }
    }
    
//    [self playVideoWithURL:nil];
}

-(BOOL)canPlayPreItem{
    NSInteger index = _curIndexVideoChoose - 1;
    if (index > _season.videos.count - 1 || index < 0) {
        return NO;
    }
    return YES;
}

-(void)playPreItem{
    if (_currentVideo) {
        [self stopPlayer];
    }
    _player.view.btnNext.hidden = NO;
    _curIndexVideoChoose--;
    APPDELEGATE.nowPlayerVC.player.view.chooseVideo.curIndexVideoChoose--;
    if (_curIndexVideoChoose > _season.videos.count - 1 || _curIndexVideoChoose < 0) {
        return;
    } else if (_curIndexVideoChoose == 0){
        _player.view.btnPrevious.hidden = YES;
    }
    Video *video = [_season.videos objectAtIndex:_curIndexVideoChoose];
    [[APIController sharedInstance] getVideoStreamWithKey:video.video_id completed:^(int code, VideoStream *results) {
        if (results) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kDidPlayNextVideo object:nil];
            video.videoStream = results;
            _prepairedVideo = video;
            [self loadDataVideoIndex:(int)_curIndexVideoChoose];
            [self loadNewDataForVideoInSeason];
            _lblVideoOrder.text = [NSString stringWithFormat:@"%d/%d",(int)_curIndexVideoChoose+1,(int)_season.videosCount];
            [_tbVideo reloadData];
            [APPDELEGATE.nowPlayerVC.player.view.chooseVideo.tbVideo reloadData];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)didLoginNotification {
    self.mainView.frame = CGRectMake(0,height_player, SCREEN_WIDTH, SCREEN_SIZE.height - height_player);
    [self.mainView setNeedsLayout];
    [self.mainView layoutIfNeeded];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
}

- (void)willEnterForeground {
    if (!self.player.view.isMinimize) {
        [self.player.view setControlsHidden:NO autoHide:YES];
    }
}

-(void)showPlayer:(BOOL)show withAnimation:(BOOL)animated{
    [APPDELEGATE addNowPlayingViewController];

    if (!APPDELEGATE.nowPlayerVC.player.view.isFullScreen) {
        [APPDELEGATE.nowPlayerVC.player.view.btnZoom setImage:[UIImage imageNamed:@"icon-zoom-out-press"] forState:UIControlStateHighlighted];
        [APPDELEGATE.nowPlayerVC.player.view.btnZoom setImage:[UIImage imageNamed:@"icon-zoom-out"] forState:UIControlStateNormal];
    }else{
        [APPDELEGATE.nowPlayerVC.player.view.btnZoom setImage:[UIImage imageNamed:@"icon-zoom-in-press"] forState:UIControlStateHighlighted];
        [APPDELEGATE.nowPlayerVC.player.view.btnZoom setImage:[UIImage imageNamed:@"icon-zoom-in"] forState:UIControlStateNormal];
    }
    _tbInfo.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.typePlayer != typePlayerOffline) {
        _btnMiniInfo.enabled = NO;
        [_tbInfo scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [UIView animateWithDuration:0.0 animations:^{
            _tbInfo.frame = originScrollView ;
            _iconMini.transform = CGAffineTransformMakeRotation(1 * (M_PI/180));
        } completion:^(BOOL finished) {
            isMiniInfo = !isMiniInfo;
            for (NSLayoutConstraint *topContraint in _contentContainer.constraints) {
                if ( [topContraint.firstItem isEqual:_tbInfo] && [topContraint.secondItem isEqual:_header] && topContraint.firstAttribute == NSLayoutAttributeTop && topContraint.secondAttribute == NSLayoutAttributeBottom) {
                    topContraint.constant = 0;
                    [_contentContainer setNeedsLayout];
                    [_contentContainer layoutIfNeeded];
                    break;
                }
            }
            for (NSLayoutConstraint *topContraint in _contentContainer.constraints) {
                if ( [topContraint.firstItem isEqual:_tbVideo] && [topContraint.secondItem isEqual:_headeView] && topContraint.firstAttribute == NSLayoutAttributeTop && topContraint.secondAttribute == NSLayoutAttributeBottom) {
                    topContraint.constant = 0;
                    [_contentContainer setNeedsLayout];
                    [_contentContainer layoutIfNeeded];
                    break;
                }
            }
            _btnMiniInfo.enabled = YES;
        }];
        if (isShowSuggestion) {
            [UIView animateWithDuration:0.0 animations:^{
                self.tbSuggestion.frame = CGRectMake(0, _contentContainer.frame.size.height, SCREEN_SIZE.width, _contentContainer.frame.size.height);
            } completion:^(BOOL finished) {
                isShowSuggestion = NO;
            }];
        }
    } else {
        for (NSLayoutConstraint *topContraint in _contentContainer.constraints) {
            if ( [topContraint.firstItem isEqual:_tbVideo] && [topContraint.secondItem isEqual:_headeView] && topContraint.firstAttribute == NSLayoutAttributeTop && topContraint.secondAttribute == NSLayoutAttributeBottom) {
                topContraint.constant = - _headeView.frame.size.height - _header.frame.size.height;
                [_contentContainer setNeedsLayout];
                [_contentContainer layoutIfNeeded];
                break;
            }
        }
    }
    
    if (_isAnimation) {
        // KNN cmt
        return;
    }
    if (show) {
        if (self.player.view.isMinimize) {
            [self.player.view youtubeAnimationMaximize:YES];
            return;
        } 
        _isAnimation = YES;
        UIView *overView = [self.view viewWithTag:100];
        UIView *mainView = [self.view viewWithTag:200];
        UIView *playerView = [self.view viewWithTag:300];
        overView.alpha = 0.0f;
        mainView.alpha = 0.0f;
        playerView.frame = CGRectMake(0, ORIGIN_Y, SCREEN_WIDTH, height_player);
        CGRect fromFrame = CGRectMake(SCREEN_SIZE.width, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
        self.view.frame = fromFrame;
        
        CGRect toFrame = [[UIScreen mainScreen] bounds];
        float animDuration = animated ? 0.3f : 0.0f;
        [UIView animateWithDuration:animDuration delay:0.0f options:0 animations:^{
            self.view.frame = toFrame;
            self.view.alpha = 1.0f;
            overView.alpha = 1.0f;
            mainView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if (finished) {
                _isAnimation = NO;
                _isShowNowPlaying = YES;
                [APPDELEGATE addNowPlayingViewController];
            }
        }];
    }else {
        _isAnimation = YES;
        UIView *overView = [self.view viewWithTag:100];
        UIView *mainView = [self.view viewWithTag:200];
        self.view.alpha = 1.0f;
        overView.alpha = 1.0f;
        mainView.alpha = 1.0f;
        
        CGRect fromFrame = [[UIScreen mainScreen] bounds];
        self.view.frame = fromFrame;
        CGRect toFrame = CGRectMake(SCREEN_SIZE.width, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
        float animDuration = animated ? 0.3f : 0.0f;
        [UIView animateWithDuration:animDuration delay:0.0f options:0 animations:^{
            self.view.frame = toFrame;
            overView.alpha = 0.0f;
            mainView.alpha = 0.0f;
            _isAnimation = NO;
        } completion:^(BOOL finished) {
            if (finished) {
                _isAnimation = NO;
                _isShowNowPlaying = NO;
                [APPDELEGATE removeNowPlayingViewController];
            }
        }];
    }
    
    if(![[[kNSUserDefault dictionaryRepresentation] allKeys] containsObject:@"coachmark_chitiet"]){
        
        UIImageView *cm = [APPDELEGATE.nowPlayerVC.view viewWithTag:901];
        
        if (!cm) {
            cm = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
            [APPDELEGATE.nowPlayerVC.view addSubview:cm];
        }
        
        [cm setTag:901];
        NSString *nameCM = @"";
        if (IS_IPHONE_4_OR_LESS) {
            nameCM = @"coachmark-chitiet-ip4.png";
        } else if (IS_IPHONE_5) {
            nameCM = @"coachmark-chitiet-ip5.png";
        } else if (IS_IPHONE_6){
            nameCM = @"coachmark-chitiet-ip6.png";
        } else if (IS_IPHONE_6P) {
            nameCM = @"coachmark-chitiet-ip6p.png";
        } else {
            nameCM = @"coachmark-chitiet-ip6.png";
        }
        
        [cm setImage:[UIImage imageNamed:nameCM]];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        singleTap.numberOfTapsRequired = 1;
        [cm setUserInteractionEnabled:YES];
        [cm addGestureRecognizer:singleTap];
    }
}
-(void)tapDetected{
    [kNSUserDefault setObject:@"YES" forKey:@"coachmark_chitiet"];
    [kNSUserDefault synchronize];
    UIImageView *cm = [APPDELEGATE.nowPlayerVC.view viewWithTag:901];
    if ([cm isKindOfClass:[UIImageView class]]) {
        [cm removeFromSuperview];
        cm = nil;
    }
}
- (void) playWithVideo:(Video*)video{
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateIndexVideoNotification object:nil userInfo:@{@"index": [NSNumber numberWithInteger:_curIndexVideoChoose]}];
    _currentVideo = video;
    NSString *assetStr = video.stream_url;
    _player.view.lbTitle.text = _currentVideo.video_subtitle;
    APPDELEGATE.nowPlayerVC.lblVideoNameOffline.text = _currentVideo.video_subtitle;
    Video *videoOffline = [[DBHelper sharedInstance] videoIsDownloaded:video.video_id withQuality:video.type_quality];
    if (videoOffline) {
        assetStr = videoOffline.stream_url;
        [ParserObject getExistContentSubTitleOffline:video _completed:^(NSString *str, NSError *error){
            _subtitle = str;
        }];
    }
    static BOOL isCheckLike = NO;
    isCheckLike = NO;
    [self playVideoWithURL:assetStr];
    [_tbVideo reloadData];
}


- (void)getSubtitleWithVideo:(Video *)v _completed:(void(^)(NSString *str, NSError *error))completed {
    if (v.isHadSubtitle) {
        [[APIController sharedInstance] getSubtitleWithWideoKey:v.video_id completed:^(NSArray *array){
            SubTitle *sub = [array lastObject];
            if ([ParserObject checkExistSub:sub.subtitle_id]) {
                [ParserObject getExistContentSubTitle:sub ofVideo:v _completed:^(NSString *str, NSError *error){
                    if (error) {
                        completed(nil,error);
                    } else {
                        completed(str, nil);
                    }
                }];
            }else {
                [ParserObject saveSubTitleAndLoadFile:sub _completed:^(NSString *str, NSError *error){
                    if (error) {
                        completed(nil, error);
                    } else {
                        completed(str, nil);
                    }
                }];
            }
            
        }failed:^(NSError *error){
            // handle error
        }];
        
    } else {
        APPDELEGATE.nowPlayerVC.subtitle = nil;
        _currentVideo = v;
        [self.player setLikeForCurrentVideo:v.is_like];
    }
}

-(Video *)getCurrentVideo{
    return _currentVideo;
}
- (NSString*)getLinkOfVideo:(Video *)video {
    if (video.videoStream) {
        NSArray *arrayQualities = video.videoStream.streamUrls;
        if (arrayQualities.count < 1) {
            return  nil;
        }
        QualityURL *curQuality = nil;
        if (arrayQualities.count > 0) {
            _isHD = !_isHD;
            if (_isHD) {
                curQuality = (QualityURL*)[arrayQualities lastObject];
            } else {
                curQuality = (QualityURL*)[arrayQualities firstObject];
            }
        }
        return curQuality.link;
    } else {
        return nil;
    }
}

- (NSString*)getDownloadLinkOfVideoIsHD:(BOOL)isHD video:(Video*)video {
    if (video.videoStream) {
        NSArray *arrayQualities = video.videoStream.streamDownloads;
        if (arrayQualities.count == 0) {
            return  nil;
        }
        QualityURL *curQuality = nil;
        if (arrayQualities.count > 0) {
            if (isHD) {
                curQuality = (QualityURL*)[arrayQualities lastObject];
            } else {
                curQuality = (QualityURL*)[arrayQualities firstObject];
            }
        }
        return curQuality.link;
    } else {
        return nil;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111 && buttonIndex == 1) {
        isAllowCellcular = YES;
        //QualityURL *qlt = [_quality copy];
        [self downloadCurrentVideoWithQuality:_quality];
    }else if(alertView.tag == 222 && buttonIndex == 1){
        isAllowCellcular = YES;
    }
    _curIndexDownload = -1;
}

-(void)presentViewFromPlayer:(BOOL)isPresent{
    static BOOL resume = NO;
    BOOL isPlay = [self.player isPlaying];
    if (isPlay && isPresent) {
        [self.player pause];
        resume = YES;
    }else if(resume){
        [self.player play];
        resume = NO;
    }
    [self.player.view hideControll];
}

#pragma mark - Button Action

- (IBAction)btnDownloadTapped:(id)sender {
    [APPDELEGATE.nowPlayerVC trackEvent:@"iOS_video_download"];
    
    if ([[DownloadManager sharedInstance] videoIsDownloaded:_currentVideo withQuality:_quality]) {
        NSString *mess = @"Đã được tải về.";
        [APPDELEGATE showToastWithMessage:mess position:@"top" type:errorImage];
        return;
    }
    if ([[DownloadManager sharedInstance] videoIsInListDownloading:_currentVideo]) {
        NSString *mess = @"Đang được tải về.";
        [APPDELEGATE showToastWithMessage:mess position:@"top" type:errorImage];
        return;
    }
    
     NSArray *arrayDownloadStream = _currentVideo.videoStream.streamDownloads;
    NSMutableArray *arrayTitle = [[NSMutableArray alloc]init];
    for (QualityURL *qlt in arrayDownloadStream) {
        [arrayTitle addObject:qlt.type];
    }
    if (arrayTitle.count > 0) {
        MoreOptionView *moreOptionView = [[MoreOptionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) type:6 object:_currentVideo linkShare:_currentVideo.link_share numOfItem:(int)arrayTitle.count arrayTitle:(NSArray*)arrayTitle];
        moreOptionView.delegate = self;
        [APPDELEGATE.window addSubview:moreOptionView];
    }
}
- (IBAction)btnLikeTapped:(id)sender {
    [_player btnLike_Tapped];
}

- (IBAction)btnShareTapped:(id)sender {
    [_player btnShare_Tapped];
}
- (IBAction)btnFollowTapped:(id)sender {
    [self trackEvent:@"iOS_channel_follow"];
    if (APPDELEGATE.isLogined) {
        if (_curChannel.isSubcribe) {
            [APPDELEGATE showToastWithMessage:@"Bạn đã theo dõi kênh này!" position:@"top" type:errorImage];
            return;
        }
        [[APIController sharedInstance] userSubcribeChannel:_curChannel.channelId subcribe:YES completed:^(int code, BOOL results) {
            if (results) {
                _curChannel.isSubcribe = YES;
                [_btnFollow setTitle:@"Đã theo dõi" forState:UIControlStateNormal];
                [_btnFollow setTitleColor:UIColorFromRGB(0xFC1D00) forState:UIControlStateNormal];
                _btnFollow.layer.borderColor = [UIColorFromRGB(0xFC1D00)CGColor];
                [APPDELEGATE showToastWithMessage:@"Đã thêm vào danh sách theo dõi" position:@"top" type:doneImage];
                [[NSNotificationCenter defaultCenter]postNotificationName:kDidSubcribeChannel object:nil];
            } else {
                [APPDELEGATE showToastWithMessage:@"Theo dõi không thành công!" position:@"top" type:errorImage];
            }
        } failed:^(NSError *error) {
            
        }];
    } else {
        [_player showLoginViewWithTask:kTaskFolow];
    }
    
}
- (IBAction)btnChannelTapped:(id)sender {
    [self trackEvent:@"iOS_channel_play_recommend_channel"];
    DetailController *detailChannelVC = [[DetailController alloc]initWithNibName:@"DetailController" bundle:nil];
    detailChannelVC.channel = _curChannel;
    detailChannelVC.hidesBottomBarWhenPushed = YES;
    if (APPDELEGATE.nowPlayerVC.isShowNowPlaying) {
        [[APPDELEGATE nowPlayerVC].player.view youtubeAnimationMinimize:YES];
        [[APPDELEGATE nowPlayerVC].player.view hideControll];
    }
    [APPDELEGATE.rootNavController.topViewController.navigationController pushViewController:detailChannelVC animated:YES];
    [[APIController sharedInstance]logViewedWithObjectId:_curChannel.channelId type:@"CHANNEL" completed:^(BOOL result) {
        
    } failed:^(NSError *error) {
        
    }];
}

- (IBAction)btnRatingTapped:(id)sender {
    [self trackEvent:@"iOS_channel_rating"];
    if (APPDELEGATE.isLogined) {
        //isShowRating = YES;
        RatingView *view = [Utilities loadView:[RatingView class] FromNib:@"RatingView"];
        [view loadView];
        view.delegate = self;
        [self.view addSubview:view];
        
    } else {
        [_player showLoginViewWithTask:kTaskRating];
    }
}

#pragma mark - RatingView Delegate
- (void)didSubmitRatingValue:(float)value {
    [APPDELEGATE.nowPlayerVC trackEvent:@"iOS_channel_rating"];
    _score = (int)value;
    [[APIController sharedInstance]ratingChannel:_curChannel.channelId score:_score completed:^(int code, BOOL results) {
        if (results) {
            [APPDELEGATE showToastWithMessage:@"Đánh giá thành công!" position:@"top" type:doneImage];
        } else {
            [APPDELEGATE showToastWithMessage:@"Đánh giá không thành công!" position:@"top" type:errorImage];
        }
    } failed:^(NSError *error) {
        
    }];
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
    if ([tableView isEqual:self.tbInfo]) {
        return 2;
    }
    return 1;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.tbInfo]) {
        if (section == 0) {
            return nil;
        } else {
            HomeHeaderSection *headerView = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
            headerView.backgroundColor = UIColorFromRGB(0xfcfcfc);
            headerView.lblHeader.text = kGENRE_SUGGESTION;
            headerView.delegate = self;
            return headerView;
        }
    } else if ([tableView isEqual:self.tbVideo]) {
        if (_typePlayer == typePlayerOffline) {
            //_viewHeaderOffline.translatesAutoresizingMaskIntoConstraints = NO;
            _viewHeaderOffline.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 65);
            _lblVideoNameOffline.text = _currentVideo.video_subtitle;
            return _viewHeaderOffline;
        } else {
            return nil;
        }
    } else {
        HomeHeaderSection *headerView = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
        headerView.backgroundColor = UIColorFromRGB(0xfcfcfc);
        headerView.lblHeader.text = kGENRE_SUGGESTION;
        headerView.iconHeader.image = [UIImage imageNamed:@"icon-mini-tat-v2"];
        headerView.isHideButton = YES;
        headerView.delegate = self;
        return headerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.tbInfo]) {
        return section == 0 ? 0 : 60;
    } else if ([tableView isEqual:self.tbSuggestion]) {
        return 60;
    } else if ([tableView isEqual:self.tbVideo]) {
        return _typePlayer == typePlayerOffline ? 65 : 0;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([tableView isEqual:self.tbInfo]) {
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 11)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_SIZE.width, 10)];
        paddingView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        //[footerView addSubview:lineView];
        [footerView addSubview:paddingView];
        return footerView;
    }
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [tableView isEqual:self.tbInfo] ? 11 : 0.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tbInfo]) {
        return section == 0 ? 1 : _listSuggestShort.count;
    } else if ([tableView isEqual:self.tbSuggestion]) {
        return _listSuggestFull.count;
    } else {
        return _typePlayer == typePlayerOffline ? _listDownloaded.count + 1 : _season.videos.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tbInfo]) {
        return indexPath.section == 0 ? 370 : 92;
    } else if ([tableView isEqual:self.tbVideo]) {
        if (_typePlayer == typePlayerOffline) {
            if (indexPath.row == 0) {
                return 60;
            } else {
                return 92;
            }
        }
    }
    return 92;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemCellIdef = @"itemCellIdef";
    
    if ([tableView isEqual:self.tbInfo]) {
        if (indexPath.section == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 370)];
            [cell addSubview:_infoView];
            cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            ItemCell *cell = (ItemCell*)[self.tbInfo dequeueReusableCellWithIdentifier:itemCellIdef];
            if (!cell) {
                cell = [Utilities loadView:[ItemCell class] FromNib:@"ItemCell"];
            }
            if (_listSuggestShort.count > indexPath.row) {
                Video *v = (Video*)[_listSuggestShort objectAtIndex:indexPath.row];
                cell.video = v;
                [cell loadContentWithType:typeSuggestionVideo];
            }
            cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else if ([tableView isEqual:self.tbSuggestion]) {
        ItemCell *cell = (ItemCell*)[self.tbSuggestion dequeueReusableCellWithIdentifier:itemCellIdef];
        if (!cell) {
            cell = [Utilities loadView:[ItemCell class] FromNib:@"ItemCell"];
        }
        if (_listSuggestFull.count > indexPath.row) {
            Video *v = (Video*)[_listSuggestFull objectAtIndex:indexPath.row];
            cell.video = v;
            [cell loadContentWithType:typeSuggestionVideo];
        }
        cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ([tableView isEqual:self.tbVideo]) {
        if (_typePlayer != typePlayerOffline) {
            ItemCell *cell = (ItemCell*)[self.tbVideo dequeueReusableCellWithIdentifier:itemCellIdef];
            if (!cell) {
                cell = [Utilities loadView:[ItemCell class] FromNib:@"ItemCell"];
            }
            if (_season.videos.count > indexPath.row) {
                Video *v = (Video*)[_season.videos objectAtIndex:indexPath.row];
                cell.video = v;
                [cell loadContentWithType:typeVideoInSeason];
            }
            cell.delegate = self;
            if (indexPath.row == _curIndexVideoChoose) {
                cell.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
                cell.lblTitle.textColor = UIColorFromRGB(0x00adef);
            } else {
                cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
                cell.lblTitle.textColor = UIColorFromRGB(0x212121);
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (_typePlayer == typePlayerOffline){
            if (indexPath.row == 0) {
                UITableViewCell *cell = [_tbVideo dequeueReusableCellWithIdentifier:@"offlineCell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"offlineCell"];
                    headerViewOffline = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
                    headerViewOffline.backgroundColor = UIColorFromRGB(0xfcfcfc);
                    headerViewOffline.lblHeader.text = [NSString stringWithFormat:@"Đã tải (%d)",(int)_listDownloaded.count];
                    headerViewOffline.iconHeader.hidden = YES;
                    headerViewOffline.lineView.hidden = YES;
                    headerViewOffline.frame = cell.frame;
                    if (![headerViewOffline isDescendantOfView:cell]) {
                        [cell addSubview:headerViewOffline];
                    }
                }
                headerViewOffline.lblHeader.text = [NSString stringWithFormat:@"Đã tải (%d)",(int)_listDownloaded.count];
                cell.userInteractionEnabled = NO;
                return cell;
            } else {
                static NSString *itemCellIdef = @"downloadItemCellIdef";
                DownloadedItemCell *cell = (DownloadedItemCell*)[self.tbVideo dequeueReusableCellWithIdentifier:itemCellIdef];
                if (!cell) {
                    cell = [Utilities loadView:[DownloadedItemCell class] FromNib:@"DownloadedItemCell"];
                }
                
                if (indexPath.row <= _listDownloaded.count) {
                    FileDownloadInfo* item = [_listDownloaded objectAtIndex:indexPath.row -1];
                    [cell setContent:item];
                    if (_curIndexVideoChoose == indexPath.row - 1) {
                        cell.lblTitle.textColor = UIColorFromRGB(0x00eadef);
                        cell.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
                    } else {
                        cell.lblTitle.textColor = UIColorFromRGB(0x212121);
                        cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
                    }
                }
                return cell;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tbVideo]) {
        if (_typePlayer != typePlayerOffline) {
            if (_season.videosCount > indexPath.row) {
                Video *v = [_season.videos objectAtIndex:indexPath.row];
                if ([v.video_id isEqualToString:_currentVideo.video_id]) {
                    return;
                }
                [[APIController sharedInstance]getVideoStreamWithKey:v.video_id completed:^(int code, VideoStream *results) {
                    if (results) {
                        v.videoStream = results;
                        APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
                        APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
                        APPDELEGATE.nowPlayerVC.player.view.chooseVideo.curIndexVideoChoose = _curIndexVideoChoose = (int)indexPath.row;
                        [APPDELEGATE playerLoadDataWithType:@"NEW_VIDEO_IN_SEASON" video:v channel:nil index:(int)_curIndexVideoChoose];
                        _lblVideoOrder.text = [NSString stringWithFormat:@"%d/%d",(int)_curIndexVideoChoose+1,(int)_season.videosCount];
                        [_tbVideo reloadData];
                        [self logGenre];
                        [APPDELEGATE.nowPlayerVC.player.view.chooseVideo.tbVideo reloadData];
                    }
                    //[self dismissHUD];
                } failed:^(NSError *error) {
                    //[self dismissHUD];
                }];
            }
        } else {
            if (_listDownloaded.count >= indexPath.row) {
                if (indexPath.row != 0) {
                    FileDownloadInfo *file = [_listDownloaded objectAtIndex:indexPath.row -1];
                    if(![file.videoDownload.video_id isEqualToString:_currentVideo.video_id]) {
                        _curIndexVideoChoose = indexPath.row -1;
                        [APPDELEGATE didSelectVideoOffline:file.videoDownload];
                    }
                }
            }
        }
    } else if ([tableView isEqual:self.tbInfo]) {
        if (indexPath.section == 1 && _listSuggestShort.count > indexPath.row) {
            [self trackEvent:@"iOS_video_play_recommend_video"];
            Video *v = [_listSuggestShort objectAtIndex:indexPath.row];
            [[APIController sharedInstance]getVideoStreamWithKey:v.video_id completed:^(int code, VideoStream *results) {
                if (results) {
                    v.videoStream = results;
                    APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
                    APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
                    [APPDELEGATE playerLoadDataWithType:@"NEW_VIDEO_SUGGESTION" video:v channel:nil index:0];
                    [_tbInfo scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                }
                //[self dismissHUD];
            } failed:^(NSError *error) {
                //[self dismissHUD];
            }];
        }
    } else if ([tableView isEqual:self.tbSuggestion]) {
        if (_listSuggestFull.count > indexPath.row) {
            [self trackEvent:@"iOS_video_play_recommend_video"];
            Video *v = [_listSuggestFull objectAtIndex:indexPath.row];
            [[APIController sharedInstance]getVideoStreamWithKey:v.video_id completed:^(int code, VideoStream *results) {
                if (results) {
                    v.videoStream = results;
                    APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
                    APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
                    [APPDELEGATE playerLoadDataWithType:@"NEW_VIDEO_SUGGESTION" video:v channel:nil index:0];
                    [_tbInfo scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                    [UIView animateWithDuration:0.2 animations:^{
                        self.tbSuggestion.frame = CGRectMake(0, _contentContainer.frame.size.height, SCREEN_SIZE.width, _contentContainer.frame.size.height);
                    } completion:^(BOOL finished) {
                        isShowSuggestion = NO;
                    }];
                }
                //[self dismissHUD];
            } failed:^(NSError *error) {
                //[self dismissHUD];
            }];
        }
    }
}

#pragma mark - CollectionView 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _season.videosCount;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tvCollectionCellIdenf = @"tvCollectionViewCell";
    TVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tvCollectionCellIdenf forIndexPath:indexPath];
    if (!cell) {
        cell = [Utilities loadView:[TVCollectionViewCell class] FromNib:@"TVCollectionViewCell"];
    }
    if (_season.videosCount > indexPath.row) {
        Video *v = [_season.videos objectAtIndex:indexPath.row];
        cell.video = v;
        cell.lblTitle.text = v.video_subtitle;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_season.videosCount > indexPath.row) {
        Video *v = [_season.videos objectAtIndex:indexPath.row];
        [[APIController sharedInstance]getVideoStreamWithKey:v.video_id completed:^(int code, VideoStream *results) {
            if (results) {
                v.videoStream = results;
                APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
                APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
                [APPDELEGATE playerLoadDataWithType:@"NEW_VIDEO_IN_SEASON" video:v channel:nil index:(int)indexPath.row];
                _curIndexVideoChoose = (int)indexPath.row;
                _lblVideoOrder.text = [NSString stringWithFormat:@"%d/%d",(int)_curIndexVideoChoose+1,(int)_season.videosCount];
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

#pragma mark - PlaylistItemView Delegate 
- (void)didTappedItem:(id)sender {
    PlaylistItemView *item = (PlaylistItemView*)sender;
    if (item.selected) {
        return;
    } else {
        Season *ss = item.season;
        [self loadDataFromNewSeason:ss];
        if (scrollView) {
            for (UIView *view in scrollView.subviews) {
                if ([view isKindOfClass:[PlaylistItemView class]]) {
                    PlaylistItemView *plItem = (PlaylistItemView*)view;
                    plItem.selected = [plItem.season.seasonId isEqualToString:ss.seasonId];
                }
                
            }
        }
    }
}

#pragma mark - HomeHeaderSection Delegate
- (void)headerTappedWithTitle:(NSString *)headerTitle isHide:(BOOL)hidden {
    if ([headerTitle isEqualToString:kGENRE_SUGGESTION]) {
        if (hidden) {
            NSLog(@"%f %f",self.tbSuggestion.frame.origin.y,self.tbSuggestion.frame.size.height);
            [UIView animateWithDuration:0.3 animations:^{
                self.tbSuggestion.frame = CGRectMake(0, _contentContainer.frame.size.height, SCREEN_SIZE.width, _contentContainer.frame.size.height);
            } completion:^(BOOL finished) {
                isShowSuggestion = NO;
            }];
        } else {
            NSLog(@"%f %f",self.tbSuggestion.frame.origin.y,self.tbSuggestion.frame.size.height);
            [UIView animateWithDuration:0.4 animations:^{
                self.tbSuggestion.frame = CGRectMake(0, 0, SCREEN_SIZE.width, _contentContainer.frame.size.height);
            } completion:^(BOOL finished) {
                isShowSuggestion = YES;
            }];
        }
    }
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
    NSArray *arraySownloadStream = _currentVideo.videoStream.streamDownloads;
    QualityURL *qlt = nil;
    if (arraySownloadStream.count > index) {
        qlt = [arraySownloadStream objectAtIndex:index];
    }
//    if ([object isKindOfClass:[Video class]] && (index == 1 || index == 2)) {
//        if ( !linkShare || [linkShare isEqualToString:@""]) {
//            if ([object isKindOfClass:[Video class]]) {
//                Video *video = (Video*)object;
//                [[APIController sharedInstance]getVideoDetailWithKey:video.video_id completed:^(int code, Video *results) {
//                    if (results) {
//                        if (!results.link_share || [results.link_share isEqualToString:@""]) {
//                            [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho video này." position:@"top" type:errorImage];
//                            return;
//                        }
//                        if (index == 1) {
//                            [[ShareTask sharedInstance] setViewController:self];
//                            [[ShareTask sharedInstance] shareFacebook:results];
//                        } else if (index == 2) {
//                            [self trackEvent:@"iOS_share_on_copy_link"];
//                            NSString *dataText = results.link_share;
//                            if (dataText && ![dataText isKindOfClass:[NSNull class]]) {
//                                [[UIPasteboard generalPasteboard] setString:dataText];
//                                [APPDELEGATE showToastWithMessage:@"Đã copy link" position:@"top" type:doneImage];
//                            }
//                        }
//                        
//                    }
//                } failed:^(NSError *error) {
//                    
//                }];
//            }
//            
//            return;
//        } else {
//            if ([object isKindOfClass:[Video class]] && index == 1 && [title isEqualToString:@"Chia sẻ Facebook"]){
//                
//                Video *video = (Video*)object;
//                [[ShareTask sharedInstance] setViewController:self];
//                [[ShareTask sharedInstance] shareFacebook:video];
//            } else if ([object isKindOfClass:[Video class]] && index == 2 && [title isEqualToString:@"Copy Link"]) {
//                if (!linkShare || [linkShare isEqualToString:@""]) {
//                    [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho video này." position:@"top" type:errorImage];
//                    return;
//                }
//                [self trackEvent:@"iOS_share_on_copy_link"];
//                NSString *dataText = linkShare;
//                if (dataText && ![dataText isKindOfClass:[NSNull class]]) {
//                    [[UIPasteboard generalPasteboard] setString:dataText];
//                    [APPDELEGATE showToastWithMessage:@"Đã copy link." position:@"top" type:doneImage];
//                }
//            }
//        }
//    }
    if ([object isKindOfClass:[Video class]] && [title isEqualToString:qlt.type]) {
        [self downloadCurrentVideoWithQuality:qlt];
    }
}

- (IBAction)btnMiniInfoAction:(id)sender {
    _tbInfo.translatesAutoresizingMaskIntoConstraints = NO;
    CGRect frame = _tbInfo.frame;
    _btnMiniInfo.enabled = NO;
    //[_iconMini setImage:[UIImage imageNamed:@"icon-mini-arrow1-v2"]];
    if (!isMiniInfo) {
        originScrollView = _tbInfo.frame;
        [UIView animateWithDuration:0.3 animations:^{
            _tbInfo.frame = CGRectMake(frame.origin.x, _contentContainer.frame.size.height, frame.size.width, frame.size.height) ;
            _iconMini.transform = CGAffineTransformMakeRotation(-180 * (M_PI/180));
        } completion:^(BOOL finished) {
            isMiniInfo = !isMiniInfo;
            for (NSLayoutConstraint *topContraint in _contentContainer.constraints) {
                if (topContraint.constant == 0 && [topContraint.firstItem isEqual:_tbInfo] && [topContraint.secondItem isEqual:_header] && topContraint.firstAttribute == NSLayoutAttributeTop && topContraint.secondAttribute == NSLayoutAttributeBottom) {
                    topContraint.constant = _contentContainer.frame.size.height - 40;
                    [_contentContainer setNeedsLayout];
                    [_contentContainer layoutIfNeeded];
                    break;
                }
            }
            if (finished) {
                _btnMiniInfo.enabled = YES;
            }
            
        }];
    } else {
        //[_iconMini setImage:[UIImage imageNamed:@"icon-mini-arrow1-v2"]];
        [UIView animateWithDuration:0.4 animations:^{
            _tbInfo.frame = originScrollView ;
            _iconMini.transform = CGAffineTransformMakeRotation(1 * (M_PI/180));
        } completion:^(BOOL finished) {
            isMiniInfo = !isMiniInfo;
            for (NSLayoutConstraint *topContraint in _contentContainer.constraints) {
                if (topContraint.constant == _contentContainer.frame.size.height - 40 && [topContraint.firstItem isEqual:_tbInfo] && [topContraint.secondItem isEqual:_header] && topContraint.firstAttribute == NSLayoutAttributeTop && topContraint.secondAttribute == NSLayoutAttributeBottom) {
                    topContraint.constant = 0;
                    [_contentContainer setNeedsLayout];
                    [_contentContainer layoutIfNeeded];
                    break;
                }
            }
            if (finished) {
                _btnMiniInfo.enabled = YES;
            }
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {
    if(scrollView.contentOffset.y + scrollView.frame.size.height  > (scrollView.contentSize.height - CELL_HEIGHT_MORE))
    {
        if(self.isLoadMore && isShowSuggestion)
        {
            [self loadVideoSuggestionWithPageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:NO];
            self.isLoadMore = NO;
        }
    }
}

@end
