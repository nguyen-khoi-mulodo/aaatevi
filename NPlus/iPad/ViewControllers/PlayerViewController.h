#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Video.h"
#import "GAITrackedViewController.h"
#import "Constant.h"
#import "ActionVC.h"

@class AVPlayer;
@class PlayerDetailView;

@protocol PlayerViewControllerDelegate <NSObject>
- (void) showFullScreen;
- (void) showInfoView;
- (void) chooseVideo:(Video*) video atIndex:(int) index;
- (void) showLoading:(BOOL) isShow;
- (void) cannotPlayNext;
- (BOOL) checkOpenningVideo;
- (void) cancelTimerHideMenu:(BOOL) isCancel;
- (void) cancelPanGeature:(BOOL) isCancel;
- (Video*) getCurrentVideo;
- (void) deleteVideoItemCurrent;
- (BOOL) mpIsFullScreen;
- (void) doMinimized;
- (void) doXemSau;
- (void) doShare;
- (void) doViewQuality;
- (void) doDownload;
- (void) loadVideoPlayerWithItem:(id) item withIndex:(int) index fromRootView:(BOOL) fromRoot;
@end

@interface PlayerViewController : GAITrackedViewController <UIGestureRecognizerDelegate>
{
@private
	IBOutlet PlayerDetailView* mPlaybackView;
	IBOutlet UISlider* mScrubber;
    IBOutlet UISlider* mSvolume;

    IBOutlet UIButton* mPlayButton;
    IBOutlet UIButton* mStopButton;
    
    IBOutlet UIButton* mNextButton;
    IBOutlet UIButton* mPrevButton;
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *lbStatusWaiting;
    
	float mRestoreAfterScrubbingRate;
	BOOL seekToZeroBeforePlay;
	id mTimeObserver;
	BOOL isSeeking;

	NSURL* mURL;
    
	AVPlayer* mPlayer;
    AVPlayerItem * mPlayerItem;
    
    id <PlayerViewControllerDelegate> parentDelegate;
    
    IBOutlet UIActivityIndicatorView* loading;
    
    // Bottom Menu
    IBOutlet UILabel* lbDurationTime;
    IBOutlet UILabel* lbTotalTime;
    IBOutlet UIButton* btnFullScreen;
    IBOutlet UIView* headerPlayer;
    
    IBOutlet UIImageView* imgVolume;
    IBOutlet UIButton* btnSetting;
    
    IBOutlet UIView* playerLoading;
    
    BOOL isStoped;
    BOOL LOADING_ASSET;
    
    IBOutlet UILabel* playerMessage;
    BOOL isTouchDown;
    
    IBOutlet UIView* animationView;
    IBOutlet UIImageView* animationImage;
    
    Direct_Type direct_type;
    
    // Duration Mini View
    IBOutlet UIView* miniDurationView;
    IBOutlet UILabel* mlbDurationTime;
    IBOutlet UILabel* mlbTotalTime;
    IBOutlet UIProgressView* mProgressView;
    IBOutlet UIImageView* mStatusImageView;
    Direct_Type mini_direct_current;
    float timeCurrent;
    UIPanGestureRecognizer* panGesture;
    BOOL isChangeVolume;
    float volumeCurrent;
    BOOL isChangeBrightness;
    float brightnessCurrent;
    BOOL isChangeProgress;
    
    CGRect oldSubtileRect;
    

    IBOutlet UILabel* lbTitle;
    IBOutlet UILabel* lbDesciption;
    
    IBOutlet UIButton* btnQuality;

    float valueBefore;
    
}

@property (nonatomic, copy) NSURL* URL;
@property (readwrite, strong, setter=setPlayer:, getter=player) AVPlayer* mPlayer;
@property (strong) AVPlayerItem* mPlayerItem;
@property (nonatomic, strong) IBOutlet PlayerDetailView *mPlaybackView;
@property (nonatomic, strong) IBOutlet UIButton *mPlayButton;
@property (nonatomic, strong) IBOutlet UIButton *mStopButton;
@property (nonatomic, strong) IBOutlet UISlider* mScrubber;
@property (nonatomic, strong) IBOutlet UISlider* mSvolume;
@property (nonatomic, strong) IBOutlet UILabel* lbDurationTime;
@property (nonatomic, strong) IBOutlet UILabel* lbTotalTime;

@property (nonatomic, weak) IBOutlet UIView* bottomPlayer;
@property (nonatomic, weak) IBOutlet UIView* headerPlayer;
@property (nonatomic, weak) IBOutlet UIView* centerPlayer;
@property (nonatomic, weak) IBOutlet UIView* actionView;
@property (nonatomic, strong) IBOutlet UIButton* btnXemSau;
@property (weak, nonatomic) IBOutlet UIProgressView* bufferProgress;

@property (nonatomic, strong) id <PlayerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString* subtitle;

@property int indexCurrent;
@property (nonatomic, strong) NSMutableArray* listVideos;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;

- (void) changeVideoFillModeWithFullScreen:(BOOL) isFullScreen;
- (void) changeVideoFullModeWithMinimizedScreen:(BOOL) isMinimized;
- (void) showPlayerMenuFull:(BOOL) isFull;
- (void) showControlFull:(BOOL) isFull;
- (void) showLoading:(BOOL) isShow;
- (void) showPlayerMessage:(NSString*) msg isShow:(BOOL) show;
- (void) stop;
- (BOOL) playing;
- (void) updateLoadingView;
- (void) hideMenuPlayer:(BOOL) isHidden;
- (void) showMiniDurationView;
- (void) updateMiniDurationView:(Direct_Type) type andAlpha:(float) alpha;
- (void) stopMiniDurationView;
- (void) showXemSauStatus:(BOOL) isViewLater;
- (void) enableButtonQuality:(BOOL) enable;
- (void) setTitle:(NSString*) title andSubTitle:(NSString*) subTitle;
- (void) setQualityWithType:(NSString*) type withLink:(NSString*) link;
- (void) showActionView:(BOOL) isShow;
@end
