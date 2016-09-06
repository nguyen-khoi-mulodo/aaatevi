//
//  NPVideoPlayer.m
//  NPlus
//
//  Created by TEVI Team on 9/15/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "NPVideoPlayer.h"
#import "AKNavigationController.h"
#import "UIView+VKFoundation.h"
#import "DBHelper.h"
#import "APIController.h"
#import "ShareTask.h"
#import "ParserObject.h"
#import "FWTPopoverView.h"
#import "QualityURL.h"


#define degreesToRadians(x) (M_PI * x / 180.0f)
/* Asset keys */
NSString * const kTracksKey         = @"tracks";
NSString * const kPlayableKey		= @"playable";
/* PlayerItem keys */
NSString * const kStatusKey         = @"status";

/* AVPlayer keys */
NSString * const kRateKey                   = @"rate";
NSString * const kCurrentItemKey            = @"currentItem";
NSString * const kPlaybackLikelyToKeepUp    = @"playbackLikelyToKeepUp";

static NSString* urlLoading;
static float height_player = 0;
static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;
static void *AVPlaybackViewControllerCurrentItemKeepUpObservationContext = &AVPlaybackViewControllerCurrentItemKeepUpObservationContext;

#define PlayerContinueNotification @"PlayerContinueNotification"
#define PlayerHangingNotification @"PlayerHangingNotification"

@interface NPVideoPlayer()<UIActionSheetDelegate>
@end
@implementation NPVideoPlayer
@synthesize delegate = _delegate;
@synthesize mPlayer, mPlayerItem;
@synthesize isAnimation = _isAnimation;
@synthesize view = _view;
- (id)init {
    self = [super init];
    if (self) {
        float delta = 0.5625f;
        height_player = SCREEN_WIDTH * delta;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NPPlayerView" owner:self options:nil];
        self.view = [nib firstObject];
        self.view.tag = 300;
        [self.view setFrame:CGRectMake(0, ORIGIN_Y, SCREEN_WIDTH, height_player)];
        [self initialize];
    }
    return self;
}

- (void)setVideoTitle:(NSString *)video_title{
    [self.view.lbTitle setText:video_title];
}

-(void)initialize{
    self.forceRotate = NO;
    [self initScrubberTimer];
    self.supportedOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    self.portraitFrame = CGRectMake(0, ORIGIN_Y, SCREEN_WIDTH, height_player);
    self.landscapeFrame = CGRectMake(0, 0, MAX(SCREEN_WIDTH, SCREEN_HEIGHT), MIN(SCREEN_WIDTH, SCREEN_HEIGHT));
    
    if (self.view) {
        //[self.view.btnPlay addTarget:self action:@selector(btnPlay_Tapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view.btnPlayCenter addTarget:self action:@selector(btnPlay_Tapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view.btnZoom addTarget:self action:@selector(btnZoom_Tapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view.btnBack addTarget:self action:@selector(btnBack_Tapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view.btnPrevious addTarget:self action:@selector(btnPreviours_Tapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view.btnNext addTarget:self action:@selector(btnNext_Tapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view.slDuration addTarget:self action:@selector(beginScrubbing) forControlEvents:UIControlEventTouchDown];
        [self.view.slDuration addTarget:self action:@selector(endScrubbing) forControlEvents:UIControlEventTouchCancel];
        [self.view.slDuration addTarget:self action:@selector(endScrubbing) forControlEvents:UIControlEventTouchUpInside];
        [self.view.slDuration addTarget:self action:@selector(endScrubbing) forControlEvents:UIControlEventTouchUpOutside];
        [self.view.slDuration addTarget:self action:@selector(scrub) forControlEvents:UIControlEventTouchDragInside];
        [self.view.btnHD addTarget:self action:@selector(btnHD_Tapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view.btnShare addTarget:self action:@selector(btnShare_Tapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view.btnLike addTarget:self action:@selector(btnLike_Tapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view.bufferProgress setProgress:0.0];
    }
}

-(void)stop{
    FORE_STOP = YES;
    if (self.mPlayer && [self isPlaying]) {
        [self.mPlayer pause];
    }
}

-(void)setURL:(NSURL *)URL{
    FORE_STOP = NO;
    if (mURL != URL) {
        
        mURL = [URL copy];
        if (self.mPlayer && [self isPlaying]) {
            [self.mPlayer pause];
        }
        if (self.view) {
            [self.view.playerLayerView showLoading:YES];
        }
        LOADING_ASSET = YES;
        /*
         Create an asset for inspection of a resource referenced by a given URL.
         Load the values for the asset keys "tracks", "playable".
         */
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mURL options:nil];
        urlLoading = URL.absoluteString;
        
        NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
        /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
            dispatch_async( dispatch_get_main_queue(),
                           ^{
                               /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                               if (FORE_STOP) {
                                   return;
                               }
                               if (![urlLoading isEqualToString:asset.URL.absoluteString]) {
                                   return;
                               }
                              
                               [self prepareToPlayAsset:asset withKeys:requestedKeys];
                           });
        }];
    }
}

