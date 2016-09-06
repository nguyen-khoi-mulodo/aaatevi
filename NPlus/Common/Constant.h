//
//  Constant.h
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#define DEBUG_URL 0
#define DEBUG_RESULT 0

////////////////////// dev
//#define API_URL                 @"http://123.30.134.153:9100/v1"
//#define kBuildType      0       // 0: Dev  1: Appstore

////////////////// live
#define API_URL                 @"https://api.tevi.com/v1"
#define kBuildType      1       // 0: Dev  1: Appstore


#define kRealServer       @"https://api.tevi.com/v1"

#define PUBLIC_KEY      @"nct@mobile_vod_service"
#define MD5_IOS_KEY     @"NCT@VOD_d8P6LXa05"


// define for DeviceInfo
#define kOSName         @"IOS"
#define kAppName        @"Tevi"
#define kProvider       @"TeviMobile"
#define kLanguage       @"VI" // EN

#define UNIVERSAL_SETTING 1

#define kFirstPage      1
#define kPageSize       30

#define kAPPID 962266454

#define kAnalyticsID @"UA-51832900-9"

#define kEmail @"msupport@nct.vn"

#define		SETTING_INTRO                       @"NCT.INTRO"
#define		SETTING_USERNAME					@"NCT.USERNAME"
#define		SETTING_USERID						@"NCT.USERID"
#define		SETTING_PWD							@"NCT.PWD"
#define		SETTING_AVATAR						@"NCT.AVATAR"
#define     SETTING_FULLNAME                    @"NCT.FULLNAME"
#define     SETTING_EMAIL                       @"NCT.EMAIL"
#define     SETTING_ACCESSKEY                   @"NCT.ACCESSKEY"

#define		SETTING_ALLOW3G						@"NCT.ALLOW3G"
#define		SETTING_ADS_ON_OFF					@"NCT.ADS_ON_OFF"
#define		SETTING_LOCK_ROTATION				@"NCT.SETTING_LOCK_ROTATION"
#define		SETTING_BAGDE                       @"NCT.SETTING_BAGDE"

#define		TUTORIAL_1                          @"TUTORIAL_1"
#define		TUTORIAL_2                          @"TUTORIAL_2"
#define		TUTORIAL_3                          @"TUTORIAL_3"
#define		TUTORIAL_4                          @"TUTORIAL_4"

#define		OK_TITLE							@"OK"
#define     ALERT_CANCEL_BUTTON                 @"Hủy"
#define		CANCEL_TITLE						@"Đóng"
#define     SEND_SMS_SUCESSED                   @"Tin nhắn của bạn đã được gửi đi!"
#define     SEND_SMS_FAILED                     @"Gửi tin nhắn thất bại. Tin nhắn của bạn đã không được gửi đi!"
#define     SEND_SMS_NOTE                       @"Gửi NCT DK đến 8536 để đăng ký thành viên. Phí SMS 5.000 VNĐ"

#define kFontSemibold           @"SanFranciscoDisplay-Semibold"
#define kFontLight              @"SanFranciscoDisplay-Light"
#define kFontRegular            @"SanFranciscoDisplay-Regular"
#define kFontMedium             @"SanFranciscoDisplay-Medium"
#define kFontThin               @"SanFranciscoDisplay-Thin"

#define kGENRE_HOT_VIDEO    @"Hot nhất trong tuần"
#define kGENRE_SHORT_FILM   @"Phim ngắn"
#define kGENRE_TV_SHOW      @"TV Show"
#define kGENRE_RELAX        @"Giải trí"
#define kGENRE_NEW_VIDEO    @"Video mới"
#define kGENRE_HISTORY      @"Lịch sử"
#define kGENRE_NOTIFICATION @"Thông báo"
#define kGENRE_SUGGESTION   @"Video gợi ý"
#define kGENRE_PLAYLIST     @"Danh sách Playlist"
#define kGENRE_CHANNEL_ACTOR @"Kênh tham gia"

#define		CELL_HEIGHT_MORE		80
typedef enum{
    kItemCollectionTypeMovies,
    kItemCollectionTypeTVShow,
}kItemCollectionType;


