//
//  NowPlayerVC.h
//  NPlus
//
//  Created by TEVI Team on 8/20/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

//#import "BaseVC.h"
#import "NPVideoPlayer.h"
#import "HMSegmentedControl.h"
#import "ILTranslucentView.h"
#import "Channel.h"
#import "Video.h"
#import "ViewPagerController.h"
#import "HomeHeaderSection.h"
#import "PlaylistItemView.h"
#import "ItemCell.h"
#import "RatingView.h"
@interface NowPlayerView : UIView
@end
@interface NowPlayerVC : HomeVC<NPVideoPlayerDelegate,UITableViewDelegate,UITableViewDataSource,PlaylistItemViewDelegate,HomeHeaderSectionDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ItemCellDelegate,MoreOptionViewDelegate,RatingViewDelegate> {
    BOOL isShowSuggestion;
}


@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentContainer_Top;
@property (weak, nonatomic) IBOutlet ILTranslucentView *viewMenu;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITableView *tbSuggestion;
@property (weak, nonatomic) IBOutlet UITableView *tbInfo;
@property (weak, nonatomic) IBOutlet UITableView *tbVideo;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVideo;

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoName;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeCreate;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) IBOutlet UIButton *btnViewLater;

@property (weak, nonatomic) IBOutlet UIButton *btnChannel;
@property (weak, nonatomic) IBOutlet UIImageView *imgChannel;
@property (weak, nonatomic) IBOutlet UILabel *lblChannelBody;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowCount;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar1;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar2;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar3;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar4;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar5;
@property (weak, nonatomic) IBOutlet UILabel *lblRatingCount;
@property (weak, nonatomic) IBOutlet UILabel *lblRatingText;
@property (weak, nonatomic) IBOutlet UIButton *btnRating;

@property (weak, nonatomic) IBOutlet UIView *playlistView;

@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet HomeHeaderSection *headerPlaylistView;
@property (weak, nonatomic) IBOutlet UIImageView *iconMini;
@property (weak, nonatomic) IBOutlet UIButton *btnMiniInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblChannelNameHeader;

@property (strong, nonatomic) IBOutlet UIView *viewHeaderOffline;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoNameOffline;

@property (strong, nonatomic) IBOutlet UIView *headeView;


@property (strong, nonatomic)NSMutableArray *pages;
@property (strong, nonatomic) NSString *type;
@property (nonatomic, strong) NSString *curId;
@property (nonatomic, strong) Channel *curChannel;
@property (nonatomic, strong) NSArray *lstVideo;
@property (nonatomic, assign) NSInteger curIndexVideoChoose;
@property (nonatomic, assign) kItemCollectionType itemCollectionType;
@property (nonatomic, strong) NPVideoPlayer* player;
@property (nonatomic, assign) BOOL isShowNowPlaying;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) Video *currentOfflineVideo;
@property (nonatomic, strong) Video *prepairedVideo;
@property (nonatomic, strong) Video *currentVideo;
@property (nonatomic, strong) Season *season;
@property (nonatomic, assign) int numberOfTabs;
@property (nonatomic, assign) TypePlayer typePlayer;
@property float offsetMenu;
@property BOOL isShowViewMore;
@property UIInterfaceOrientation orientation;
@property BOOL isHD;
@property (nonatomic, strong) NSMutableArray *listSuggestFull;
@property (nonatomic, strong) NSMutableArray *listSuggestShort;
@property (nonatomic, strong) NSMutableArray *listSeason;
@property (nonatomic, strong) NSMutableArray *listDownloaded;
@property (nonatomic, assign) int score;

- (void) playWithVideo:(Video*)video;
- (void)playVideoWithURL:(NSString*)link;
- (void)showPlayer:(BOOL)show withAnimation:(BOOL)animated;
- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;
- (UIViewController *)selectedController;
- (void)updateTitleLabels;
- (void)loadTabsWithChannel:(Channel*)channel;
- (void)loadDataVideoIndex:(int)index;
- (void)showData:(NSInteger)index;
- (void)stopPlayer;
- (Video*)getCurrentVideo;
- (NSString*)getLinkOfVideo:(Video*)video;
- (NSString*)getDownloadLinkOfVideoIsHD:(BOOL)isHD video:(Video*)video;
- (IBAction)btnHideDownloadView_Tapped:(id)sender;
- (void)changeStateHDTap:(BOOL)isHD;
- (void)myDealloc;
- (void)cellcularChange;
- (void)willRotateTo:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)didRotateTo;

- (void)presentViewFromPlayer:(BOOL)isPresent;
- (void)loadDataOffile;
- (void)loadDataNewVideo;
- (void)loadNewDataForVideoInSeason;
- (void)loadDataNewVideoSuggestion;
- (void)loadNewSeason;
- (IBAction)btnRatingTapped:(id)sender;
//- (void)didSubmitRatingValue:(float)value;
- (IBAction)btnFollowTapped:(id)sender;
- (IBAction)btnMiniInfoAction:(id)sender;
- (void)loadChannelDetail:(NSString*)channelId;
- (void)loadVideoDetailWithLoadChannel:(BOOL)isLoadChannel;
- (void)updateVideoInfoWithLoadChannel:(BOOL)isLoadChannel;
- (void)updateChannelInfo;
- (void)loadDataWithChannel:(Channel*)channel;
@end