#pragma mark Prepare to play asset, URL

/*
 Invoked at the completion of the loading of the values for all keys on the asset that we require.
 Checks whether loading was successfull and whether the asset is playable.
 If so, sets up an AVPlayerItem and an AVPlayer to play the asset.
 */
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
    for (NSString *thisKey in requestedKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed) {
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
        /* If you are also implementing -[AVAsset cancelLoading], add your code here to bail out properly in the case of cancellation. */
    }
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable) {
        /* Generate an error describing the failure. */
		NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
		NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey,
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
								   nil];
		NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
    
    /* At this point we're ready to set up for playback of the asset. */
    
    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (self.mPlayerItem) {
        /* Remove existing player item key value observers and notifications. */
        [self.mPlayerItem removeObserver:self forKeyPath:kStatusKey];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.mPlayerItem];
        [self.mPlayerItem removeObserver:self forKeyPath:kPlaybackLikelyToKeepUp];
    }
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.mPlayerItem addObserver:self
                       forKeyPath:kStatusKey
                          options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                          context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
    
    
    /* Observe the AVplayer "playbackLikelyToKeepUp" */
    [self.mPlayerItem addObserver:self forKeyPath:kPlaybackLikelyToKeepUp options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlaybackViewControllerCurrentItemKeepUpObservationContext];
    
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.mPlayerItem];
    /* Create new player, if we don't already have one. */
    if (!self.mPlayer) {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.mPlayerItem]];
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        [self.player addObserver:self
                      forKeyPath:kCurrentItemKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [self.player addObserver:self
                      forKeyPath:kRateKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
        
        
        
//        playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//        [self.layer addSublayer:playerLayer];
//        [self bringSubviewToFront:_viewControl];
        
//        [[self activePlayerView].playerLayerView setPlayer:self.player];
    }
    
    [self startNotificationObservers];
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.player.currentItem != self.mPlayerItem) {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [self.player replaceCurrentItemWithPlayerItem:self.mPlayerItem];
    }
    [self.player play];
    LOADING_ASSET = NO;
}

- (NPPlayerView*)activePlayerView {
//    if (self.externalMonitor.isConnected) {
//        return self.externalMonitor.externalView;
//    } else {
        return self.view;
//    }
}

- (void)startNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                selector:@selector(playerContinue)
                                    name:PlayerContinueNotification
                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                selector:@selector(playerHanging)
                                    name:PlayerHangingNotification
                                  object:nil];
}

#pragma mark -
#pragma mark Asset Key Value Observing
#pragma mark

#pragma mark Key Value Observer for player rate, currentItem, player item status

/* ---------------------------------------------------------
 **  Called when the value at the specified key path relative
 **  to the given object has changed.
 **  Adjust the movie play and pause button controls when the
 **  player item "status" value changes. Update the movie
 **  scrubber control when the player item is ready to play.
 **  Adjust the movie scrubber control when the player item
 **  "rate" value changes. For updates of the player
 **  "currentItem" property, set the AVPlayer for which the
 **  player layer displays visual output.
 **  NOTE: this method is invoked on the main queue.
 ** ------------------------------------------------------- */

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
	/* AVPlayerItem "status" property value observer. */
    if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext) {
        [self syncPlayPauseButtons];
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
            {
                [self removePlayerTimeObserver];
                [self syncScrubber];
                [self disableScrubber];
                [self disablePlayerButtons];
            }
                break;
                
            case AVPlayerStatusReadyToPlay:
            {
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                
                [self initScrubberTimer];
                [self enableScrubber];
                [self enablePlayerButtons];
                
            }
                break;
                
            case AVPlayerStatusFailed:
            {
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
        }
        
    }/* AVPlayer "rate" property value observer. */
	else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext)
	{
        [self syncPlayPauseButtons];
        
    } else if (context == AVPlaybackViewControllerCurrentItemKeepUpObservationContext) {
        if (self.mPlayer.currentItem.playbackLikelyToKeepUp == NO && CMTIME_COMPARE_INLINE(self.mPlayer.currentTime,>,kCMTimeZero) && CMTIME_COMPARE_INLINE(self.mPlayer.currentTime, !=, self.mPlayer.currentItem.duration)) {
            //[[NSNotificationCenter defaultCenter]postNotificationName:PlayerHangingNotification object:self.mPlayer];
        } else if (self.mPlayer.currentItem.playbackLikelyToKeepUp == NO){
            [self.mPlayer play];
        }
        
    }
	/* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
	else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
	{
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
            [self disablePlayerButtons];
            [self disableScrubber];
        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
            //            AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
            //
            //            [playerLayer setPlayer:self.mPlayer];
            //            playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            //            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.mPlayer];
            //            [playerLayer setFrame:self.frame];
            //            [self.layer addSublayer:playerLayer];
            //            [self.mPlaybackView setPlayer:mPlayer];
            //
            //            [self setViewDisplayName];
            //
            //            /* Specifies that the player should preserve the video’s aspect ratio and
            //             fit the video within the layer’s bounds. */
            //            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            [self.view.playerLayerView showLoading:NO];
            [[self activePlayerView].playerLayerView setPlayer:self.player];
            [self syncPlayPauseButtons];
            [self checkSecondsContinue];
            //[APPDELEGATE showTutorial:TUTORIAL_2];
        }
	}
	else
	{
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
	}
}