#define kToggleShowTabVideoDetailLandscape      @"kToggleShowTabVideoDetailLandscape"
#define kDownloadVideoCurrentNotification       @"kDownloadVideoCurrentNotification"
#define kOfflineCheckAllNotification            @"kOfflineCheckAllNotification"
#define kOfflineCountItemCheckNotification      @"kOfflineCountItemCheckNotification"
#define kChangeModeScreenNotification           @"kChangeModeScreenNotification"
#define kIncrementBagdeDownloadNotification     @"kIncrementBagdeDownloadNotification"
#define kReloadHistoryNotification              @"kReloadHistoryNotification"
#define kDidLoginNotification                   @"kDidLoginNotification"
#define kDidLogoutNotification                  @"kDidLogoutNotification"
#define kDidLoadDownloadedVideoNotification     @"kDidLoadDownloadedVideo"
#define kDidLoadDownloadingVideoNotification    @"kDidLoadDownloadingVideo"
#define kDidAddDownloadVideoNotification        @"kDidAddDownloadVideo"
#define kDidDownloadedVideoNotification         @"kDidDownloadedVideo"
#define kDidDeleteVideoDownloaded               @"kDidDeleteVideoDownloaded"
#define kDidRefreshDownloadData                 @"kDidRefreshDownloadData"
#define kShowControlPlayerNotification          @"kShowControlPlayerNotification"
#define kHideControlPlayerNotification          @"kHideControlPlayerNotification"
#define kUpdateIndexVideoNotification           @"kUpdateIndexVideoNotification"
#define kUpdateDiskSpaceNotification            @"kUpdateDiskSpaceNotification"
#define kGooglePlusLoginedNotification          @"kGooglePlusLoginedNotification"
#define kUserNotLoginNotification               @"kUserNotLoginNotification"
#define kDataNotExistNotification               @"kDataNotExistNotification"
#define kLikedNotification                      @"kLikedNotification"
#define kUnlikedNotification                    @"kUnlikedNotification"
#define kWillEnterForeground                    @"kWillEnterForeground"
#define kDidMinimizePlayerForActor              @"didMinimizePlayerForActor"
#define kDidMinimizePlayerForChannel            @"didMinimizePlayerForChannel"
#define kDidLoadDetailChannel                   @"didLoadDetailChannel"
#define kDidLoadDetailVideo                     @"didLoadDetailVideo"
#define kDidLoadDetailArtist                    @"kDidLoadDetailArtist"
#define kDidChooseVideoInSeason                 @"kDidChooseVideoInSeason"
#define kDidChooseVideoInSuggest                @"kDidChooseVideoInSuggest"
#define kDidPlayNextVideo                       @"kDidPlayNextVideo"
#define kDidPlayVideo                           @"kDidPlayVideo"
#define kDidSubcribeChannel                     @"kDidSubcribeChannel"
#define kDidSubcribeVideo                       @"kDidSubcribeVideo"
#define kDidGetChannelsOfVideo                  @"kDidGetChannelsOfVideo"
#define kReplaceChannelDetail                   @"kReplaceChannelDetail"
#define kLoadListVideoXemSau                    @"kLoadListVideoXemSau"
#define kLoadListChannelLiked                   @"kLoadListChannelLiked"
#define kLoginSuccess                           @"kLoginSuccess"
#define kDidConnectInternet                     @"kDidConnectInternet"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

// check device orientation
#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)
#define isLandscape UIDeviceOrientationIsLandscape(dDeviceOrientation)
#define isFaceUp    dDeviceOrientation == UIDeviceOrientationFaceUp   ? YES : NO
#define isFaceDown  dDeviceOrientation == UIDeviceOrientationFaceDown ? YES : NO

#define RGBA(x,y,z,a) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:a]
#define RGB(x,y,z) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:1.0f]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_WIDTH (IOS_VERSION_LOWER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height) : [[UIScreen mainScreen] bounds].size.width)

#define SCREEN_HEIGHT (IOS_VERSION_LOWER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width) : [[UIScreen mainScreen] bounds].size.height)