- (void)playerHanging {
    [self.mPlayer pause];
    // start an activity indicator / busy view
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayerContinueNotification object:self.player];
}

// playerContinue does the actual waiting and restarting
- (void)playerContinue {
    if (CMTIME_COMPARE_INLINE(self.player.currentTime, ==, self.player.currentItem.duration)) { // we've reached the end
        
        //stop
        
    }  else if (self.player.currentItem.playbackLikelyToKeepUp == YES) {
    
        // Here I stop/remove the activity indicator I put up in playerHanging
        [self.mPlayer play]; // continue from where we left off
    
    } else { // still hanging, not at end
    
        // create a 0.5-second delay to see if buffering catches up
        // then post another playerContinue notification to call this method again
        // in a manner that attempts to avoid any recursion or threading nightmares
        //playerTryCount += 1;
//        double delayInSeconds = 0.5;
//        dispatch_time_t executeTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(executeTime, dispatch_get_main_queue(), ^{
//        
//        // test playerTryCount again to protect against changes that might have happened during the 0.5 second delay
//        if (playerTryCount > 0) {
//            if (playerTryCount <= 10) {
//                [self.notificationCenter postNotificationName:PlayerContinueNotification object:self.videoPlayer];
//            } else {
//                [self stopPlaying];
//                // put up "sorry" alert
//            }
//        }
//    });
    }
}

- (void)checkSecondsContinue{
    NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
    if (nowVC) {
        double seconds = [[DBHelper sharedInstance] getSecondsContinueVideo:[nowVC getCurrentVideo]];
        int duration = [[DBHelper sharedInstance]getSecondsDurationOfVideo:[nowVC getCurrentVideo]];
        int intSecond = (int)seconds;
        if (seconds < 0 || (intSecond == duration) || (intSecond == (duration - 1)) || (intSecond == (duration + 1) )) {
            seconds = 0;
        }
        
        [self.player.currentItem seekToTime:CMTimeMakeWithSeconds(seconds, 60000)];
    
//        [[DBHelper sharedInstance] addVideoToHistory:[nowVC getCurrentVideo] withStopTime:seconds withShowId:nowVC.curShow.show_id withShowDetail:[nowVC getJsonCurShow] withSeasonDetail:[nowVC getJsonCurSeason]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHistoryNotification object:nil];
    }
    
}

#pragma mark -
#pragma mark Loading the Asset Keys Asynchronously

#pragma mark -
#pragma mark Error Handling - Preparing Assets for Playback Failed

/* --------------------------------------------------------------
 **  Called when an asset fails to prepare for playback for any of
 **  the following reasons:
 **
 **  1) values of asset keys did not load successfully,
 **  2) the asset keys did load successfully, but the asset is not
 **     playable
 **  3) the item did not become ready to play.
 ** ----------------------------------------------------------- */

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    if ([_delegate canPlayNextItem]) {
        [_delegate playNextItem];
    }else{
        [self.view.playerLayerView showError:YES withMessage:@"Không thể play video này!"];
        FORE_STOP = YES;
    }
    
}

#pragma mark Player Item

- (BOOL)isPlaying
{
	return mRestoreAfterScrubbingRate != 0.f || [self.mPlayer rate] != 0.f;
}

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
	/* After the movie has played to its end time, seek back to time zero
     to play it again. */
	seekToZeroBeforePlay = YES;
    if ([APPDELEGATE.nowPlayerVC.type isEqualToString:@"OFFLINE"]) {
        return;
    }
    if (!LOADING_ASSET) {
        BOOL canNext = [_delegate canPlayNextItem];
        if (canNext) {
            [_delegate playNextItem];
        }else{
            [self btnBack_Tapped];
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowControlPlayerNotification object:nil];
        }
    }
}

/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem.
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration
{
	AVPlayerItem *playerItem = [self.mPlayer currentItem];
	if (playerItem.status == AVPlayerItemStatusReadyToPlay)
	{
        /*
         NOTE:
         Because of the dynamic nature of HTTP Live Streaming Media, the best practice
         for obtaining the duration of an AVPlayerItem object has changed in iOS 4.3.
         Prior to iOS 4.3, you would obtain the duration of a player item by fetching
         the value of the duration property of its associated AVAsset object. However,
         note that for HTTP Live Streaming Media the duration of a player item during
         any particular playback session may differ from the duration of its asset. For
         this reason a new key-value observable duration property has been defined on
         AVPlayerItem.
         
         See the AV Foundation Release Notes for iOS 4.3 for more information.
         */
        
		return([playerItem duration]);
	}
	
	return(kCMTimeInvalid);
}


/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
	if (mTimeObserver)
	{
		[self.mPlayer removeTimeObserver:mTimeObserver];
		mTimeObserver = nil;
	}
}

/* If the media is playing, show the stop button; otherwise, show the play button. */
- (void)syncPlayPauseButtons
{
	if ([self isPlaying])
	{
        [self.view showPlayButton:NO];
	}
	else
	{
        [self.view showPlayButton:YES];
	}
}

-(void)enablePlayerButtons
{
    self.view.btnPlayCenter.enabled = YES;
    self.view.btnNext.enabled = YES;
    self.view.btnPrevious.enabled = YES;
}

-(void)disablePlayerButtons
{
    self.view.btnPlayCenter.enabled = NO;
    self.view.btnNext.enabled = YES;
    self.view.btnPrevious.enabled = YES;
}

-(void)play{
    if (FORE_STOP) {
        return;
    }
    /* If we are at the end of the movie, we must seek to the beginning first
     before starting playback. */
	if (YES == seekToZeroBeforePlay)
	{
		seekToZeroBeforePlay = NO;
		[self.mPlayer seekToTime:kCMTimeZero];
	}
    
	[self.mPlayer play];
}

-(void)pause{
    [self.mPlayer pause];
    [self.view setControlsHidden:NO autoHide:YES];
}

#pragma mark -
#pragma mark Movie scrubber control

/* ---------------------------------------------------------
 **  Methods to handle manipulation of the movie scrubber control
 ** ------------------------------------------------------- */

/* Requests invocation of a given block during media playback to update the movie scrubber control. */
-(void) initScrubberTimer
{
//    // load subtitle
//    NSString *subtitleString = [ParserObject loadSubtitleFile:@"example"];
//    if (subtitleString) {
//        [ParserObject parseString:subtitleString parsed:^(NSMutableDictionary *subParts, NSError*error){
//            if (!error) {
//                _str_Subtitle = subParts;
//                
//            } else {
//                NSLog(@"ERROR SUB %@", @"");
//            }
//        }];
//    }
	double interval = 1.0f;
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
		return;
	}
    // set timer to hide controll
    if (!self.view.isControlsHidden) {
        if ([self.view.timerToHide isValid]) {
            [self.view.timerToHide invalidate];
        }
        self.view.timerToHide = nil;
        self.view.timerToHide = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideControll) userInfo:nil repeats:NO];
    }
    
	/* Update the scrubber during normal playback. */
    __weak __typeof(self) weakself = self;
	mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                               queue:NULL /* If you pass NULL, the main queue is used. */
                                                          usingBlock:^(CMTime time)
                     {
                         [weakself syncScrubber];
                     }];
    
}

/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
    //NSLog(@"loaded timerange %f", [self availableDuration]);
    float progress = [self availableDuration]/CMTimeGetSeconds(self.player.currentItem.duration);
    [self.view.bufferProgress setProgress:progress];
    [self.view.bufferProgress setProgressTintColor:[UIColor blackColor]];
    
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
		self.view.slDuration.minimumValue = 0.0;
		return;
	}
    
	double duration = CMTimeGetSeconds(playerDuration);
    
	if (isfinite(duration))
	{
		float minValue = [self.view.slDuration minimumValue];
		float maxValue = [self.view.slDuration maximumValue];
		double time = CMTimeGetSeconds([self.mPlayer currentTime]);
		
		[self.view.slDuration setValue:(maxValue - minValue) * time / duration + minValue];
	}
    NSString *time = [NSString stringWithFormat:@"%@", [self getStringFromCMTime:self.mPlayer.currentTime]];
    [self.view.lbTimeDuration setText:time];
    NSString *total = [NSString stringWithFormat:@"%@", [self getStringFromCMTime:self.mPlayer.currentItem.asset.duration]];
    [self.view.lbTotalDuration setText:total];
    
    
    // File to string
    NSString *subtitleString = APPDELEGATE.nowPlayerVC.subtitle;
    if (subtitleString) {
        [ParserObject parseString:subtitleString parsed:^(NSMutableDictionary *subParts, NSError*error){
            if (!error) {
                //            // Search for timeInterval
                double currentTime = CMTimeGetSeconds([self.mPlayer.currentItem currentTime]);
                NSPredicate *initialPredicate = [NSPredicate predicateWithFormat:@"(%@ >= %K) AND (%@ <= %K)", @(currentTime), kStart, @(currentTime), kEnd];
                NSArray *objectsFound = [[subParts allValues] filteredArrayUsingPredicate:initialPredicate];
                NSDictionary *lastFounded = (NSDictionary *)[objectsFound lastObject];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Show text
                    if (lastFounded) {
                        // Get text
                        [_view.lblTitle setText:[lastFounded objectForKey:kText]];
                    } else {
                        [_view.lblTitle setText:@""];
                    }
                    
                });
                
            } else {
                [_view.lblTitle setText:@""];
            }
        }];
    }
    else {
       [_view.lblTitle setText:@""];
    }
    
}