#define IOS_VERSION_LOWER_THAN_8    (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
#define IOS_VERSION_LOWER_THAN_9    (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_8_4)
#define IOS_VERSION_LOWER_THAN_8_4  (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_4)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kBackgroundDarkColor [UIColor colorWithRed:16/255.0 green:23/255.0 blue:26/255.0 alpha:1.0f]
#define kBAckgroundLightColor [UIColor colorWithRed:17/255.0 green:23/255.0 blue:26/255.0 alpha:1.0f]
#define kStyleColor [UIColor colorWithRed:0 green:175/255.0f blue:233/255.0f alpha:1.0f]


#define ID_GENRE_PHIMNGAN  @"QCDFuhwng04rB"
#define ID_GENRE_TVSHOW   @"pfeuxlxKqIUCX"
#define ID_GENRE_GIAITRI  @"vU3acB29RQXHt"

#define HOT_TYPE @"hot"
#define NEW_TYPE @"new"
#define RECOMMEND_TYPE @"recommend"

#define SINGLE_TYPE @"Single"
#define SERIAL_TYPE @"Serial"
#define DETAIL_TYPE @"VideoDetail"
#define DETAIL_OFFLINE_TYPE @"VideoOfflineDetail"
#define SEASON_TYPE  @"Season"
#define SINGLE_TYPE  @"Single"
#define CHANNEL_TYPE @"Channel"

#define LIST_TYPE @"List" // -> SERIAL
#define CHANNEL_TYPE @"Channel" // -> SEASON
#define LINK_TYPE @"Link" // -> LINK
#define VIDEO_TYPE @"Video" // -> DEATIL

#define		MENU_FB		@"Facebook"
#define		MENU_COPY	@"Copy Link"

#define     MENU_EMAIL  @"Email"
#define     MENU_SMS    @"SMS"

#define kDefault_Video_Img      @"default-video-v2"
#define kDefault_Showcase_Img   @"default-showcase-v2"
#define kDefault_Actor_Img      @"default-casy-v2"
#define kDefault_Channel_Img    @"default-channel-v2"

#define kNSUserDefault [NSUserDefaults standardUserDefaults]
#define kUserDefaultUser @"User"
#define kUserFBID @"userFBId"
#define kUserName @"userName"
#define kUserDisplayName @"displayName"
#define kUserEmail @"userEmail"
#define kUserAvatar @"userAvatar" 
#define kUserLogined @"userLogined"
#define kUserDefaultHD @"isHD"

typedef enum{
    home_type,
    khampha_type,
    phimbo_type,
    phimle_type,
    tvshow_type,
    phimngan_type,
    giaitri_type,
    canhan_type,
    xemsau_type,
    search_type,
    download_type,
    liked_type,
}MainScreenType;


typedef enum{
    tags,
    genres,
    shortfilm,
    tvshow,
    relax,
}DiscoveryScreen;



typedef enum{
    categoryScreen,
    searchScreen,
    likeScreen,
    downloadScreen,
}ScreenType;

typedef enum{
    downloadedScreen,
    downloadingScreen,
}DownloadScreenType;

typedef enum {
    normal_direct,
    up_direct,
    down_direct,
    left_direct,
    right_direct,
    right_top_direct
} Direct_Type;

typedef enum {
    loginfacebook,
    logingoogleplus,
} Login_Type;

typedef enum{
    video_type,
    channel_type,
    artist_type,
    cuatui_channel_type,
    cuatui_video_type,
    share_type,
    action_download_type,
    action_quality_type,
}ListType;

#define kDownloadStatusChangeNotification       @"kDownloadStatusChangeNotification"
typedef NS_ENUM(NSInteger, DownloadResultCode) {
    DownloadResultCodeStarted,
    DownloadResultCodeFinished,
    DownloadResultCodeCancel,
    DownloadResultCodeUpdated,
    DownloadResultCodeFailed,
    DownloadResultCodeResumed,
    DownloadResultCodeSaving,
};

#define kTaskFolow        @"kTaskFolow"
#define kTaskViewLater    @"kTaskViewLater"
#define kTaskLogin        @"kTaskLogin"
#define kTaskRating       @"kTaskRating"
#define kTaskLike         @"kTaskLike"
#define kTaskViewLaterVC  @"kTaskViewLaterVC" 
#define kTaskFollowVC     @"kTaskFollowVC"