- (void)hideControll {
    [self.view hideControll];
}

- (CMTime) timeCurrent{
    return self.mPlayer.currentTime;
}
- (CMTime) timeDuration{
    return self.mPlayer.currentItem.asset.duration;
}

- (NSTimeInterval) availableDuration;
{
//    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
//    CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
//    Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
//    Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
//    NSTimeInterval result = startSeconds + durationSeconds;
//    return result;
    NSValue *range = self.player.currentItem.loadedTimeRanges.firstObject;
    if (range != nil){
        return CMTimeGetSeconds(CMTimeRangeGetEnd(range.CMTimeRangeValue));
    }
    return CMTimeGetSeconds(kCMTimeZero);
}

-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int hour = mins/60.0;
    if (hour > 0) {
        mins = mins % 60;
    }
    int secs = fmodf(currentSeconds, 60.0);
    NSString *hourString = hour < 10 ? [NSString stringWithFormat:@"0%d", hour] : [NSString stringWithFormat:@"%d", hour];
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    if (hour > 0) {
        return [NSString stringWithFormat:@"%@:%@:%@", hourString, minsString, secsString];
    }
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}

/* The user is dragging the movie controller thumb to scrub through the movie. */
- (void)beginScrubbing
{
	mRestoreAfterScrubbingRate = [self.mPlayer rate];
	[self.mPlayer setRate:0.f];
	
	/* Remove previous timer. */
	[self removePlayerTimeObserver];
}

/* Set the player current time to match the scrubber position. */
- (void)scrub
{
	UISlider* slider = self.view.slDuration;
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        float minValue = [slider minimumValue];
        float maxValue = [slider maximumValue];
        float value = [slider value];
        
        double time = duration * (value - minValue) / (maxValue - minValue);
        
        [self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
    }
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (void)endScrubbing
{
	if (!mTimeObserver)
	{
		CMTime playerDuration = [self playerItemDuration];
		if (CMTIME_IS_INVALID(playerDuration))
		{
			return;
		}
		
		double duration = CMTimeGetSeconds(playerDuration);
		if (isfinite(duration))
		{
//			CGFloat width = CGRectGetWidth([self.view.slDuration bounds]);
//			double tolerance = 0.5f * duration / width;
            __weak __typeof(self) weakself = self;
			mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0f, NSEC_PER_SEC) queue:NULL usingBlock:
                             ^(CMTime time)
                             {
                                 [weakself syncScrubber];
                             }];
		}
	}
    
	if (mRestoreAfterScrubbingRate)
	{
		[self.mPlayer setRate:mRestoreAfterScrubbingRate];
		mRestoreAfterScrubbingRate = 0.f;
	}
}

- (BOOL)isScrubbing
{
	return mRestoreAfterScrubbingRate != 0.f;
}

-(void)enableScrubber
{
    self.view.slDuration.enabled = YES;
}

-(void)disableScrubber
{
    self.view.slDuration.enabled = NO;
}

- (void)myDealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[self removePlayerTimeObserver];
	[self.mPlayer removeObserver:self forKeyPath:@"rate"];
	[mPlayer.currentItem removeObserver:self forKeyPath:@"status"];
	[self.mPlayer pause];
	self.mPlayer = nil;
	
}


#pragma mark - Orientation


- (void)performOrientationChange:(UIInterfaceOrientation)deviceOrientation completion:(void (^)(BOOL))_completed{
    self.isFullScreen = UIInterfaceOrientationIsLandscape(deviceOrientation);
//    if (!self.forceRotate) {
//        return;
//    }
//    if (deviceOrientation == self.visibleInterfaceOrientation) {
//        return;
//    }
//    if (self.isAnimation) {
//        return;
//    }
    [self.view.layer removeAllAnimations];
    self.isAnimation = YES;
    self.visibleInterfaceOrientation = deviceOrientation;
    //[self.view performOrientationChange:deviceOrientation];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
//        CGRect bounds = [[UIScreen mainScreen] bounds];
//        CGRect parentBounds;
//        CGRect viewBoutnds;
        if (UIInterfaceOrientationIsLandscape(deviceOrientation)) {
//            viewBoutnds = CGRectMake(0, 0, CGRectGetWidth(self.landscapeFrame), CGRectGetHeight(self.landscapeFrame));
//            parentBounds = CGRectMake(0, 0, CGRectGetHeight(bounds), CGRectGetWidth(bounds));
            self.view.frame = self.landscapeFrame;
        } else {
//            viewBoutnds = CGRectMake(0, 0, CGRectGetWidth(self.portraitFrame), CGRectGetHeight(self.portraitFrame));
//            parentBounds = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
            self.view.frame = self.portraitFrame;
        }
//        self.view.bounds = viewBoutnds;
//        [self.view setFrameOriginX:0.0f];
        if (UIInterfaceOrientationIsLandscape(deviceOrientation)) {
            [self.view setFrameOriginY:0.0f];
        }else{
            [self.view setFrameOriginY:ORIGIN_Y];
        }
        
        //        [weakSelf layoutForOrientation:deviceOrientation];
        
    } completion:^(BOOL finished) {
//        if (finished) {
            self.isAnimation = NO;
            CGRect frame = self.view.frame;
            if (frame.origin.x != 0) {
                _completed(NO);
//                [self performOrientationChange:self.visibleInterfaceOrientation completion:_completed];
                if (!UIInterfaceOrientationIsLandscape(deviceOrientation)) {
//                    CGRect viewBoutnds;
//                    viewBoutnds = CGRectMake(0, 0, CGRectGetWidth(self.portraitFrame), CGRectGetHeight(self.portraitFrame));
//                    self.view.frame = viewBoutnds;
                }
            }else{
                _completed(YES);
            }
//        }
    }];
    [self.view setFullScreen:self.isFullScreen];
    
}


- (CGFloat)degreesForOrientation:(UIInterfaceOrientation)deviceOrientation {
    switch (deviceOrientation) {
        case UIInterfaceOrientationPortrait:
            return 0;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return -90;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return 180;
            break;
        default:
            return 0;
    }
}

-(void)setLikeForCurrentVideo:(BOOL)isLiked{
    if (isLiked) {
        [self.view.btnLike setImage:imageNameWithMaskBlueColor(@"playing_like") forState:UIControlStateNormal];
        [self.view.btnLike setImage:imageNameWithMaskBlueColor(@"playing_like_hover") forState:UIControlStateHighlighted];
    }else{
        [self.view.btnLike setImage:imageNameWithMaskWhiteColor(@"playing_like") forState:UIControlStateNormal];
        [self.view.btnLike setImage:imageNameWithMaskBlueColor(@"playing_like_hover") forState:UIControlStateHighlighted];
    }
}

#pragma mark - NPVideoPlayerView delegate
-(void)btnPlay_Tapped{
    FORE_STOP = NO;
    if ([self isPlaying]) {
        [self pause];
    }else{
        [self play];
    }
}

-(void)btnZoom_Tapped{
    self.isFullScreen = !self.isFullScreen;
    self.isZoomTap = !self.isZoomTap;
    //[[NSNotificationCenter defaultCenter] postNotificationName:kChangeModeScreenNotification object:nil userInfo:@{@"isFull":[NSNumber numberWithBool:self.isFullScreen],}];
//    if (self.isFullScreen) {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
//        
//    } else {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
//        
//    }
    if (UIInterfaceOrientationIsLandscape(APPDELEGATE.nowPlayerVC.orientation)) {
        [self foreRotationOrientation:UIInterfaceOrientationPortrait];
        APPDELEGATE.nowPlayerVC.orientation = UIInterfaceOrientationPortrait;
    }else{
        [self foreRotationOrientation:UIInterfaceOrientationLandscapeRight];
        APPDELEGATE.nowPlayerVC.orientation = UIInterfaceOrientationLandscapeRight;
    }
}


- (void)foreRotationOrientation:(UIInterfaceOrientation)orient{
    NSNumber *value = [NSNumber numberWithInteger:orient];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)btnBack_Tapped{
    if (self.view.isMinimize) {
        [self.view youtubeAnimationMaximize:YES];
        return;
    }
    if (_isFullScreen) {
        [self btnZoom_Tapped];
    }
}

- (void)btnNext_Tapped{
    if ([_delegate canPlayNextItem]) {
        [_delegate playNextItem];
    }
//    UISlider* slider = self.view.slDuration;
//    
//    CMTime playerDuration = [self playerItemDuration];
//    if (CMTIME_IS_INVALID(playerDuration)) {
//        return;
//    }
//    
//    double duration = CMTimeGetSeconds(playerDuration);
//    if (isfinite(duration))
//    {
//        float minValue = [slider minimumValue];
//        float maxValue = [slider maximumValue];
//        float value = [slider value] + 30/duration;
//        
//        double time = duration * (value - minValue) / (maxValue - minValue);
//        
//        [self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
//    }
}