typedef enum{
    kItemTypeMovies,
    kItemTypeTVShow,
    kItemTypeVideo,
}ItemRelatedType;

typedef enum {
    developement,
    distribution
} BuildType;

typedef enum {
    typeChannel,
    typeFollow,
    typeVideo,
    typeVideoInSeason,
    typeVideoInSeasonFullScreen,
    typeSection,
    typeVideoDownloaded,
    typeVideoDownloading,
    typeVideoDownloadWaiting,
    typeWatchLater,
    typeSearch,
    typeSuggestionVideo,
    typeSuggestionChannel,
    typeNewFeed
}TypeCell;

typedef enum {
    typeInfoVideo,
    typeInfoChannel,
    typeInfoActor,
    typeInfoSeason
}TypeInfo;

typedef enum {
    typePlayerVideo,
    typePlayerVideoOfSeason,
    typePlayerSeason,
    typePlayerOffline
}TypePlayer;

typedef enum {
    typeKhampha,
    typeDetailGenre,
    typeSearchVC,
} TypeVC;

// subtitle
static NSString *const kIndex = @"kIndex";
static NSString *const kStart = @"kStart";
static NSString *const kEnd = @"kEnd";
static NSString *const kText = @"kText";

// Client ID Google+
static NSString *const kClientGPlusID = @"137520820543-6daskm3dmp75lbigc9cdo6aunncpohcc.apps.googleusercontent.com";
#define kRC4IOSKey                @"nctiosrc4"

#define kRESPONSE_CODE            @"code"
#define kRESPONSE_MSG             @"msgCode"
#define kRESPONSE_DATA            @"data"
#define kRESPONSE_LOADMORE        @"loadmore"
#define kRESPONSE_TOTAL           @"total"

#define kAPI_SUCCESS            0

#define kAPI_INVALID_REQUEST    201
#define kAPI_SYSTEM_ERROR       202
#define kAPI_ACCESS_DENIE       208

#define kAPI_USER_NOT_LOGIN     203
#define kAPI_USER_NOT_EXIST     204
#define kAPI_USER_LOCKED        205

#define kAPI_DATA_EMPTY         200
#define kAPI_DATA_NOT_EXIST     201

#define kAPI_EMPTY_TOKEN                  110
#define kAPI_INVALID_TOKEN                111
#define kAPI_EXPIRED_TOKEN                112
#define kAPI_NOT_EXIST_TOKEN              113
#define kAPI_WRITE_FAILD_TOKEN            114
#define kAPI_TIMESTAMP_INVALID_TOKEN      115

#define kSECTION_HOT 0
#define kSECTION_NEW 4
#define kSECTION_SHORT_FILM 1
#define kSECTION_RELAX 3
#define kSECTION_TVSHOW 2

#define kDefaultPageSize        10

// segment
#define TAG_VALUE 9000

#define WIDTH_SEGMENT 450
#define HEIGHT_INDEX_SEGMENT 36

typedef enum {
    CapLeft          = 0,
    CapMiddle        = 1,
    CapRight         = 2,
    CapLeftAndRight  = 3
} CapLocation;

//#define kSelectedColor [UIColor colorWithRed:19/255.0f green:157/255.0f blue:236/255.0f alpha:1.0f]
#define kSelectedColor UIColorFromRGB(0x00adef)
#define kNormalColor    [UIColor colorWithWhite:1.0f alpha:0.8f]
//#define kNormalColor UIColorFromRGB(0x212121)
#define kMenuBackground [UIColor colorWithRed:57/255.0f green:75/255.0f blue:83/255.0f alpha:1.0f]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define VIDEO_WIDTH 675
#define VIDEO_HEIGHT 380

typedef enum {
    noneImage,
    doneImage,
    errorImage,
}MessageType;



#define ChatLuongThuong @"Chất lượng thường"
#define ChatLuongCao    @"Chất lượng cao"

#define APP_LINK @"https://itunes.apple.com/us/app/tevi/id962266454?ls=1&mt=8"

typedef enum {
    NewFeed         = 0,
    History         = 1,
    XemSau          = 2,
    Follow          = 3,
    Notification     = 4,
    Setting         = 5
} CuaTui_Menu_Type;