- (void)btnPreviours_Tapped{
    if ([_delegate canPlayPreItem]) {
        [_delegate playPreItem];
    }
//    UISlider* slider = self.view.slDuration;
//    
//    CMTime playerDuration = [self playerItemDuration];
//    if (CMTIME_IS_INVALID(playerDuration)) {
//        return;
//    }
//    
//    double duration = CMTimeGetSeconds(playerDuration);
//    if (isfinite(duration))
//    {
//        float minValue = [slider minimumValue];
//        float maxValue = [slider maximumValue];
//        float value = [slider value] - 30/duration;
//        
//        double time = duration * (value - minValue) / (maxValue - minValue);
//        
//        [self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
//    }
}

- (void)showLoginViewWithTask:(NSString*)task {
    
    _loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    _loginVC.task = task;
    _loginVC.delegate = self;
    _loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [APPDELEGATE.nowPlayerVC presentViewController:_loginVC animated:YES completion:^{
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.loginView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        }];
    }];
}

- (void)btnLike_Tapped{
    [APPDELEGATE.nowPlayerVC trackEvent:@"iOS_add_video_to_watch_later"];
    APPDELEGATE.nowPlayerVC.player.view.btnLike.enabled = NO;
    if (!APPDELEGATE.isLogined) {
        [self foreRotationOrientation:UIInterfaceOrientationPortrait];
        APPDELEGATE.nowPlayerVC.orientation = UIInterfaceOrientationPortrait;
        [self showLoginViewWithTask:kTaskViewLater];
        APPDELEGATE.nowPlayerVC.player.view.btnLike.enabled = YES;
    } else {
        
        if (APPDELEGATE.nowPlayerVC.currentVideo.is_like) {
            [APPDELEGATE showToastWithMessage:@"Video đã có trong danh sách xem sau!" position:@"top" type:errorImage];
            APPDELEGATE.nowPlayerVC.player.view.btnLike.enabled = YES;
        } else {
            [[APIController sharedInstance] userSubcribeVideo:APPDELEGATE.nowPlayerVC.currentVideo.video_id subcribe:YES completed:^(int code, BOOL results) {
                if (results) {
                    APPDELEGATE.nowPlayerVC.currentVideo.is_like = YES;
                    [APPDELEGATE showToastWithMessage:@"Đã thêm vào danh sách xem sau" position:@"top" type:doneImage];
                    [APPDELEGATE.nowPlayerVC.player.view.btnLike setImage:results?[UIImage imageNamed:@"icon-xemsau-h-v2-1"]:[UIImage imageNamed:@"icon-xemsau-white-v2"] forState:UIControlStateNormal];
                    [APPDELEGATE.nowPlayerVC.btnViewLater setImage:results?[UIImage imageNamed:@"icon-xemsau-h-v2-1"]:[UIImage imageNamed:@"icon-xemsau-black-v2"] forState:UIControlStateNormal];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kDidSubcribeVideo object:nil];
                } else {
                    [APPDELEGATE showToastWithMessage:@"Xem sau không thành công!" position:@"top" type:errorImage];
                }
                APPDELEGATE.nowPlayerVC.player.view.btnLike.enabled = YES;
            } failed:^(NSError *error) {
                APPDELEGATE.nowPlayerVC.player.view.btnLike.enabled = YES;
            }];
        }
    }
}

- (void)btnShare_Tapped{
    MoreOptionView *moreOptionView = [[MoreOptionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) type:5 object:APPDELEGATE.nowPlayerVC.currentVideo linkShare:APPDELEGATE.nowPlayerVC.currentVideo.link_share];
    moreOptionView.delegate = self;
    [moreOptionView setTag: 1405];
    [APPDELEGATE.window addSubview:moreOptionView];
}
- (void)didTappedButtonIndex:(int)index object:(id)object linkShare:(NSString *)linkShare title:(NSString *)title{
    Video *video = [APPDELEGATE.nowPlayerVC getCurrentVideo];
    if (!video || !linkShare || [linkShare isEqualToString:@""]) {
        [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho video này." position:@"top" type:errorImage];
        return;
    }
    if (index == 1) {
        [[ShareTask sharedInstance] setViewController:APPDELEGATE.nowPlayerVC];
        [[ShareTask sharedInstance] shareFacebook:video];
    } else if (index == 2) {
        [APPDELEGATE.nowPlayerVC trackEvent:@"iOS_share_on_copy_link"];
        NSString *dataText = video.link_share;
        if (dataText) {
            [[UIPasteboard generalPasteboard] setString:dataText];
            [APPDELEGATE showToastWithMessage:@"Đã copy link" position:@"top" type:doneImage];
        }
    }
}
- (void)btnHD_Tapped {
    if (!self.view.popoverView) {
        NSArray *arrayQuality = APPDELEGATE.nowPlayerVC.currentVideo.videoStream.streamUrls;
        if (arrayQuality.count > 0) {
            self.view.popoverView = [[FWTPopoverView alloc] init];
            for (int i = 0; i < arrayQuality.count; i++) {
                QualityURL *qlt = [arrayQuality objectAtIndex:i];
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*40, 70, 40)];
                btn.backgroundColor = [UIColor clearColor];
                [btn setTitle:qlt.type forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont fontWithName:kFontRegular size:15];
                if ([qlt.type containsString:@"720"] || [qlt.type containsString:@"1080"]) {
                    UIImageView *imvHD = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width - 17, 5, 12, 8)];
                    [imvHD setImage:[UIImage imageNamed:@"icon-hd-thumb"]];
                    [btn addSubview:imvHD];
                }
                [self.view.popoverView.contentView addSubview:btn];
                if (!_curTypeQuality) {
                    if (i == 0) {
                        _curTypeQuality = qlt.type;
                        [btn setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
                    }
                } else {
                    if ([_curTypeQuality isEqualToString:qlt.type]) {
                        [btn setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
                    }
                }
                btn.clipsToBounds = YES;
                btn.layer.cornerRadius = 5.0;
                [btn addTarget:self action:@selector(btnQualityAction:) forControlEvents:UIControlEventTouchUpInside];
                if (i < arrayQuality.count -1) {
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, btn.frame.size.height-0.5, btn.frame.size.width, 0.5)];
                    line.backgroundColor = RGBA(240, 240, 240, 0.1);
                    [btn addSubview:line];
                }
            }
            self.view.popoverView.contentSize = CGSizeMake(70, arrayQuality.count *40);
            [self.view.popoverView presentFromRect:CGRectMake(self.view.btnHD.frame.origin.x, self.view.viewFooter.frame.origin.y + self.view.btnHD.frame.origin.y -4, self.view.btnHD.frame.size.width, self.view.btnHD.frame.size.height)
                                            inView:self.view
                           permittedArrowDirection:FWTPopoverArrowDirectionDown
                                          animated:YES];
        }
    }
}

- (void)btnQualityAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if ([_curTypeQuality isEqualToString:btn.titleLabel.text]) {
        return;
    } else {
        _curTypeQuality = btn.titleLabel.text;
        NSArray *arrayQuality = APPDELEGATE.nowPlayerVC.currentVideo.videoStream.streamUrls;
        for (int i = 0; i < arrayQuality.count; i++) {
            QualityURL *qlt = [arrayQuality objectAtIndex:i];
            if ([_curTypeQuality isEqualToString:qlt.type]) {
                NSString *link = qlt.link;
                if (link) {
                    CMTime curTime = APPDELEGATE.nowPlayerVC.player.mPlayer.currentTime;
                    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:link]];
                    [APPDELEGATE.nowPlayerVC.player.mPlayer replaceCurrentItemWithPlayerItem:item];
                    [APPDELEGATE.nowPlayerVC.player.mPlayer seekToTime:curTime];
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(playerItemDidReachEnd:)
                                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                                               object:item];
                    [self.view.btnHD setTitle:_curTypeQuality forState:UIControlStateNormal];
                    if ([_curTypeQuality containsString:@"720"] || [_curTypeQuality containsString:@"1080"]) {
                        self.view.iconHD.hidden = NO;
                    } else {
                        self.view.iconHD.hidden = YES;
                    }
                }
                break;
            }
        }
    }
    [self.view.popoverView dismissPopoverAnimated:YES];
    self.view.popoverView = nil;
}

- (void)didLoginSuccessWithTask:(NSString *)task {
    if (_loginVC) {
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_loginVC dismissViewControllerAnimated:YES completion:^{
                [_loginVC.view removeFromSuperview];
                _loginVC = nil;
            }];
            if ([task isEqualToString:kTaskViewLater]) {
                [self btnLike_Tapped];
                [APPDELEGATE.nowPlayerVC loadChannelDetail:APPDELEGATE.nowPlayerVC.curChannel.channelId];
            } else if ([task isEqualToString:kTaskFolow]){
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self doTask:[actionSheet buttonTitleAtIndex:buttonIndex]];
}

- (void) doTask:(NSString *) task
{
    if ([task isEqualToString:MENU_FB])
    {
        Video *video = [APPDELEGATE.nowPlayerVC getCurrentVideo];
        if (!video) {
            return;
        }
        [[ShareTask sharedInstance] setViewController:APPDELEGATE.nowPlayerVC];
        [[ShareTask sharedInstance] shareFacebook:video];
    }
    else if ([task isEqualToString:MENU_COPY])
    {
        Video *video = [APPDELEGATE.nowPlayerVC getCurrentVideo];
        NSString *dataText = video.link_share;
        [[UIPasteboard generalPasteboard] setString:dataText];
        [APPDELEGATE showToastWithMessage:@"Đã copy link" position:@"top" type:doneImage];
    }
}

- (BOOL)canRotation{
    return !self.view.isTouch && !self.view.isAnimation && !(self.view.frame.origin.x < 0);
}
@end
